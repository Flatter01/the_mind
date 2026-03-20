import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/auth/data/auth_repository.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_stae.dart';

class AddPaymentDialogResponsive extends StatefulWidget {
  final List<StudentModel> students;
  final VoidCallback? onPaymentSuccess;

  const AddPaymentDialogResponsive({
    super.key,
    required this.students,
    this.onPaymentSuccess,
  });

  @override
  State<AddPaymentDialogResponsive> createState() =>
      _AddPaymentDialogResponsiveState();
}

class _AddPaymentDialogResponsiveState extends State<AddPaymentDialogResponsive>
    with SingleTickerProviderStateMixin {
  final _searchCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  String _search = '';
  StudentModel? _selected;
  String _payMethod = 'cash';
  DateTime? _date;
  bool _isLoading = false;
  bool _showDropdown = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final _auth = AuthRepository();

  static const _orange = Color(0xFFED6A2E);
  static const _orangeLight = Color(0xFFFFF3EE);
  static const _bg = Color(0xFFF7F8FA);
  static const _border = Color(0xFFE8EAF0);
  static const _text = Color(0xFF1A1F36);
  static const _grey = Color(0xFF8A94A6);

  // ✅ ФИКС: уточните у бэкенда нужное значение для перевода
  // Обычно это 'online', 'bank_transfer' или 'transfer'
  final _payMethods = [
    {'value': 'cash', 'label': 'Наличные', 'icon': Icons.payments_outlined},
    {'value': 'card', 'label': 'Карта', 'icon': Icons.credit_card_outlined},
    {'value': 'bank', 'label': 'Перевод', 'icon': Icons.swap_horiz_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _amountCtrl.dispose();
    _searchFocus.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  List<StudentModel> get _filtered {
    if (_search.isEmpty) return [];
    return widget.students.where((s) {
      final q =
          '${s.lastName ?? ''} ${s.firstName ?? ''} ${s.phone ?? ''} ${s.groupName ?? ''}'
              .toLowerCase();
      return q.contains(_search.toLowerCase());
    }).toList();
  }

  void _selectStudent(StudentModel s) {
    setState(() {
      _selected = s;
      _search = '${s.lastName ?? ''} ${s.firstName ?? ''}';
      _searchCtrl.text = _search;
      _showDropdown = false;
    });
    _animCtrl.reverse();
    _searchFocus.unfocus();
  }

  void _clearStudent() {
    setState(() {
      _selected = null;
      _search = '';
      _searchCtrl.clear();
      _showDropdown = false;
    });
    _animCtrl.reverse();
  }

  int get _rawBalance {
    if (_selected == null) return 0;
    final paid = double.tryParse(_selected!.paidAmount ?? '0') ?? 0;
    final total =
        double.tryParse(
          _selected!.finalPrice ?? _selected!.groupPrice ?? '0',
        ) ??
        0;
    return (paid - total).toInt();
  }

  Future<void> _submit() async {
    if (_selected == null) {
      _showError('Выберите студента');
      return;
    }
    if (_amountCtrl.text.trim().isEmpty) {
      _showError('Введите сумму');
      return;
    }
    if (_date == null) {
      _showError('Выберите дату');
      return;
    }

    final adminId = _auth.userId;
    if (adminId == null || adminId.isEmpty) {
      _showError('Ошибка авторизации — войдите заново');
      return;
    }

    setState(() => _isLoading = true);

    final d = _date!;
    final paymentMonth =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    try {
      await context.read<PaymentCubit>().createPayment(
        student: _selected!.id ?? 0,
        group: _selected!.groupId ?? '',
        administrator: adminId,
        amount: _amountCtrl.text.trim(),
        payWith: _payMethod,
        paymentMonth: paymentMonth,
        checkGiven: true,
      );

      if (!mounted) return;

      final state = context.read<PaymentCubit>().state;

      if (state is PaymentSuccess) {
        widget.onPaymentSuccess?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Платёж успешно сохранён'),
            backgroundColor: _orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      } else if (state is PaymentError) {
        _showError(state.message);
      }
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      child: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentError) _showError(state.message);
        },
        child: SizedBox(
          width: 480,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header ──
              Container(
                padding: const EdgeInsets.fromLTRB(28, 24, 16, 20),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: _border, width: 1)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _orangeLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.payments_outlined,
                        color: _orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Новый платёж',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _text,
                          ),
                        ),
                        Text(
                          'Введите данные оплаты',
                          style: TextStyle(fontSize: 12, color: _grey),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Body ──
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('СТУДЕНТ'),
                      const SizedBox(height: 8),
                      _buildStudentSearch(),

                      if (_selected != null) ...[
                        const SizedBox(height: 12),
                        _buildStudentCard(),
                      ],

                      const SizedBox(height: 20),

                      _label('МЕТОД ОПЛАТЫ'),
                      const SizedBox(height: 10),
                      _buildPayMethodSelector(),

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('СУММА'),
                                const SizedBox(height: 8),
                                _buildAmountField(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('ДАТА'),
                                const SizedBox(height: 8),
                                _buildDatePicker(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Footer ──
              Container(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: _border, width: 1)),
                ),
                child: Row(
                  children: [
                    if (_amountCtrl.text.isNotEmpty) ...[
                      const Icon(
                        Icons.receipt_long_outlined,
                        size: 14,
                        color: _grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_amountCtrl.text} сум',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _orange,
                        ),
                      ),
                    ],
                    const Spacer(),
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      child: Text(
                        'Отмена',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildSaveButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentSearch() {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _showDropdown ? _orange : _border,
              width: _showDropdown ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(
                Icons.search,
                size: 18,
                color: _showDropdown ? _orange : _grey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _selected != null
                    ? Text(
                        '${_selected!.lastName ?? ''} ${_selected!.firstName ?? ''}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _text,
                        ),
                      )
                    : TextField(
                        controller: _searchCtrl,
                        focusNode: _searchFocus,
                        style: const TextStyle(fontSize: 14, color: _text),
                        decoration: const InputDecoration(
                          hintText: 'Имя, телефон или группа...',
                          hintStyle: TextStyle(fontSize: 14, color: _grey),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (v) {
                          setState(() {
                            _search = v;
                            _showDropdown = v.isNotEmpty;
                          });
                          if (v.isNotEmpty) {
                            _animCtrl.forward();
                          } else {
                            _animCtrl.reverse();
                          }
                        },
                      ),
              ),
              if (_selected != null || _search.isNotEmpty)
                GestureDetector(
                  onTap: _clearStudent,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(Icons.close, size: 16, color: Colors.grey[400]),
                  ),
                )
              else
                const SizedBox(width: 14),
            ],
          ),
        ),
        if (_showDropdown && _selected == null)
          FadeTransition(
            opacity: _fadeAnim,
            child: _filtered.isEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                    ),
                    child: const Center(
                      child: Text(
                        'Студент не найден',
                        style: TextStyle(fontSize: 13, color: _grey),
                      ),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      itemBuilder: (_, i) {
                        final s = _filtered[i];
                        return InkWell(
                          onTap: () => _selectStudent(s),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: _orangeLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (s.firstName ?? '?')[0].toUpperCase(),
                                      style: const TextStyle(
                                        color: _orange,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${s.lastName ?? ''} ${s.firstName ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: _text,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${s.phone ?? ''} · ${s.groupName ?? '—'}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: _grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
      ],
    );
  }

  Widget _buildStudentCard() {
    final s = _selected!;
    final balance = _rawBalance;
    final isDebt = balance < 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _orangeLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _orange.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                (s.firstName ?? '?')[0].toUpperCase(),
                style: const TextStyle(
                  color: _orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.lastName ?? ''} ${s.firstName ?? ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${s.phone ?? ''} · ${s.groupName ?? '—'}',
                  style: const TextStyle(fontSize: 12, color: _grey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Долг',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isDebt ? '${balance.abs()} сум' : '0 сум',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDebt ? Colors.redAccent : const Color(0xFF2ECC8A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayMethodSelector() {
    return Row(
      children: _payMethods.asMap().entries.map((entry) {
        final i = entry.key;
        final m = entry.value;
        final isActive = _payMethod == m['value'];
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _payMethod = m['value'] as String),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: EdgeInsets.only(
                right: i < _payMethods.length - 1 ? 10 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isActive ? _orange : _bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isActive ? _orange : _border),
              ),
              child: Column(
                children: [
                  Icon(
                    m['icon'] as IconData,
                    size: 20,
                    color: isActive ? Colors.white : _grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    m['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : _grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmountField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: _amountCtrl,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: _text,
        ),
        decoration: const InputDecoration(
          hintText: '0',
          hintStyle: TextStyle(color: _grey, fontWeight: FontWeight.w400),
          prefixIcon: Icon(
            Icons.monetization_on_outlined,
            size: 18,
            color: _grey,
          ),
          suffixText: 'сум',
          suffixStyle: TextStyle(fontSize: 12, color: _grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime(now.year + 1),
          initialDate: now,
          builder: (ctx, child) => Theme(
            data: Theme.of(
              ctx,
            ).copyWith(colorScheme: const ColorScheme.light(primary: _orange)),
            child: child!,
          ),
        );
        if (picked != null) setState(() => _date = picked);
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _date != null ? _orangeLight : _bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _date != null ? _orange.withOpacity(0.3) : _border,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: _date != null ? _orange : _grey,
            ),
            const SizedBox(width: 10),
            Text(
              _date == null
                  ? 'Выбрать'
                  : '${_date!.day.toString().padLeft(2, '0')}.${_date!.month.toString().padLeft(2, '0')}.${_date!.year}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: _date != null ? FontWeight.w600 : FontWeight.w400,
                color: _date != null ? _orange : _grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _submit,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        decoration: BoxDecoration(
          color: _isLoading ? _orange.withOpacity(0.6) : _orange,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _orange.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 16, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'Сохранить',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _grey,
        letterSpacing: 0.8,
      ),
    );
  }
}
