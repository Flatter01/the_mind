import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/widgets/add_student/add_student_form.dart';

class AddStudentDialogResponsive extends StatelessWidget {
  final List<String> courses;
  final List<String> groups;
  final List<GroupModel> groupModels; // ← қўшилди

  const AddStudentDialogResponsive({
    super.key,
    required this.courses,
    required this.groups,
    this.groupModels = const [], // ← default bo'sh
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      insetPadding: isMobile
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: AddStudentForm(
        courses: courses,
        groups: groups,
        groupModels: groupModels, // ← берилди
        isMobile: isMobile,
      ),
    );
  }
}