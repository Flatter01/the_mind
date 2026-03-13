import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_form.dart';

class AddStudentDialogResponsive extends StatelessWidget {
  final List<String> courses;
  final List<String> groups;

  const AddStudentDialogResponsive({
    super.key,
    required this.courses,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    StudentCubit? existingCubit;
    try {
      existingCubit = BlocProvider.of<StudentCubit>(context);
    } catch (_) {
      existingCubit = null;
    }
    final form = AddStudentForm(
      courses: courses,
      groups: groups,
      isMobile: isMobile,
    );

    return Dialog(
      insetPadding: EdgeInsets.all(isMobile ? 0 : 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 0 : 16),
      ),
      child: existingCubit != null
          ? BlocProvider.value(value: existingCubit, child: form)
          : BlocProvider(
              create: (_) => StudentCubit(repository: StudentRepository()),
              child: form,
            ),
    );
  }
}
