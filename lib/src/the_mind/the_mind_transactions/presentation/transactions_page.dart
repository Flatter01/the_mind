import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_transactions/data/models/transaction_model.dart';
import 'package:srm/src/the_mind/the_mind_transactions/data/transaction_api_service.dart';
import 'package:srm/src/the_mind/the_mind_transactions/presentation/cubit/transaction_cubit.dart';
import 'package:srm/src/the_mind/the_mind_transactions/presentation/cubit/transaction_state.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TransactionCubit(TransactionApiService())..getTransactions(),
      child: const _TransactionsView(),
    );
  }
}

class _TransactionsView extends StatefulWidget {
  const _TransactionsView();

  @override
  State<_TransactionsView> createState() => _TransactionsViewState();
}

class _TransactionsViewState extends State<_TransactionsView> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDate = '';
  int _currentPage = 1;
  final int _perPage = 5;

  List<TransactionModel> _filtered(List<TransactionModel> all) {
    final q = _searchController.text.toLowerCase();
    return all.where((t) {
      final matchSearch = q.isEmpty ||
          t.studentName.toLowerCase().contains(q) ||
          t.groupName.toLowerCase().contains(q);
      final matchDate =
          _selectedDate.isEmpty || t.dateFormatted == _selectedDate;
      return matchSearch && matchDate;
    }).toList();
  }

  int _totalPages(int filteredLen) =>
      (filteredLen / _perPage).ceil().clamp(1, 999);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        final allTransactions =
            state is TransactionLoaded ? state.transactions : <TransactionModel>[];

        final filtered = _filtered(allTransactions);
        final totalPages = _totalPages(filtered.length);
        final pageItems = filtered
            .skip((_currentPage - 1) * _perPage)
            .take(_perPage)
            .toList();

        // ── Аналитика ──
        final totalAmount =
            allTransactions.fold(0, (s, t) => s + t.amountInt);
        final cashAmount = allTransactions
            .where((t) => t.payWith == 'cash')
            .fold(0, (s, t) => s + t.amountInt);
        final cardAmount = allTransactions
            .where((t) => t.payWith == 'card')
            .fold(0, (s, t) => s + t.amountInt);
        final transferAmount = allTransactions
            .where((t) => t.payWith == 'transfer')
            .fold(0, (s, t) => s + t.amountInt);

        final now = DateTime.now();
        final todayAmount = allTransactions
            .where((t) {
              try {
                final d = DateTime.parse(t.createdAt).toLocal();
                return d.year == now.year &&
                    d.month == now.month &&
                    d.day == now.day;
              } catch (_) {
                return false;
              }
            })
            .fold(0, (s, t) => s + t.amountInt);

        final monthAmount = allTransactions
            .where((t) {
              try {
                final d = DateTime.parse(t.createdAt).toLocal();
                return d.year == now.year && d.month == now.month;
              } catch (_) {
                return false;
              }
            })
            .fold(0, (s, t) => s + t.amountInt);

        return Scaffold(
          backgroundColor: const Color(0xFFF2F5F7),
          body: state is TransactionLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFED6A2E),
                  ),
                )
              : state is TransactionError
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.redAccent, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(color: Colors.red)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<TransactionCubit>()
                                .getTransactions(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFED6A2E),
                            ),
                            child: const Text('Повторить',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 24),
                      children: [
                        // ── Заголовок ──
                        const Text(
                          'Транзакции',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A2233),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'История платежей и поступлений',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Карточки ──
                        Row(
                          children: [
                            Expanded(
                              child: _topCard(
                                'За сегодня',
                                todayAmount,
                                Icons.today_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _topCard(
                                'За месяц',
                                monthAmount,
                                Icons.calendar_month_outlined,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _topCardOrange(
                                'Всего получено',
                                totalAmount,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Методы оплаты + фильтры ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Методы
                            SizedBox(
                              width: 200,
                              child: Column(
                                children: [
                                  _categoryCard(
                                    Icons.account_balance_wallet_outlined,
                                    'Наличные',
                                    cashAmount,
                                    const Color(0xFFED6A2E),
                                  ),
                                  const SizedBox(height: 10),
                                  _categoryCard(
                                    Icons.credit_card_outlined,
                                    'Карта',
                                    cardAmount,
                                    const Color(0xFF6B7FD4),
                                  ),
                                  const SizedBox(height: 10),
                                  _categoryCard(
                                    Icons.swap_horiz_outlined,
                                    'Перевод',
                                    transferAmount,
                                    const Color(0xFF2ECC8A),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Фильтры
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: _filterField(
                                        label: 'Поиск студента',
                                        child: TextField(
                                          controller: _searchController,
                                          onChanged: (_) => setState(
                                            () => _currentPage = 1,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Имя или группа',
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[400],
                                            ),
                                            prefixIcon: Icon(
                                              Icons.search,
                                              size: 17,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      flex: 2,
                                      child: _filterField(
                                        label: 'Дата (дд.мм.гггг)',
                                        child: TextField(
                                          onChanged: (v) => setState(() {
                                            _selectedDate = v;
                                            _currentPage = 1;
                                          }),
                                          decoration: InputDecoration(
                                            hintText: '17.03.2026',
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[400],
                                            ),
                                            prefixIcon: Icon(
                                              Icons.calendar_today_outlined,
                                              size: 15,
                                              color: Colors.grey[400],
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: ElevatedButton.icon(
                                        onPressed: () =>
                                            setState(() => _currentPage = 1),
                                        icon: const Icon(Icons.tune,
                                            color: Colors.white, size: 15),
                                        label: const Text(
                                          'Применить',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFED6A2E),
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ── Таблица ──
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Заголовок таблицы
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    24, 20, 24, 16),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Последние транзакции',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A2233),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${filtered.length} записей',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Шапка
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.symmetric(
                                    horizontal: BorderSide(
                                      color: Colors.grey.withOpacity(0.08),
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: _ColH('СТУДЕНТ / ГРУППА')),
                                    Expanded(
                                        flex: 2,
                                        child: _ColH('ДАТА И ВРЕМЯ')),
                                    Expanded(
                                        flex: 2,
                                        child: _ColH('ТИП ОПЛАТЫ')),
                                    Expanded(flex: 2, child: _ColH('СУММА')),
                                  ],
                                ),
                              ),

                              // Строки
                              if (pageItems.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(40),
                                  child: Center(
                                    child: Text(
                                      'Транзакций нет',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ...pageItems.map(_transactionRow),

                              // Пагинация
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    24, 14, 24, 18),
                                child: Row(
                                  children: [
                                    Text(
                                      'Показано ${pageItems.length} из ${filtered.length}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                    const Spacer(),
                                    _buildPagination(totalPages),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
        );
      },
    );
  }

  // ── Строка транзакции ─────────────────────────────────────────────────────

  Widget _transactionRow(TransactionModel t) {
    final colors = [
      const Color(0xFFED6A2E),
      const Color(0xFF6B7FD4),
      const Color(0xFF2ECC8A),
      const Color(0xFFFF9800),
    ];
    final name = t.studentName;
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase()
        : '?';
    final color = colors[name.length % colors.length];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.06)),
        ),
      ),
      child: Row(
        children: [
          // Студент / группа
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.studentName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2233),
                      ),
                    ),
                    Text(
                      t.groupName,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Дата / время
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.dateFormatted,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A2233),
                  ),
                ),
                Text(
                  t.timeFormatted,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),

          // Тип оплаты
          Expanded(
            flex: 2,
            child: _methodBadge(t.payWith, t.payWithDisplay),
          ),

          // Сумма
          Expanded(
            flex: 2,
            child: Text(
              t.amountFormatted,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2ECC8A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Виджеты ───────────────────────────────────────────────────────────────

  Widget _methodBadge(String method, String display) {
    Color color;
    IconData icon;

    switch (method) {
      case 'card':
        color = const Color(0xFF6B7FD4);
        icon = Icons.credit_card_outlined;
        break;
      case 'transfer':
        color = const Color(0xFF2ECC8A);
        icon = Icons.swap_horiz_outlined;
        break;
      default: // cash
        color = const Color(0xFFED6A2E);
        icon = Icons.account_balance_wallet_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 5),
          Text(
            display.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topCard(String label, int amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFED6A2E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: const Color(0xFFED6A2E)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _fmtAmount(amount),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A2233),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topCardOrange(String label, int amount) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFED6A2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _fmtAmount(amount),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(
    IconData icon,
    String label,
    int amount,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const SizedBox(height: 2),
              Text(
                _fmtAmount(amount),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2233),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filterField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      children: [
        _pgBtn(
          Icons.chevron_left,
          _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        const SizedBox(width: 4),
        ...List.generate(totalPages.clamp(0, 5), (i) {
          final p = i + 1;
          final active = p == _currentPage;
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: GestureDetector(
              onTap: () => setState(() => _currentPage = p),
              child: Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFED6A2E) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: active
                        ? const Color(0xFFED6A2E)
                        : Colors.grey.withOpacity(0.25),
                  ),
                ),
                child: Text(
                  '$p',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: active ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        }),
        _pgBtn(
          Icons.chevron_right,
          _currentPage < totalPages
              ? () => setState(() => _currentPage++)
              : null,
        ),
      ],
    );
  }

  Widget _pgBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap == null ? Colors.grey[300] : Colors.black87,
        ),
      ),
    );
  }

  String _fmtAmount(int n) {
    if (n == 0) return '0 сум';
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return '${buf.toString()} сум';
  }
}

class _ColH extends StatelessWidget {
  final String text;
  const _ColH(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: Colors.grey[400],
        letterSpacing: 0.5,
      ),
    );
  }
}