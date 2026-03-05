import 'package:flutter/material.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/branch_manager_page.dart';
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
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Row(
        children: [
          /// Левая панель
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 250,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ListView.builder(
                itemCount: _panelItems.length,
                itemBuilder: (context, index) {
                  final item = _panelItems[index];
                  return _SidebarItem(
                    title: item['title'],
                    icon: item['icon'],
                    isSelected: _selectedIndex == index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
          ),

          /// Правая часть
          Expanded(
            child: Container(
              color: AppColors.bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: _buildRightContent(),
            ),
          ),
        ],
      ),
    );
  }

  /// Контент справа
  Widget _buildRightContent() {
    if (_selectedIndex == -1) {
      return const Center(
        child: Text(
          "Выберите пункт в панели слева",
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return ExpenseOptionsPage();
      case 1:
        return MarketingAnalyticsPage();
      case 2:
        return NewsPage();
      case 3:
        return FeedbackPage();
      case 4:
        return SmsNewUsersPage();
      case 5:
        return SmsActiveUsersPage();
      case 6:
        return SendTaskPage(
          onSend: (task) {
            debugPrint("TASK SENT: ${task.title} | ${task.deadline}");
          },
        );
      case 7:
        return AssignRolePage();
      case 8:
        return CreateRolePage();
      case 9:
        return BranchManagerPage(); // 👈 новый класс
      default:
        return const SizedBox();
    }
  }
}

/// Данные панели
final List<Map<String, dynamic>> _panelItems = [
  {'title': "Расходы", 'icon': Icons.bar_chart},
  {'title': "маркетинг Лиды ", 'icon': Icons.person},
  {'title': "Новости", 'icon': Icons.newspaper},
  {'title': "Feedback", 'icon': Icons.feedback_outlined},
  {'title': "SMS новым", 'icon': Icons.mark_email_unread_outlined},
  {'title': "SMS активным", 'icon': Icons.sms_outlined},
  {'title': "Отправить таск", 'icon': Icons.task_outlined},
  {'title': "Назначение роли", 'icon': Icons.admin_panel_settings_outlined},
  {'title': "Создание роли", 'icon': Icons.add_moderator_outlined},
  {'title': "Создать ветку", 'icon': Icons.merge_type}, // 👈 новый пункт
];

class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue.withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.blue : Colors.black87,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.blue : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
