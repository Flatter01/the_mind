import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:srm/src/the_mind/home/data/models/build_debtors_table_models.dart';

part 'api_service.g.dart';

@injectable
@RestApi(baseUrl: "https://api.humanspace.uz/api/v1")
abstract class ApiService {

  @factoryMethod
  factory ApiService(Dio dio) = _ApiService;

  /// Получить студентов
  @GET("/students")
  Future<List<BuildDebtorsTableModels>> getStudents();

  /// Создать студента
  @POST("/students")
  Future<BuildDebtorsTableModels> createStudent(
    @Body() Map<String, dynamic> data,
  );

  /// Получить группы
  @GET("/groups")
  Future<BuildDebtorsTableModels> getGroups();
}
