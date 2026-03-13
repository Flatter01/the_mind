import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TariffPage extends StatefulWidget {
  const TariffPage({super.key});

  @override
  State<TariffPage> createState() => _TariffPageState();
}

class _TariffPageState extends State<TariffPage> {
  final List<Tariff> tariffs = [];

  void _openTariffDialog({Tariff? tariff, int? index}) {
    showDialog(
      context: context,
      builder: (_) => TariffDialog(
        tariff: tariff,
        onSave: (t) {
          setState(() {
            if (tariff == null) {
              tariffs.add(t);
            } else {
              tariffs[index!] = t;
            }
          });
        },
      ),
    );
  }

  void _deleteTariff(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Удалить тариф', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Вы уверены, что хотите удалить этот тариф?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED6A2E),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              setState(() => tariffs.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFED6A2E),
        onPressed: () => _openTariffDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: tariffs.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Тарифов пока нет', style: TextStyle(fontSize: 18)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: tariffs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final tariff = tariffs[index];
                    return _TariffCard(
                      tariff: tariff,
                      onEdit: () => _openTariffDialog(tariff: tariff, index: index),
                      onDelete: () => _deleteTariff(index),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

// ── Диалог создания / редактирования ─────────────────────────────────────
class TariffDialog extends StatefulWidget {
  final Tariff? tariff;
  final Function(Tariff) onSave;

  const TariffDialog({this.tariff, required this.onSave});

  @override
  State<TariffDialog> createState() => _TariffDialogState();
}

class _TariffDialogState extends State<TariffDialog> {
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _description;
  String _duration = '1 Месяц';

  final List<String> _durations = ['1 Месяц', '3 Месяца', '6 Месяцев', '1 Год'];

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.tariff?.name ?? '');
    _price = TextEditingController(
      text: widget.tariff != null ? widget.tariff!.price.toStringAsFixed(2) : '0.00',
    );
    _description = TextEditingController(text: widget.tariff?.description ?? '');
    _duration = widget.tariff?.duration ?? '1 Месяц';
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    final price = double.tryParse(_price.text.replaceAll(' ', '')) ?? 0;
    if (name.isEmpty) return;
    widget.onSave(Tariff(
      name: name,
      price: price,
      duration: _duration,
      description: _description.text.trim(),
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tariff != null;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
      child: SizedBox(
        width: 540,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Название тарифа ─────────────────────────────────
              _fieldLabel('Название тарифа'),
              const SizedBox(height: 8),
              _inputBox(
                child: TextField(
                  controller: _name,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233)),
                  decoration: _inputDeco('Например: Премиум годовой'),
                ),
              ),

              const SizedBox(height: 20),

              // ── Цена + Продолжительность ────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Цена
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('Цена'),
                        const SizedBox(height: 8),
                        _inputBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _price,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                                  style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233)),
                                  decoration: _inputDeco('0.00'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Text('₽', style: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Продолжительность
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel('Продолжительность'),
                        const SizedBox(height: 8),
                        _inputBox(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _duration,
                              isExpanded: true,
                              icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[500]),
                              style: const TextStyle(fontSize: 14, color: Color(0xFF1A2233)),
                              items: _durations
                                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                  .toList(),
                              onChanged: (v) => setState(() => _duration = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Описание ────────────────────────────────────────
              _fieldLabel('Описание'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: TextField(
                  controller: _description,
                  maxLines: 5,
                  maxLength: 500,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  decoration: InputDecoration(
                    hintText: 'Опишите основные преимущества данного тарифа...',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
                    border: InputBorder.none,
                    isDense: true,
                    counterText: '',
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Это описание увидят пользователи перед покупкой. Максимум 500 символов.',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),

              const SizedBox(height: 28),

              // ── Кнопки ──────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        backgroundColor: const Color(0xFFF2F5F7),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Отмена', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED6A2E),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isEdit ? 'Сохранить' : 'Создать тариф',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2233)),
  );

  Widget _inputBox({required Widget child, double? height = 52, EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 14)}) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: child,
    );
  }

  InputDecoration _inputDeco(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
    border: InputBorder.none,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 16),
  );
}

// ── Карточка тарифа ───────────────────────────────────────────────────────
class _TariffCard extends StatelessWidget {
  final Tariff tariff;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TariffCard({required this.tariff, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tariff.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    '${tariff.price.toStringAsFixed(0)} ₽  ·  ${tariff.duration}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  if (tariff.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      tariff.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit),
              label: const Text('Редактировать'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text('Удалить', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Модель ────────────────────────────────────────────────────────────────
class Tariff {
  final String name;
  final double price;
  final String duration;
  final String description;

  Tariff({
    required this.name,
    required this.price,
    this.duration = '1 Месяц',
    this.description = '',
  });
}

class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final positionFromEnd = digits.length - i;
      buffer.write(digits[i]);
      if (positionFromEnd > 1 && positionFromEnd % 3 == 1) buffer.write(' ');
    }
    final result = buffer.toString();
    return TextEditingValue(text: result, selection: TextSelection.collapsed(offset: result.length));
  }
}