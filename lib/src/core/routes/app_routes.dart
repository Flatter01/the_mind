import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:srm/src/the_mind/auth/data/auth_repository.dart';
import 'package:srm/src/the_mind/auth/presentation/app_start_page.dart';
import 'package:srm/src/the_mind/auth/presentation/auth_page.dart';
import 'package:srm/src/the_mind/home/presentation/home_page.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/the_mind_page.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/the_mind_exams_page.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/the_mind_groups/the_mind_group.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/group_details.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/nav_bar.dart';
import 'package:srm/src/the_mind/the_mind_profile/presentation/the_mind_profile_page.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/the_mind_salary_page.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/tariff_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/the_mind_settings_page.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/the_mind_students_page.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/student_details.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/faol_lidlar/faol_lidlar_page.dart';
import 'package:srm/src/the_mind/the_mind_task/the_mind_task_page.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/the_mind_analitic_teacher.dart';
import 'package:srm/src/the_mind/the_mind_transactions/presentation/transactions_page.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/the_mind_workers_page.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/task/task_manager_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/news_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/sms_active_users_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/sms_new_users_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/user_sms/send_task_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/feedback/feedback_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/branch_manager_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/role/create_role_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/role/assign_role_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/expense/expense_options_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/widgets/expense/marketing_analytics_page.dart';

import 'app_pages.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppPages.theMind,
  debugLogDiagnostics: true,
  errorBuilder: (context, state) {
    // Unknown route — redirect to theMind if logged in, else to auth
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isLoggedIn = AuthRepository().isLoggedIn;
      context.go(isLoggedIn ? AppPages.theMind : AppPages.auth);
    });
    return const Scaffold(body: SizedBox.shrink());
  },
  redirect: (context, state) {
    final isLoggedIn = AuthRepository().isLoggedIn;
    final loc = state.matchedLocation;
    final isAuthPage = loc == AppPages.auth || loc == AppPages.splash;

    if (!isLoggedIn && !isAuthPage) return AppPages.auth;
    if (isLoggedIn && isAuthPage) return AppPages.theMind;
    return null;
  },
  routes: [
    GoRoute(
      path: AppPages.splash,
      builder: (context, state) => AppStartPage(),
    ),
    GoRoute(
      path: AppPages.auth,
      builder: (context, state) => const AuthPage(),
    ),

    // ── Авторизованные страницы (с навбаром) ────────────────────────────────
    ShellRoute(
      builder: (context, state, child) =>
          WebCustomBottomNav(currentLocation: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: AppPages.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: AppPages.theMind,
          builder: (context, state) => const TheMindPage(),
        ),
        GoRoute(
          path: AppPages.faolLidlar,
          builder: (context, state) => const FaolLidlarPage(),
        ),
        GoRoute(
          path: AppPages.students,
          builder: (context, state) => const TheMindStudentsPage(),
        ),
        GoRoute(
          path: AppPages.studentDetails,
          builder: (context, state) =>
              StudentDetailsPage(student: state.extra as dynamic),
        ),
        GoRoute(
          path: AppPages.groups,
          builder: (context, state) => const TheMindGroup(),
        ),
        GoRoute(
          path: '${AppPages.groupDetails}/:groupId',
          builder: (context, state) => GroupDetails(
            groupId: int.parse(state.pathParameters['groupId']!),
          ),
        ),
        GoRoute(
          path: AppPages.exams,
          builder: (context, state) => TheMindExamsPage(),
        ),
        GoRoute(
          path: AppPages.teachers,
          builder: (context, state) => const TheMindAnaliticTeacher(),
        ),
        GoRoute(
          path: AppPages.tasks,
          builder: (context, state) => const TheMindTaskPage(),
        ),
        GoRoute(
          path: AppPages.workers,
          builder: (context, state) => const TheMindWorkersPage(),
        ),
        GoRoute(
          path: AppPages.salary,
          builder: (context, state) => const TheMindSalaryPage(),
        ),
        GoRoute(
          path: AppPages.tariff,
          builder: (context, state) => const TariffPage(),
        ),
        GoRoute(
          path: AppPages.transactions,
          builder: (context, state) => const TransactionsPage(),
        ),
        GoRoute(
          path: AppPages.profile,
          builder: (context, state) => const TheMindProfilePage(),
        ),
        GoRoute(
          path: AppPages.settings,
          builder: (context, state) => const TheMindSettingsPage(),
        ),
        GoRoute(
          path: AppPages.taskManager,
          builder: (context, state) => const TaskManagerPage(),
        ),
        GoRoute(
          path: AppPages.news,
          builder: (context, state) => const NewsPage(),
        ),
        GoRoute(
          path: AppPages.smsActiveUsers,
          builder: (context, state) => const SmsActiveUsersPage(),
        ),
        GoRoute(
          path: AppPages.smsNewUsers,
          builder: (context, state) => const SmsNewUsersPage(),
        ),
        GoRoute(
          path: AppPages.sendTask,
          builder: (context, state) => SendTaskPage(
            onSend: state.extra as dynamic,
          ),
        ),
        GoRoute(
          path: AppPages.feedback,
          builder: (context, state) => const FeedbackPage(),
        ),
        GoRoute(
          path: AppPages.branchManager,
          builder: (context, state) => const BranchManagerPage(),
        ),
        GoRoute(
          path: AppPages.createRole,
          builder: (context, state) => const CreateRolePage(),
        ),
        GoRoute(
          path: AppPages.assignRole,
          builder: (context, state) => const AssignRolePage(),
        ),
        GoRoute(
          path: AppPages.expenseOptions,
          builder: (context, state) => const ExpenseOptionsPage(),
        ),
        GoRoute(
          path: AppPages.marketingAnalytics,
          builder: (context, state) => const MarketingAnalyticsPage(),
        ),
      ],
    ),
  ],
);
