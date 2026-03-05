import 'package:flutter/material.dart';
import 'package:srm/src/core/widgets/build_filters.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/group_details/presentation/group_details.dart';
import 'package:srm/src/the_mind/the_mind_group/data/models/group_model.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/the_mind_groups/widgets/build_group_table.dart';

class TheMindGroup extends StatefulWidget {
  const TheMindGroup({super.key});

  @override
  State<TheMindGroup> createState() => _TheMindGroupState();
}

class _TheMindGroupState extends State<TheMindGroup> {
  String selectedTeacher = 'All';
  String selectedStatus = 'All';
  String searchQuery = '';

  final teachers = ['All', 'Ali Karimov', 'Dilshod Akbarov'];
  final statuses = ['All', 'Active', 'Finished'];

  final List<GroupModel> groups = [
    GroupModel(
      name: 'Flutter Beginners',
      teacher: 'Ali Karimov',
      students: 8,
      status: GroupStatus.active,
      createdAt: DateTime(2024, 9, 12),
      lessonTime: '18:00 – 20:00',
      weekType: WeekType.odd,
      exmans: ExmansStatus.finished,
      days: 'Mon • Wed • Fri',
      level: GroupLevel.beginner,
      levelStage: 2,
      studentsLimit: 10
    ),
    GroupModel(
      name: 'UI/UX Design',
      teacher: 'Dilshod Akbarov',
      students: 12,
      status: GroupStatus.finished,
      createdAt: DateTime(2024, 7, 3),
      lessonTime: '16:00 – 18:00',
      weekType: WeekType.even,
      exmans: ExmansStatus.open,
      days: 'Tue • Thu',
      level: GroupLevel.elementary,
      levelStage: 1,
      studentsLimit: 15
    ),
  ];

  List<GroupModel> get filteredGroups {
    return groups.where((g) {
      final matchesSearch = g.name.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesTeacher =
          selectedTeacher == 'All' || g.teacher == selectedTeacher;

      final matchesStatus =
          selectedStatus == 'All' || g.status.label == selectedStatus;

      return matchesSearch && matchesTeacher && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: ListView(
        padding: EdgeInsets.all(isWeb ? 24 : 16),
        children: [
          BuildSearchBar(),
          const SizedBox(height: 20),

          BuildFilters(teachers: [], courses: [], chek: true),

          const SizedBox(height: 20),

          BuildGroupTable(groups: groups,),
        ],
      ),
    );
  }
}