import 'package:get_storage/get_storage.dart';

class AuthRepository {
  final box = GetStorage();

  String? get accessToken => box.read('accessToken');
  String? get refreshToken => box.read('refreshToken');
  bool get isLoggedIn => accessToken != null;

  void saveTokens(String access, String refresh) {
    box.write('accessToken', access);
    box.write('refreshToken', refresh);
  }

  void logout() {
    box.remove('accessToken');
    box.remove('refreshToken');
  }
}