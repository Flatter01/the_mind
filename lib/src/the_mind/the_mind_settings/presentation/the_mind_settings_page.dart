import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/branch_manager_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/expense/analytics_lids.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/expense/expense_options_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/expense/marketing_analytics_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/feedback/feedback_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/role/assign_role_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/role/create_role_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/news_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/send_task_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/sms_active_users_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/sms_new_users_page.dart';

class TheMindSettingsPage extends StatefulWidget {
  const TheMindSettingsPage({super.key});

  @override
  State<TheMindSettingsPage> createState() => _TheMindSettingsPageState();
}

class _TheMindSettingsPageState extends State<TheMindSettingsPage> {
  int _selectedIndex = 0;

  static const List<String> _tabs = [
    'Расходы',
    'Маркетинг',
    'Маркетинг Лид',
    'Новости',
    'Feedback',
    'SMS',
    'Создание роли',
    'Создать ветку',
  ];

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return ExpenseOptionsPage();
      case 1:
        return MarketingAnalyticsPage();
      case 2:
        return AnalyticsLids();
      case 3:
        return NewsPage();
      case 4:
        return FeedbackPage();
      case 5:
        return SmsNewUsersPage();
      case 6:
        return CreateRolePage();
      case 7:
        return BranchManagerPage();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F7),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Заголовок ──────────────────────────────────────────
            const Text(
              'Настройки',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A2233),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Управление системными параметрами',
              style: TextStyle(fontSize: 13, color: Colors.grey[500]),
            ),

            const SizedBox(height: 20),

            // ── Вкладки ────────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final active = _selectedIndex == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: active
                                ? const Color(0xFFED6A2E)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        _tabs[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: active
                              ? const Color(0xFFED6A2E)
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.15), height: 1),

            const SizedBox(height: 20),

            // ── Контент ────────────────────────────────────────────
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }
}
