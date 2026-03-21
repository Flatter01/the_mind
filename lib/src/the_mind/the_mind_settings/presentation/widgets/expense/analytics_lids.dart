import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ─── МОДЕЛИ ───────────────────────────────────────────────────────────────────

class FunnelStage {
  final String id;
  String name;
  int value;

  FunnelStage({required this.id, required this.name, required this.value});

  FunnelStage copyWith({String? name, int? value}) =>
      FunnelStage(id: id, name: name ?? this.name, value: value ?? this.value);
}

class MarketingSource {
  final String id;
  String name;
  double amount;
  Color color;

  MarketingSource({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
  });
}

class FixedCost {
  String name;
  double amount;

  FixedCost({required this.name, required this.amount});
}

// ─── ГЛАВНЫЙ ВИДЖЕТ ───────────────────────────────────────────────────────────

class AnalyticsLids extends StatefulWidget {
  const AnalyticsLids({super.key});

  @override
  State<AnalyticsLids> createState() => _AnalyticsLidsState();
}

class _AnalyticsLidsState extends State<AnalyticsLids> {
  // Воронка
  List<FunnelStage> _stages = [
    FunnelStage(id: '1', name: 'Посещения', value: 15000),
    FunnelStage(id: '2', name: 'Лиды', value: 900),
    FunnelStage(id: '3', name: 'Квал', value: 400),
    FunnelStage(id: '4', name: 'Центр', value: 200),
    FunnelStage(id: '5', name: 'Оплата', value: 15),
  ];

  String _selectedFilter = 'Все этапы';

  // Маркетинг расходы
  List<MarketingSource> _sources = [
    MarketingSource(
      id: '1',
      name: 'VK Ads',
      amount: 45000,
      color: const Color(0xFF4680C2),
    ),
    MarketingSource(
      id: '2',
      name: 'Telegram Ads',
      amount: 67500,
      color: const Color(0xFF29B6F6),
    ),
  ];

  // Фикс расходы
  List<FixedCost> _fixedCosts = [
    FixedCost(name: 'Стоимость учебников', amount: 2500),
    FixedCost(name: 'Зарплата учителя', amount: 4000),
    FixedCost(name: 'Аренда и прочее', amount: 1000),
  ];

  // Метрики (вычисляемые + ручные)
  double _revenuePerStudent = 20000;

  // ── вычисления ──
  int get _students => _stages.last.value;
  double get _totalMarketing =>
      _sources.fold(0, (sum, s) => sum + s.amount);
  double get _totalFixed =>
      _fixedCosts.fold(0, (sum, c) => sum + c.amount);
  double get _totalExpenses => _totalMarketing + _totalFixed * _students;
  double get _totalRevenue => _revenuePerStudent * _students;
  double get _netProfit => _totalRevenue - _totalExpenses;
  double get _roi =>
      _totalExpenses > 0 ? (_netProfit / _totalExpenses * 100) : 0;
  double get _costPerLead =>
      _stages[1].value > 0 ? _totalMarketing / _stages[1].value : 0;
  double get _costPerVisit =>
      _stages[0].value > 0 ? _totalMarketing / _stages[0].value : 0;
  double get _costPerStudent =>
      _students > 0 ? _totalExpenses / _students : 0;

  // ─── ДИАЛОГ РЕДАКТИРОВАНИЯ ВОРОНКИ ───────────────────────────────────────

  void _showEditFunnelDialog() {
    final tempStages = _stages.map((s) => FunnelStage(id: s.id, name: s.name, value: s.value)).toList();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFED6A2E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.filter_alt_outlined,
                    color: Color(0xFFED6A2E), size: 20),
              ),
              const SizedBox(width: 12),
              const Text('Редактировать воронку',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...tempStages.asMap().entries.map((entry) {
                  final i = entry.key;
                  final stage = entry.value;
                  final nameCtrl =
                      TextEditingController(text: stage.name);
                  final valCtrl =
                      TextEditingController(text: stage.value.toString());
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFED6A2E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text('${i + 1}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFED6A2E))),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: nameCtrl,
                            label: 'Этап',
                            onChanged: (v) => tempStages[i].name = v,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: valCtrl,
                            label: 'Кол-во',
                            isNumber: true,
                            onChanged: (v) =>
                                tempStages[i].value = int.tryParse(v) ?? 0,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setS(() => tempStages.removeAt(i)),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: () => setS(() => tempStages.add(
                        FunnelStage(
                            id: DateTime.now().toString(),
                            name: 'Новый этап',
                            value: 0),
                      )),
                  icon: const Icon(Icons.add, color: Color(0xFFED6A2E)),
                  label: const Text('Добавить этап',
                      style: TextStyle(color: Color(0xFFED6A2E))),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _stages = tempStages);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6A2E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Сохранить',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ДИАЛОГ ДОБАВИТЬ ЭТАП ────────────────────────────────────────────────

  void _showAddStageDialog() {
    final nameCtrl = TextEditingController();
    final valCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Добавить этап',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(
                controller: nameCtrl, label: 'Название этапа'),
            const SizedBox(height: 12),
            _buildTextField(
                controller: valCtrl,
                label: 'Количество',
                isNumber: true),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _stages.add(FunnelStage(
                  id: DateTime.now().toString(),
                  name: nameCtrl.text.trim().isEmpty
                      ? 'Новый этап'
                      : nameCtrl.text.trim(),
                  value: int.tryParse(valCtrl.text) ?? 0,
                ));
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Добавить',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── ДИАЛОГ ДОБАВИТЬ ИСТОЧНИК ────────────────────────────────────────────

  void _showAddSourceDialog() {
    final nameCtrl = TextEditingController();
    final amtCtrl = TextEditingController();
    final colors = [
      const Color(0xFF4680C2),
      const Color(0xFF29B6F6),
      const Color(0xFFED6A2E),
      const Color(0xFF2ECC8A),
      const Color(0xFF8A9BB8),
      const Color(0xFF9C27B0),
    ];
    Color selected = colors[0];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Добавить источник',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller: nameCtrl, label: 'Название'),
              const SizedBox(height: 12),
              _buildTextField(
                  controller: amtCtrl,
                  label: 'Сумма',
                  isNumber: true),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Цвет:',
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(width: 12),
                  ...colors.map((c) => GestureDetector(
                        onTap: () => setS(() => selected = c),
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: selected == c
                                ? Border.all(
                                    color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sources.add(MarketingSource(
                    id: DateTime.now().toString(),
                    name: nameCtrl.text.trim().isEmpty
                        ? 'Источник'
                        : nameCtrl.text.trim(),
                    amount:
                        double.tryParse(amtCtrl.text.replaceAll(' ', '')) ??
                            0,
                    color: selected,
                  ));
                });
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6A2E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Добавить',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ДИАЛОГ РЕДАКТИРОВАТЬ ИСТОЧНИК ──────────────────────────────────────

  void _showEditSourceDialog(int index) {
    final source = _sources[index];
    final nameCtrl = TextEditingController(text: source.name);
    final amtCtrl =
        TextEditingController(text: source.amount.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Редактировать источник',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(controller: nameCtrl, label: 'Название'),
            const SizedBox(height: 12),
            _buildTextField(
                controller: amtCtrl,
                label: 'Сумма (Сум)',
                isNumber: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _sources.removeAt(index));
              Navigator.pop(ctx);
            },
            child:
                const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _sources[index] = MarketingSource(
                  id: source.id,
                  name: nameCtrl.text.trim(),
                  amount: double.tryParse(
                          amtCtrl.text.replaceAll(' ', '')) ??
                      source.amount,
                  color: source.color,
                );
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Сохранить',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── ДИАЛОГ РЕДАКТИРОВАТЬ ФИКС РАСХОДЫ ──────────────────────────────────

  void _showEditFixedCostsDialog() {
    final tempCosts = _fixedCosts
        .map((c) => FixedCost(name: c.name, amount: c.amount))
        .toList();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Фикс расходы на 1 студента',
              style: TextStyle(fontWeight: FontWeight.w700)),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...tempCosts.asMap().entries.map((entry) {
                  final i = entry.key;
                  final cost = entry.value;
                  final nameCtrl =
                      TextEditingController(text: cost.name);
                  final amtCtrl = TextEditingController(
                      text: cost.amount.toStringAsFixed(0));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: nameCtrl,
                            label: 'Название',
                            onChanged: (v) => tempCosts[i].name = v,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildTextField(
                            controller: amtCtrl,
                            label: 'Сум',
                            isNumber: true,
                            onChanged: (v) => tempCosts[i].amount =
                                double.tryParse(v) ?? 0,
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setS(() => tempCosts.removeAt(i)),
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () => setS(() => tempCosts
                      .add(FixedCost(name: 'Новая статья', amount: 0))),
                  icon: const Icon(Icons.add, color: Color(0xFFED6A2E)),
                  label: const Text('Добавить статью',
                      style: TextStyle(color: Color(0xFFED6A2E))),
                ),
                const Divider(height: 24),
                // Revenue per student
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Отмена')),
            ElevatedButton(
              onPressed: () {
                setState(() => _fixedCosts = tempCosts);
                Navigator.pop(ctx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFED6A2E),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Сохранить',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // ─── ДИАЛОГ РЕДАКТИРОВАТЬ ДОХОД ──────────────────────────────────────────

  void _showEditRevenueDialog() {
    final ctrl =
        TextEditingController(text: _revenuePerStudent.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Доход на 1 студента',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: _buildTextField(
            controller: ctrl, label: 'Сумма (Сум)', isNumber: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена')),
          ElevatedButton(
            onPressed: () {
              setState(() =>
                  _revenuePerStudent = double.tryParse(ctrl.text) ?? _revenuePerStudent);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Сохранить',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── УТИЛИТЫ ─────────────────────────────────────────────────────────────

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: Color(0xFFED6A2E), width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  String _formatSum(double v) {
    if (v.abs() >= 1000000) {
      return '${(v / 1000000).toStringAsFixed(1)} млн Сум';
    }
    final abs = v.abs();
    final formatted = abs
        .toStringAsFixed(0)
        .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ');
    return '${v < 0 ? '-' : ''}$formatted Сум';
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
        children: [
          // ── Заголовок ──
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Маркетинговая аналитика',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1A2233),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Обзор эффективности маркетинговой воронки и финансовых показателей',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                ],
              ),
              const Spacer(),
              _headerButton(
                icon: Icons.download_outlined,
                label: 'Скачать отчет',
                filled: true,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Воронка ──
          _buildFunnelCard(),

          const SizedBox(height: 20),

          // ── Метрики + Расходы ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildMetricsCard()),
              const SizedBox(width: 20),
              Expanded(child: _buildExpensesCard()),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── ВОРОНКА ───────────────────────────────────────────────────────────────

  Widget _buildFunnelCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_alt_outlined,
                  color: Color(0xFFED6A2E), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Воронка лидов',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2233)),
              ),
              const SizedBox(width: 16),
              Text('Какие этапы считать:',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              const SizedBox(width: 8),
              _filterDropdown(),
              const Spacer(),
              _smallButton(
                icon: Icons.edit_outlined,
                label: 'Редактировать',
                onTap: _showEditFunnelDialog,
              ),
              const SizedBox(width: 8),
              _smallButton(
                icon: Icons.add,
                label: 'Добавить этап',
                filled: true,
                onTap: _showAddStageDialog,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _stages.length,
              separatorBuilder: (_, __) => const _FunnelArrow(),
              itemBuilder: (ctx, i) {
                final stage = _stages[i];
                final isFirst = i == 0;
                final isLast = i == _stages.length - 1;
                final prev = isFirst ? stage.value : _stages[i - 1].value;
                final pct = prev > 0
                    ? (stage.value / prev * 100).toStringAsFixed(0)
                    : '100';

                return _FunnelStageCard(
                  stage: stage,
                  isFirst: isFirst,
                  isLast: isLast,
                  percent: isFirst ? null : '$pct%',
                  onTap: () => _showEditSingleStage(i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showEditSingleStage(int index) {
    final stage = _stages[index];
    final nameCtrl = TextEditingController(text: stage.name);
    final valCtrl = TextEditingController(text: stage.value.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Редактировать: ${stage.name}',
            style: const TextStyle(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(controller: nameCtrl, label: 'Название'),
            const SizedBox(height: 12),
            _buildTextField(
                controller: valCtrl,
                label: 'Количество',
                isNumber: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _stages.removeAt(index));
              Navigator.pop(ctx);
            },
            child:
                const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _stages[index] = FunnelStage(
                  id: stage.id,
                  name: nameCtrl.text.trim().isEmpty
                      ? stage.name
                      : nameCtrl.text.trim(),
                  value: int.tryParse(valCtrl.text) ?? stage.value,
                );
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Сохранить',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _filterDropdown() {
    const orange = Color(0xFFED6A2E);
    const defaultFilter = 'Все этапы';
    final options = [defaultFilter, 'Только платные', 'Топ воронка'];
    final isActive = _selectedFilter != defaultFilter;

    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isActive ? orange.withOpacity(0.06) : Colors.transparent,
        border: Border.all(
          color: isActive ? orange.withOpacity(0.5) : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          dropdownColor: Colors.white,
          icon: Icon(Icons.keyboard_arrow_down, size: 16, color: isActive ? orange : Colors.grey.shade500),
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            color: isActive ? orange : const Color(0xFF1A2233),
          ),
          items: options.map((o) {
            return DropdownMenuItem(
              value: o,
              child: _HoverDropdownItem(
                label: o,
                isSelected: o == _selectedFilter,
              ),
            );
          }).toList(),
          onChanged: (v) => setState(() => _selectedFilter = v!),
        ),
      ),
    );
  }

  // ── МЕТРИКИ ───────────────────────────────────────────────────────────────

  Widget _buildMetricsCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_outlined,
                  color: Color(0xFFED6A2E), size: 20),
              const SizedBox(width: 8),
              const Text('Метрики',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233))),
              const Spacer(),
              GestureDetector(
                onTap: _showEditRevenueDialog,
                child: const Icon(Icons.edit_outlined,
                    size: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _metricTile(
                      'Стоимость лида', _formatSum(_costPerLead))),
              Expanded(
                  child: _metricTile(
                      'Стоимость посещения', _formatSum(_costPerVisit))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _metricTile(
                      'Стоимость студента', _formatSum(_costPerStudent))),
              Expanded(
                  child: _metricTile('Прибыль с 1 студента',
                      _formatSum(_revenuePerStudent - _totalFixed))),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _metricTile(
                      'Общий доход', _formatSum(_totalRevenue),
                      valueColor: const Color(0xFF2ECC8A))),
              Expanded(
                  child: _metricTile(
                      'Общие расходы', _formatSum(_totalExpenses),
                      valueColor: const Color(0xFFED6A2E))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _netProfit >= 0
                  ? const Color(0xFF2ECC8A).withOpacity(0.08)
                  : const Color(0xFFED6A2E).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _netProfit >= 0
                    ? const Color(0xFF2ECC8A).withOpacity(0.2)
                    : const Color(0xFFED6A2E).withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ЧИСТАЯ ПРИБЫЛЬ',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _netProfit >= 0
                              ? const Color(0xFF2ECC8A)
                              : const Color(0xFFED6A2E),
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatSum(_netProfit),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _netProfit >= 0
                              ? const Color(0xFF2ECC8A)
                              : const Color(0xFFED6A2E)),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  _netProfit >= 0
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: _netProfit >= 0
                      ? const Color(0xFF2ECC8A)
                      : const Color(0xFFED6A2E),
                  size: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricTile(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: valueColor ?? const Color(0xFF1A2233))),
      ],
    );
  }

  // ── РАСХОДЫ ───────────────────────────────────────────────────────────────

  Widget _buildExpensesCard() {
    return Container(
      decoration: _cardDecoration(),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined,
                  color: Color(0xFFED6A2E), size: 20),
              const SizedBox(width: 8),
              const Text('Расходы',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233))),
            ],
          ),
          const SizedBox(height: 20),

          // Маркетинг
          Row(
            children: [
              Text('МАРКЕТИНГ РАСХОДЫ',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[500],
                      letterSpacing: 0.5)),
              const Spacer(),
              GestureDetector(
                onTap: _showAddSourceDialog,
                child: const Text('+ Добавить источник',
                    style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFED6A2E),
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._sources.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () => _showEditSourceDialog(entry.key),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor:
                            entry.value.color.withOpacity(0.15),
                        child: Text(
                          entry.value.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: entry.value.color),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(entry.value.name,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1A2233))),
                      ),
                      Text(
                        _formatSum(entry.value.amount),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2233)),
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 20),

          // Фикс расходы
          Row(
            children: [
              Text('ФИКС РАСХОДЫ (НА 1 СТУДЕНТА)',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[500],
                      letterSpacing: 0.5)),
              const Spacer(),
              GestureDetector(
                onTap: _showEditFixedCostsDialog,
                child: const Icon(Icons.edit_outlined,
                    size: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ..._fixedCosts.map((cost) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(cost.name,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[600])),
                    ),
                    Text(
                      _formatSum(cost.amount),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2233)),
                    ),
                  ],
                ),
              )),

          const Divider(height: 24),

          Row(
            children: [
              const Text('Итого фикс:',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2233))),
              const Spacer(),
              Text(
                _formatSum(_totalFixed),
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFED6A2E)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ROI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFED6A2E).withOpacity(0.08),
                  const Color(0xFFED6A2E).withOpacity(0.03),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFED6A2E).withOpacity(0.15)),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFED6A2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.analytics_outlined,
                      color: Color(0xFFED6A2E), size: 22),
                ),
                const SizedBox(height: 10),
                const Text('Анализ ROI',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A2233))),
                const SizedBox(height: 4),
                Text(
                  'Текущая окупаемость маркетинговых инвестиций',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 8),
                Text(
                  'составляет ${_roi.toStringAsFixed(1)}%',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _roi >= 0
                          ? const Color(0xFF2ECC8A)
                          : const Color(0xFFED6A2E)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      );

  Widget _headerButton({
    required IconData icon,
    required String label,
    bool filled = false,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFED6A2E),
        elevation: 0,
        padding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _smallButton({
    required IconData icon,
    required String label,
    bool filled = false,
    required VoidCallback onTap,
  }) {
    if (filled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 14, color: Colors.white),
        label: Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFED6A2E),
          elevation: 0,
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14, color: Colors.grey[700]),
      label: Text(label,
          style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: Colors.grey.shade300),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// ─── КАРТОЧКА ЭТАПА ВОРОНКИ ───────────────────────────────────────────────────

class _FunnelStageCard extends StatelessWidget {
  final FunnelStage stage;
  final bool isFirst;
  final bool isLast;
  final String? percent;
  final VoidCallback onTap;

  const _FunnelStageCard({
    required this.stage,
    required this.isFirst,
    required this.isLast,
    this.percent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPayment = isLast;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isPayment
              ? const Color(0xFFED6A2E)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPayment
                ? const Color(0xFFED6A2E)
                : Colors.grey.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  stage.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isPayment
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
                if (!isFirst && !isPayment) ...[
                  const Spacer(),
                  Icon(Icons.edit_outlined,
                      size: 12, color: Colors.grey[400]),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatNumber(stage.value),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isPayment
                        ? Colors.white
                        : const Color(0xFF1A2233),
                  ),
                ),
                if (percent != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isPayment
                          ? Colors.white.withOpacity(0.2)
                          : const Color(0xFFED6A2E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      percent!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isPayment
                            ? Colors.white
                            : const Color(0xFFED6A2E),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: isPayment
                    ? Colors.white.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percent != null
                    ? (double.tryParse(
                                percent!.replaceAll('%', '')) ??
                            100) /
                        100
                    : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: isPayment
                        ? Colors.white
                        : const Color(0xFFED6A2E),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int v) {
    if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(0)} тыс';
    }
    return v.toString();
  }
}

// ─── СТРЕЛКА МЕЖДУ ЭТАПАМИ ────────────────────────────────────────────────────

class _HoverDropdownItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  const _HoverDropdownItem({required this.label, required this.isSelected});

  @override
  State<_HoverDropdownItem> createState() => _HoverDropdownItemState();
}

class _HoverDropdownItemState extends State<_HoverDropdownItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFED6A2E);
    final active = _hovered || widget.isSelected;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (_) { if (!_hovered) setState(() => _hovered = true); },
      onExit: (_) { if (mounted) setState(() => _hovered = false); },
      child: Text(
        widget.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
          color: active ? orange : const Color(0xFF1A2233),
        ),
      ),
    );
  }
}

class _FunnelArrow extends StatelessWidget {
  const _FunnelArrow();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.chevron_right, color: Color(0xFFED6A2E), size: 24),
    );
  }
}