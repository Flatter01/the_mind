// import 'package:dio/dio.dart';
// import 'package:srm/src/the_mind/the_mind_students/data/model/students/student_model.dart';

// class StudentApiService {
//   final Dio dio = Dio(BaseOptions(baseUrl: 'https://yourapi.com'));

//   Future<void> createStudent(StudentModel student) async {
//     await dio.post('/students/', data: student.toJson());
//   }

//   Future<List<StudentModel>> fetchStudents() async {
//     final response = await dio.get('/students/');
//     final list = response.data as List;
//     return list.map((e) => StudentModel.fromJson(e)).toList();
//   }
// }