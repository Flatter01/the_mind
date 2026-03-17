import 'package:flutter/material.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_form.dart';

class AddStudentDialogResponsive extends StatelessWidget {
  final List<String> courses;
  final List<String> groups;
  final List<GroupModel> groupModels;

  const AddStudentDialogResponsive({
    super.key,
    required this.courses,
    required this.groups,
    this.groupModels = const [],
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: isMobile
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 0,
      child: AddStudentForm(
        courses: courses,
        groups: groups,
        groupModels: groupModels,
        isMobile: isMobile,
      ),
    );
  }
}