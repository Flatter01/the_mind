import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:srm/src/core/assets/assets.gen.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/notification/notification_tile.dart';
import 'package:srm/src/core/widgets/analytica/build_analytics_details.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/build_analytics.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/goal_progress_card.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/students_list_widget.dart';
import 'package:srm/src/the_mind/home/presentation/widgets/today_finance_service.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/task/open_task.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_payment/add_payment_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog_responsive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> courses = ["All", "IELTS", "General English", "Math"];

  final List<AppNotification> notifications = [
    AppNotification(
      id: '1',
      title: 'Сообщение',
      body: 'Ваша оплата успешно принята',
      type: NotificationType.message,
    ),
  ];

  List<AppNotification> tasks = List.generate(
    6,
    (index) => AppNotification(
      id: '${index + 1}',
      title: 'Новый таск',
      body: 'Подготовить отчёт по студентам',
      toUserId: "Ali",
      fromUserId: "Aziza",
      type: NotificationType.task,
      deadline: DateTime.now().add(const Duration(days: 2)),
    ),
  );

  final List<BuildStudentsTableItem> trialLesson = [
    BuildStudentsTableItem(
      id: 0,
      name: "Марина Ковалева",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "Английский",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 0,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Артем Сидоров",
      phone: "+998 90 111 22 33",
      teacher: "Aziz",
      group: "Программирование",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 0,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Анна Лебедева",
      phone: "+998 90 444 55 66",
      teacher: "Aziz",
      group: "Дизайн",
      balance: "0",
      status: "Probniy dars",
      called: false,
      missedLessons: 0,
    ),
  ];

  final List<BuildStudentsTableItem> debtors = [
    BuildStudentsTableItem(
      id: 0,
      name: "Виктор Петров",
      phone: "+998 90 123 45 67",
      teacher: "Aziz",
      group: "Frontend Developer",
      balance: "12 400 ₽",
      status: "Qarzdor",
      called: true,
      missedLessons: 4,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Елена Кравц",
      phone: "+998 90 777 88 99",
      teacher: "Aziz",
      group: "UX/UI Design",
      balance: "5 800 ₽",
      status: "Qarzdor",
      called: true,
      missedLessons: 12,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Иван Макаров",
      phone: "+998 90 555 66 77",
      teacher: "Aziz",
      group: "Java Start",
      balance: "15 000 ₽",
      status: "Qarzdor",
      called: false,
      missedLessons: 2,
    ),
  ];

  final List<BuildStudentsTableItem> didntCome = [
    BuildStudentsTableItem(
      id: 0,
      name: "Сергей Новиков",
      phone: "+998 90 999 11 22",
      teacher: "Aziz",
      group: "Английский",
      balance: "0",
      status: "Kelmadi",
      called: false,
      missedLessons: 1,
    ),
    BuildStudentsTableItem(
      id: 1,
      name: "Ольга Разумовская",
      phone: "+998 90 333 44 55",
      teacher: "Aziz",
      group: "Математика",
      balance: "0",
      status: "Kelmadi",
      called: false,
      missedLessons: 2,
    ),
    BuildStudentsTableItem(
      id: 2,
      name: "Дмитрий Кузин",
      phone: "+998 90 666 77 88",
      teacher: "Aziz",
      group: "Дизайн",
      balance: "0",
      status: "Kelmadi",
      called: false,
      missedLessons: 1,
    ),
  ];

  final List<AnalyticsItem> analyticsItems = const [
    AnalyticsItem(title: "Лиды", value: "128"),
    AnalyticsItem(title: "Студенты", value: "542"),
    AnalyticsItem(title: "Ожидаемые", value: "45"),
    AnalyticsItem(title: "Новые студенты", value: "12"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          BuildAnalytics(
            items: analyticsItems,
            onTap: (item) => _onAnalyticsTap(item.title),
          ),
          const SizedBox(height: 25),
          _buildFinanceGoalRow(),
          const SizedBox(height: 25),
          _buildStudentsBlocks(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Обзор показателей',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2233),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Статистика центра на сегодня',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        const SizedBox(width: 300, child: BuildSearchBar()),
        const SizedBox(width: 10),
        _buildIconButton(Icons.task, _openTask),
        const SizedBox(width: 10),
        _buildIconButton(Icons.notifications, _openNotifications),
        const SizedBox(width: 10),
        _buildIconButton(Icons.add, _openAddMenu),
      ],
    );
  }

  Widget _buildIconButton(
    IconData icon,
    void Function([TapDownDetails?]) onTap,
  ) {
    return GestureDetector(
      onTapDown: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10),
        child: Center(child: Icon(icon)),
      ),
    );
  }

  Widget _buildFinanceGoalRow() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Expanded(flex: 3, child: GoalProgressCard()),
          SizedBox(width: 16),
          Expanded(flex: 1, child: TodayFinanceService()),
        ],
      ),
    );
  }

  Widget _buildStudentsBlocks() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StudentsListWidget(
            title: 'Записанные на пробный',
            icons: Assets.icons.arrived.svg(),
            quantity: '${trialLesson.length}',
            blockType: StudentsBlockType.trial,
            students: trialLesson,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StudentsListWidget(
            title: 'Должники',
            icons: Assets.icons.debtor.svg(),
            quantity: '${debtors.length}',
            blockType: StudentsBlockType.debtors,
            students: debtors,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StudentsListWidget(
            title: 'Не пришедшие',
            icons: Assets.icons.didntCome.svg(),
            quantity: '${didntCome.length}',
            blockType: StudentsBlockType.absent,
            students: didntCome,
          ),
        ),
      ],
    );
  }

  void _openTask([TapDownDetails? details]) {
    if (details == null) return; // на всякий случай
    OpenTask.openTask(
      context: context,
      details: details,
      tasks: tasks,
      refresh: () => setState(() {}),
    );
  }

  void _onAnalyticsTap(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuildAnalyticsDetails<BuildStudentsTableItem>(
          data: debtors,
          title: title,
          getName: (e) => e.name,
          getPhone: (e) => e.phone,
          getTeacher: (e) => e.teacher,
          getGroup: (e) => e.group,
          getBalance: (e) => e.balance,
          getCallStatus: (e) => e.called ? "Pozvonili" : "Ne pozvonili",
          getBalanceColor: (_) => Colors.red,
          getCallStatusColor: (e) => e.called ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  void _openNotifications([TapDownDetails? details]) {
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
                      onComplete: () => setState(() => item.isCompleted = true),
                    );
                  },
                ),
        ),
      ),
    );
  }

  Future<void> _openAddMenu([TapDownDetails? details]) async {
    if (details == null) return;

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

    switch (selected) {
      case 'student':
        await showDialog(
          context: context,
          builder: (_) => AddStudentDialogResponsive(
            courses: courses,
            groups: const ['Frontend A', 'Frontend B', 'IELTS 1', 'IELTS 2'],
          ),
        );
        break;
      case 'lid':
        await showDialog(
          context: context,
          builder: (_) => AddStudentDialog(
            courses: courses,
            groups: const ['Frontend A', 'Frontend B', 'IELTS 1', 'IELTS 2'],
            branches: const ["C1", "C2", "C4"],
          ),
        );
        break;
      case 'payment':
        final paymentCubit = context.read<PaymentCubit>();
        final result = await showDialog(
          context: context,
          builder: (_) => BlocProvider.value(
            value: paymentCubit,
            child: BlocBuilder<StudentCubit, StudentState>(
              builder: (context, state) {
                if (state is StudentLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is StudentError)
                  return Center(child: Text(state.message));
                if (state is StudentLoaded)
                  return AddPaymentDialogResponsive(students: state.students);
                return const SizedBox();
              },
            ),
          ),
        );
        if (result != null) await _showPrintDialog(context, result);
        break;
    }
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
