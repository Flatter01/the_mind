import 'package:flutter/material.dart';
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

    return Dialog(
      insetPadding: EdgeInsets.all(isMobile ? 0 : 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 0 : 16),
      ),
      child: AddStudentForm(
        courses: courses,
        groups: groups,
        isMobile: isMobile,
      ),
    );
  }
}
