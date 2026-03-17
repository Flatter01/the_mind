import 'dart:convert';
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

  // ── Декодируем JWT и достаём user_id ──────────────────────────────────────
  String? get userId {
    final token = accessToken;
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Base64 padding
      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      final decoded = String.fromCharCodes(base64Decode(payload));
      final Map<String, dynamic> data = jsonDecode(decoded);

      // DEBUG — убери после проверки
      print('=== JWT PAYLOAD ===');
      print(data);
      print('===================');

      // Django REST + SimpleJWT обычно использует 'user_id'
      return data['user_id']?.toString() ??
          data['id']?.toString() ??
          data['sub']?.toString();
    } catch (e) {
      print('JWT decode error: $e');
      return null;
    }
  }

  // ── Все поля из JWT (для отладки) ─────────────────────────────────────────
  Map<String, dynamic>? get jwtPayload {
    final token = accessToken;
    if (token == null) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }

      final decoded = String.fromCharCodes(base64Decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}