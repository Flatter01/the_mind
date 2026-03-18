import 'package:flutter/material.dart';

class TheMindWorkesProfile extends StatefulWidget {
  const TheMindWorkesProfile({super.key});

  @override
  State<TheMindWorkesProfile> createState() => _TheMindWorkesProfileState();
}

class _TheMindWorkesProfileState extends State<TheMindWorkesProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          _profileHeader(),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(children:[ _basicInfo(),SizedBox(height: 16), _skillsCard()])),
              const SizedBox(width: 16),
              Expanded(child: _financeInfo()),
            ],
          ),
          // const SizedBox(height: 16),
          // _skillsCard(),
          // const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Шапка профиля ─────────────────────────────────────────────────────────
  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecor(),
      child: Row(
        children: [
          // Аватар
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2233).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text('АИ', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1A2233))),
                ),
              ),
              Positioned(
                bottom: 4, right: 4,
                child: Container(
                  width: 14, height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC8A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 20),

          // Имя, должность, бейджи
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Александр Иванов',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF1A2233)),
              ),
              const SizedBox(height: 4),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 14),
                  children: [
                    TextSpan(text: 'Ведущий ', style: TextStyle(color: Color(0xFFED6A2E), fontWeight: FontWeight.w600)),
                    TextSpan(text: 'Frontend', style: TextStyle(color: Color(0xFFED6A2E), fontWeight: FontWeight.w800)),
                    TextSpan(text: ' разработчик', style: TextStyle(color: Color(0xFFED6A2E), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _badge('ШТАТНЫЙ', const Color(0xFF6B7FD4)),
                  const SizedBox(width: 8),
                  _badge('АКТИВЕН', const Color(0xFF2ECC8A)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color, letterSpacing: 0.5)),
    );
  }

  // ── Основная информация ───────────────────────────────────────────────────
  Widget _basicInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.person_outlined, 'Основная информация'),
          const SizedBox(height: 20),
          _infoRow('Телефон', '+7 (900) 123-45-67'),
          _divider(),
          _infoRow('Дата приема', '12 марта 2021'),
          _divider(),
          _infoRow('Департамент', 'Разработка ПО'),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500]))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2233))),
        ],
      ),
    );
  }

  Widget _divider() => Divider(color: Colors.grey.withOpacity(0.08), height: 1);

  // ── Финансовая информация ─────────────────────────────────────────────────
  Widget _financeInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.account_balance_wallet_outlined, 'Финансовая информация'),
          const SizedBox(height: 20),

          // Текущий баланс
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFED6A2E).withOpacity(0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ТЕКУЩИЙ БАЛАНС', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey[500], letterSpacing: 0.5)),
                const SizedBox(height: 6),
                const Text('142 500 ₽', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFFED6A2E))),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _finRow('Оклад', '180 000 ₽', null),
          _divider(),
          _finRow('Бонусы (тек. месяц)', '+15 000 ₽', true),
          _divider(),
          _finRow('Штрафы', '-2 500 ₽', false),
          _divider(),
          _finRow('Следующая выплата', '05.11.2023', null),
        ],
      ),
    );
  }

  Widget _finRow(String label, String value, bool? positive) {
    Color valueColor = const Color(0xFF1A2233);
    if (positive == true) valueColor = const Color(0xFF2ECC8A);
    if (positive == false) valueColor = const Color(0xFFED6A2E);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500]))),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: valueColor)),
        ],
      ),
    );
  }

  // ── Навыки ────────────────────────────────────────────────────────────────
  Widget _skillsCard() {
    const skills = ['React.js', 'TypeScript', 'Tailwind CSS', 'Next.js', 'Redux Toolkit', 'GraphQL'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _cardDecor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(Icons.rocket_launch_outlined, 'Навыки и технологии'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.map((s) => _skillChip(s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
      ),
      child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A2233))),
    );
  }

  // ── Хелперы ───────────────────────────────────────────────────────────────
  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFED6A2E)),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A2233))),
      ],
    );
  }

  BoxDecoration _cardDecor() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
    );
  }
}