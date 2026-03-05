import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/core/widgets/build_search_bar.dart';
import 'package:srm/src/core/widgets/card/app_card.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/datasources/exam_api_service.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/cubit/exam_cubit.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/widgets/add_exam_dialog.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/widgets/edit_exam_dialog.dart';

/// ================= MODELS =================

class ExamItem {
  String title;
  String group;
  String teacher;
  String direction;
  DateTime date;
  bool isFinished;
  List<StudentMark> students;

  ExamItem({
    required this.title,
    required this.group,
    required this.direction,
    required this.date,
    required this.teacher,
    this.isFinished = false,
    this.students = const [],
  });
}

class StudentMark {
  String fullName;
  int mark;

  StudentMark({required this.fullName, required this.mark});
}

class Student {
  final String fullName;
  final String group;

  Student({required this.fullName, required this.group});
}

/// ================= PAGE =================

class TheMindExamsPage extends StatefulWidget {
  const TheMindExamsPage({super.key});

  @override
  State<TheMindExamsPage> createState() => _TheMindExamsPageState();
}

class _TheMindExamsPageState extends State<TheMindExamsPage> {
  /// ---------- TEACHERS ----------
  final List<String> teachers = const [
    "Ali Aliev",
    "Aziz Azizev",
    "Muhammad",
    "John Smith",
  ];

  /// ---------- EXAMS ----------
  final List<ExamItem> exams = [
    ExamItem(
      title: "Flutter Development Exam",
      group: "Group A",
      direction: "Mobile Development",
      teacher: "Ali Aliev",
      date: DateTime(2025, 6, 20),
    ),
    ExamItem(
      title: "English Proficiency Exam",
      group: "Group B",
      direction: "Languages",
      teacher: "Aziz Azizev",
      date: DateTime(2025, 6, 10),
      isFinished: true,
    ),
    ExamItem(
      title: "Business Fundamentals Exam",
      group: "Group C",
      direction: "Business",
      teacher: "Muhammad",
      date: DateTime(2025, 6, 25),
    ),
  ];

  /// ---------- STUDENTS ----------
  final List<Student> allStudents = [
    Student(fullName: "Ali Valiyev", group: "Group A"),
    Student(fullName: "Hasan Karimov", group: "Group A"),
    Student(fullName: "John Smith", group: "Group B"),
    Student(fullName: "Sara Lee", group: "Group B"),
    Student(fullName: "Tom Brown", group: "Group C"),
  ];

  String selectedGroup = 'All';
  String search = '';

  /// ---------- GROUPS ----------
  List<String> get groups => [
    'All',
    ...{for (final e in exams) e.group},
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;

    final filtered = exams.where((e) {
      final matchGroup = selectedGroup == 'All' || e.group == selectedGroup;

      final matchSearch = e.title.toLowerCase().contains(search.toLowerCase());

      return matchGroup && matchSearch;
    }).toList();

    return BlocProvider(
      create: (_) => ExamCubit(ExamApiService())..getExams(),

      child: Scaffold(
        backgroundColor: AppColors.bgColor,

        /// ADD BUTTON
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: _addExam,
          child: const Icon(Icons.add, color: Colors.white),
        ),

        body: BlocBuilder<ExamCubit, ExamState>(
          builder: (context, state) {
            if (state is ExamLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ExamError) {
              print("Eroooooooor: ${state.message}");
              return Center(child: Text(state.message));
            }
            if(state is ExamLoaded){
                     return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// SEARCH + FILTER
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: BuildSearchBar(
                              onChanged: (v) => setState(() => search = v),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(flex: 1, child: _groupFilter()),
                        ],
                      ),

                      const SizedBox(height: 24),

                      /// LIST / GRID
                      Expanded(
                        child: isWeb
                            ? GridView.builder(
                                itemCount: filtered.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      mainAxisExtent: 200,
                                    ),
                                itemBuilder: (_, i) => _examCard(filtered[i]),
                              )
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (_, i) => _examCard(filtered[i]),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  /// ================= FILTER =================

  Widget _groupFilter() {
    return DropdownButtonFormField<String>(
      value: selectedGroup,

      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),

      items: groups
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),

      onChanged: (v) => setState(() => selectedGroup = v!),
    );
  }

  /// ================= CARD =================

  Widget _examCard(ExamItem e) {
    final finished = e.isFinished;

    return InkWell(
      onTap: () => _editExam(e),

      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE + STATUS
            Row(
              children: [
                Expanded(
                  child: Text(
                    e.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                _statusChip(finished),
              ],
            ),

            const SizedBox(height: 14),

            _infoRow(icon: Icons.groups_outlined, text: e.group),

            _infoRow(icon: Icons.person_outline, text: e.teacher),

            _infoRow(icon: Icons.school_outlined, text: e.direction),

            _infoRow(
              icon: Icons.calendar_month_outlined,
              text: "${e.date.day}.${e.date.month}.${e.date.year}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),

      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),

          Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _statusChip(bool finished) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

      decoration: BoxDecoration(
        color: finished
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Text(
        finished ? "Finished" : "Open",

        style: TextStyle(
          color: finished ? Colors.green : Colors.orange,

          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// ================= ADD =================

  void _addExam() {
    showDialog(
      context: context,

      builder: (_) => AddExamDialog(
        teachers: teachers, // 🔥 важно
        groups: groups,
        onAdd: (exam) {
          setState(() => exams.add(exam));
        },
      ),
    );
  }

  /// ================= EDIT =================

  void _editExam(ExamItem exam) {
    showDialog(
      context: context,

      builder: (_) => EditExamDialog(
        exam: exam,
        teachers: teachers, // 🔥 важно
        allStudents: allStudents,
        onSave: () => setState(() {}),
      ),
    );
  }
}
