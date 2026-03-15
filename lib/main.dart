import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:srm/src/core/colors/app_colors.dart';
import 'package:srm/src/the_mind/auth/data/auth_api_service.dart';
import 'package:srm/src/the_mind/auth/presentation/app_start_page.dart';
import 'package:srm/src/the_mind/auth/presentation/auth_page.dart';
import 'package:srm/src/the_mind/auth/presentation/cubit/auth_cubit.dart';
import 'package:srm/src/the_mind/the_mind_exams/data/datasources/exam_api_service.dart';
import 'package:srm/src/the_mind/the_mind_exams/presentation/cubit/exam_cubit.dart';
import 'package:srm/src/the_mind/the_mind_group/data/datasources/group_api_service.dart';
import 'package:srm/src/the_mind/the_mind_group/presentation/cubit/group/group_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_payment_servise.dart';
import 'package:srm/src/the_mind/the_mind_students/data/datasources/student_api_service.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/payment/payment_cubit.dart';
import 'package:srm/src/the_mind/the_mind_students/presentation/student/cubit/student/student_cubit.dart';
import 'package:srm/src/the_mind/the_mind_teacher/data/teacher_repository.dart';
import 'package:srm/src/the_mind/the_mind_teacher/presentation/cubit/teacher_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthApiService())),
        BlocProvider(
          create: (context) =>
              PaymentCubit(repository: StudentApiPaymentService())
                ..getPayments(),
        ),
        BlocProvider(
          create: (context) =>
              GroupCubit(repository: GroupRepository())..getGroups(),
        ),
        BlocProvider(
          create: (context) =>
              StudentCubit(repository: StudentRepository())..getStudents(),
        ),
        BlocProvider(
          create: (context) => ExamCubit(ExamApiService())..getExams(),
        ),
        // main.dart ёки providers файлида:
        BlocProvider(
          create: (_) => TeacherCubit(repository: TeacherRepository()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Mind',
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: AppColors.mainColor),
      ),
      home: AppStartPage(),
    );
  }
}
