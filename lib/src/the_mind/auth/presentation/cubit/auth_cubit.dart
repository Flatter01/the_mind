import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:srm/src/the_mind/auth/data/auth_api_service.dart';
import 'package:srm/src/the_mind/auth/data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this.api) : super(AuthInitial());

  final AuthApiService api;
  final AuthRepository repo = AuthRepository();
  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final res = await api.login(username, password);

      final access = res.data['access'];
      final refresh = res.data['refresh'];

      repo.saveTokens(access, refresh);

      emit(AuthSuccess());
    } on DioException catch (e) {
      print("STATUS: ${e.response?.statusCode}");
      print("DATA: ${e.response?.data}");
      print("ERROR: ${e.message}");

      emit(AuthError("${e.response?.statusCode} ${e.response?.data}"));
    } catch (e) {
      print(e);
      emit(AuthError("Unknown error"));
    }
  }
}
