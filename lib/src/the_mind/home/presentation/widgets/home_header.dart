import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/notification/notification_tile.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/models/app_notification.dart';
import 'package:srm/src/the_mind/the_mind_nav_bar/widget/task/open_task.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_payment/add_payment_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog_responsive.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final List<String> _courses = ["All", "IELTS", "General English", "Math"];

  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Сообщение',
      body: 'Ваша оплата успешно принята',
      type: NotificationType.message,
    ),
  ];

  final List<AppNotification> _tasks = List.generate(
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Обзор показателей',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A2233),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Статистика центра на сегодня',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        const SizedBox(width: 300, child: BuildSearchBar()),
        const SizedBox(width: 10),
        _HomeIconButton(icon: Icons.task, onTap: _openTask),
        const SizedBox(width: 10),
        _HomeIconButton(icon: Icons.notifications, onTap: _openNotifications),
        const SizedBox(width: 10),
        _HomeIconButton(icon: Icons.add, onTap: _openAddMenu),
      ],
    );
  }

  void _openTask([TapDownDetails? details]) {
    if (details == null) return;
    OpenTask.openTask(
      context: context,
      details: details,
      tasks: _tasks,
      refresh: () => setState(() {}),
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
          child: _notifications.isEmpty
              ? const Text("Уведомлений нет")
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: _notifications.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = _notifications[index];
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
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AddStudentDialogResponsive(
            courses: _courses,
            groups: const ['Frontend A', 'Frontend B', 'IELTS 1', 'IELTS 2'],
          ),
        );
      case 'lid':
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AddStudentDialog(
            courses: _courses,
            groups: const ['Frontend A', 'Frontend B', 'IELTS 1', 'IELTS 2'],
            branches: const ["C1", "C2", "C4"],
          ),
        );
      case 'payment':
        if (!mounted) return;
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
        if (result != null && mounted) await _showPrintDialog(result);
    }
  }

  Future<void> _showPrintDialog(Map data) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("To'lov muvaffaqiyatli"),
        content: const Text("Chek chiqarilsinmi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Yo'q"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _printReceipt(data);
            },
            child: const Text("Ha, chiqarish"),
          ),
        ],
      ),
    );
  }

  Future<void> _printReceipt(Map data) async {
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
              child: pw.Text(
                "TO'LOV CHEKI",
                style: pw.TextStyle(fontSize: 22),
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Text("Ism: ${student.name}"),
            pw.Text("Guruh: ${student.group}"),
            pw.Text("Telefon: ${student.phone}"),
            pw.Text("To'lov turi: $method"),
            pw.Text("Sana: ${DateFormat('dd.MM.yyyy HH:mm').format(date)}"),
            pw.Divider(),
            pw.Text(
              "SUMMA: $amount so'm",
              style: pw.TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}

class _HomeIconButton extends StatelessWidget {
  final IconData icon;
  final void Function([TapDownDetails?]) onTap;

  const _HomeIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
}
