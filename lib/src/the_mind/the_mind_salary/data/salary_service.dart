// import 'package:flutter/material.dart';
// import 'package:srm/src/the_mind/the_mind_salary/presentation/widgets/recent_transactions_card.dart';

// class SalaryService {
//   /// Учитель → сумма
//   static Map<String, int> calculateTeacherTotals({
//     required List<Lesson> lessons,
//     required List<Group> groups,
//     required DateTimeRange range,
//   }) {
//     final Map<String, int> result = {};

//     for (final lesson in lessons) {
//       if (!lesson.isConfirmed) continue;
//       if (lesson.date.isBefore(range.start) || lesson.date.isAfter(range.end))
//         continue;

//       final group = groups.firstWhere((g) => g.id == lesson.groupId);

//       final salary = _lessonSalary(lesson, group);

//       result[lesson.teacherId] = (result[lesson.teacherId] ?? 0) + salary;
//     }

//     return result;
//   }

//   /// Учитель → Группа → сумма
//   static Map<String, Map<String, int>> calculateGroupTotals({
//     required List<Lesson> lessons,
//     required List<Group> groups,
//     required DateTimeRange range,
//   }) {
//     final Map<String, Map<String, int>> result = {};

//     for (final lesson in lessons) {
//       if (!lesson.isConfirmed) continue;
//       if (lesson.date.isBefore(range.start) || lesson.date.isAfter(range.end))
//         continue;

//       final group = groups.firstWhere((g) => g.id == lesson.groupId);
//       final salary = _lessonSalary(lesson, group);

//       result.putIfAbsent(lesson.teacherId, () => {});
//       result[lesson.teacherId]![group.name] =
//           (result[lesson.teacherId]![group.name] ?? 0) + salary;
//     }

//     return result;
//   }

//   /// Группа → список строк истории
//   static Map<String, List<String>> calculateLessonHistory({
//     required List<Lesson> lessons,
//     required List<Group> groups,
//     required DateTimeRange range,
//   }) {
//     final Map<String, List<String>> result = {};

//     for (final lesson in lessons) {
//       if (!lesson.isConfirmed) continue;
//       if (lesson.date.isBefore(range.start) || lesson.date.isAfter(range.end))
//         continue;

//       final group = groups.firstWhere((g) => g.id == lesson.groupId);
//       final salary = _lessonSalary(lesson, group);

//       result.putIfAbsent(group.name, () => []);
//       result[group.name]!.add(
//         "${lesson.date.day}.${lesson.date.month} | "
//         "${lesson.studentsCount} учеников | +$salary сум",
//       );
//     }

//     return result;
//   }

//   static int _lessonSalary(Lesson lesson, Group group) {
//     final fixed = lesson.studentsCount * group.fixedPerStudent;
//     final percent =
//         (lesson.studentsCount *
//             group.pricePerStudent *
//             group.percentPerStudent) ~/
//         100;
//     return fixed + percent;
//   }
// }
