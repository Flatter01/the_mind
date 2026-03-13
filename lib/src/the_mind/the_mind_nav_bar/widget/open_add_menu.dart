import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/model/students/build_students_table_ltem.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_state.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_payment/add_payment_dialog_responsive.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_dialog_responsive.dart';

// Здесь мы делаем класс вспомогательным для открытия меню
class OpenAddMenu {
  static void openAddMenu({
    required BuildContext context,
    required TapDownDetails details,
    required List<String> courses,
    required List<BuildStudentsTableItem> students,
  }) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        0,
        0,
      ),
      items: [
        PopupMenuItem(
          value: 'student',
          child: Row(
            children: const [
              Icon(Icons.person_add, size: 18),
              SizedBox(width: 8),
              Text("Добавить участника"),
            ],
          ),
          onTap: () async {
            final result = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AddStudentDialogResponsive(
                courses: courses,
                groups: const [
                  'Frontend A',
                  'Frontend B',
                  'IELTS 1',
                  'IELTS 2',
                ],
              ),
            );

            if (result != null) {
              debugPrint('NEW STUDENT: $result');
            }
          },
        ),
        PopupMenuItem(
          value: 'payment',
          child: Row(
            children: const [
              Icon(Icons.payments, size: 18),
              SizedBox(width: 8),
              Text("Совершить оплату"),
            ],
          ),
          onTap: () async {
            final paymentCubit = context.read<PaymentCubit>();
            final result = await showDialog(
              context: context,
              barrierDismissible: false,
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
                      return AddPaymentDialogResponsive(
                        students: state.students,
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            );

            if (result != null) {
              debugPrint('NEW PAYMENT: $result');
              // await paymentService.savePayment(result);
              await _showPrintDialog(context, result);
            }
          },
        ),
      ],
    );
  }

  // Пример функции для показа диалога печати
  static Future<void> _showPrintDialog(
    BuildContext context,
    dynamic payment,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Печать чека"),
        content: Text("Платёж: $payment"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Закрыть"),
          ),
        ],
      ),
    );
  }
}
