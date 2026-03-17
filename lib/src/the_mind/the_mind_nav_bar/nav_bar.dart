import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/home/presentation/home_page.dart';
import 'package:srm/src/the_mind/main_the_mind/presentation/the_mind_page.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/the_mind_exams_page.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/the_mind_groups/the_mind_group.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';
import 'package:srm/src/core/widgets/notification/notification_tile.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/task/open_task.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/top_bar.dart';
import 'package:srm/src/the_mind/the_mind_profile/presentation/the_mind_profile_page.dart';
import 'package:srm/src/the_mind/the_mind_salary/presentation/the_mind_salary_page.dart';
import 'package:srm/src/the_mind/the_mind_settings/presentation/the_mind_settings_page.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/faol_lidlar/faol_lidlar_page.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/the_mind_students_page.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_payment/add_payment_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_task/the_mind_task_page.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/the_mind_teacher_page.dart';
import 'package:srm/src/the_mind/the_mind_transactions/presentation/transactions_page.dart';
import 'package:srm/src/the_mind/the_mind_workers/presentation/the_mind_workers_page.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/side_menu.dart';

class WebCustomBottomNav extends StatefulWidget {
  const WebCustomBottomNav({super.key});

  @override
  State<WebCustomBottomNav> createState() => _WebCustomBottomNavState();
}

class _WebCustomBottomNavState extends State<WebCustomBottomNav> {
  int selectedIndex = 0;
  int? studentSubIndex;

  /// 🔥 добавили navigator key
  final GlobalKey<NavigatorState> _contentNavKey = GlobalKey<NavigatorState>();

  final List<String> courses = ["All", "IELTS", "General English", "Math"];
  bool get canPop => _contentNavKey.currentState?.canPop() ?? false;

  final List<BuildStudentsTableItem> students = [
    BuildStudentsTableItem(
      id: 0,
      name: "Aliyev Bekzod",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "IELTS 7.0",
      balance: "-150 000",
      status: "Qarzdor",
      called: true,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 0,
      name: "Sattorova Madina",
      phone: "+998 99 445 22 11",
      teacher: "Kamol",
      group: "General English A2",
      balance: "110 000",
      status: "Qarzdor emas",
      called: true,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 0,
      name: "Karimov Jasur",
      phone: "+998 93 556 12 88",
      teacher: "Madina",
      group: "Math Beginner",
      balance: "-80 000",
      status: "Qarzdor",
      called: true,
      missedLessons: 2,
    ),
  ];
  String selectedBranch = "C1";

  final List<String> branches = [
    "Main",
    "C1",
    "Чиланзар",
    "Юнусабад",
    "Сергели",
    "Алмазар",
  ];

  List<AppNotification> notifications = [
    AppNotification(
      id: '1',
      title: 'Сообщение',
      body: 'Ваша оплата успешно принята',
      type: NotificationType.message,
    ),
  ];

  List<AppNotification> tasks = [
    AppNotification(
      id: '1',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    AppNotification(
      id: '1',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    AppNotification(
      id: '1',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    AppNotification(
      id: '1',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    AppNotification(
      id: '1',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
    AppNotification(
      id: '1',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  Widget _buildScreen() {
    switch (selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const TheMindPage();
      case 2:
        return const FaolLidlarPage();
      case 3:
        return const TheMindStudentsPage();
      case 4:
        return const TheMindGroup();
      case 5:
        return TheMindExamsPage();
      case 6:
        return const TheMindTeacherPage();
      case 7:
        return const TheMindTaskPage();
      case 8:
        return const TheMindWorkersPage();
      case 9:
        return const TheMindSalaryPage();
      case 10:
        return const TransactionsPage();
      case 11:
        return const TheMindSettingsPage();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    if (isMobile) {
      /// 📱 MOBILE VERSIO
      return Scaffold(
        backgroundColor: AppColors.bgColor,
        drawer: Drawer(
          backgroundColor: Colors.black,
          child: SideMenu(
            isMobile: true,
            selectedIndex: selectedIndex,
            onTap: (index) {
              Navigator.pop(context); // закрываем drawer
              selectedIndex != index ? _onMenuTap(index) : () {};
            },
            onStudentSubTap: (int? sub) {
              Navigator.pop(context);
              setState(() => studentSubIndex = sub);
              _onMenuTap(selectedIndex);
            },
          ),
        ),
        body: Column(
          children: [
            TopBar(
              showBackButton: canPop,
              isMobile: isMobile,
              onTask: _openTask,
              onNotifications: _openNotifications,
              onAddMenu: _openAddMenu,
              selectedBranch: selectedBranch,
              branches: branches,
              onBranchChanged: (value) {
                setState(() {
                  selectedBranch = value;
                });
              },
              onBack: () {},
            ),
            Expanded(child: _buildScreen()),
          ],
        ),
      );
    }

    /// 💻 WEB VERSION (как было)
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Row(
        children: [
          SideMenu(
            isMobile: false,
            selectedIndex: selectedIndex,
            onTap: _onMenuTap,
            onStudentSubTap: (int? sub) {
              if (sub != selectedIndex){
                setState(() => studentSubIndex = sub);
              _contentNavKey.currentState?.pushReplacement(
                MaterialPageRoute(builder: (_) => _buildScreen()),
              );
              }
            },
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Navigator(
                    key: _contentNavKey,
                    onGenerateRoute: (_) =>
                        MaterialPageRoute(builder: (_) => _buildScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void popInner() {
    final nav = _contentNavKey.currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
    }
  }

  /// 🔥 теперь обновляем вложенный navigator
  void _onMenuTap(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
        if (index != 2) studentSubIndex = null;
      });

      _contentNavKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (_) => _buildScreen()),
      );
    }
  }

  void pushInner(Widget page) {
    _contentNavKey.currentState
        ?.push(MaterialPageRoute(builder: (_) => page))
        .then((_) {
          setState(() {}); // обновляем кнопку назад после pop
        });

    setState(() {}); // обновляем кнопку назад после push
  }

  void _openNotifications() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgColor,
        title: const Text("Уведомления"),
        content: SizedBox(
          width: 420,
          child: notifications.isEmpty
              ? const Text("Уведомлений нет")
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = notifications[index];
                    return NotificationTile(
                      notification: item,
                      onComplete: () {
                        setState(() => item.isCompleted = true);
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Закрыть"),
          ),
        ],
      ),
    );
  }

  void _openAddMenu(TapDownDetails details) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        0,
        0,
      ),
      items: const [
        PopupMenuItem(
          value: 'student',
          child: Row(
            children: [
              Icon(Icons.person_add, size: 18),
              SizedBox(width: 8),
              Text("Добавить участника"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'lid',
          child: Row(
            children: [
              Icon(Icons.person_add, size: 18),
              SizedBox(width: 8),
              Text("Добавить Lid"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'payment',
          child: Row(
            children: [
              Icon(Icons.payments, size: 18),
              SizedBox(width: 8),
              Text("Совершить оплату"),
            ],
          ),
        ),
      ],
    );

    if (selected == 'student') {
      await showDialog(
        context: context,
        builder: (_) => AddStudentDialogResponsive(
          courses: courses,
          groups: const ['Frontend A', 'Frontend B', 'IELTS 1', 'IELTS 2'],
        ),
      );
    }

    if (selected == 'lid') {
      await showDialog(
        context: context,
        builder: (_) => AddStudentDialog(
          courses: courses,
          groups: const ['Frontend A', 'Frontend B', 'IELTS 1', 'IELTS 2'],
          branches: ["C1", "C2", "C4"],
        ),
      );
    }

    if (selected == 'payment') {
      final paymentCubit = context.read<PaymentCubit>();
      final result = await showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
          value: paymentCubit,
          child: BlocBuilder<StudentCubit, StudentState>(
            builder: (context, state) {
              if (state is StudentLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is StudentError) {
                return Center(child: Text(state.message));
              }

              if (state is StudentLoaded) {
                return AddPaymentDialogResponsive(students: state.students);
              }

              return const SizedBox();
            },
          ),
        ),
      );

      if (result != null) {
        await _showPrintDialog(context, result);
      }
    }
  }

  void _openTask(TapDownDetails details) {
    OpenTask.openTask(
      context: context,
      details: details,
      tasks: tasks,
      refresh: () => setState(() {}),
    );
  }

  Future<void> _showPrintDialog(BuildContext context, Map data) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("To‘lov muvaffaqiyatli"),
        content: const Text("Chek chiqarilsinmi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yo‘q"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              printReceipt(data);
            },
            child: const Text("Ha, chiqarish"),
          ),
        ],
      ),
    );
  }

  Future<void> printReceipt(Map data) async {
    final student = data["student"];
    final method = data["method"];
    final amount = data["amount"];
    final date = data["date"] as DateTime;

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text("TO‘LOV CHEKI", style: pw.TextStyle(fontSize: 22)),
            ),
            pw.SizedBox(height: 16),
            pw.Text("Ism: ${student.name}"),
            pw.Text("Guruh: ${student.group}"),
            pw.Text("Telefon: ${student.phone}"),
            pw.Text("To‘lov turi: $method"),
            pw.Text("Sana: ${DateFormat('dd.MM.yyyy HH:mm').format(date)}"),
            pw.Divider(),
            pw.Text("SUMMA: $amount so'm", style: pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
