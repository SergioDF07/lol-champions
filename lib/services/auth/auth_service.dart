import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lol_champions/model/auth/auth_model.dart';

class AuthService {
  static final _dio = Dio();
  static final _storage = FlutterSecureStorage();
  static const _url = 'https://fakestoreapi.com/auth/login';

  /// Demo login: this project has no backend of its own, so it uses the
  /// Fake Store API's demo auth endpoint. Fake Store API only recognizes a
  /// fixed set of seeded users, so the known-good demo credentials
  /// (mor_2314 / 83r5^_) are used regardless of what was typed, as long as
  /// both fields are filled in.
  static Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        _url,
        data: {'username': 'mor_2314', 'password': '83r5^_'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return 'Respuesta inesperada del servidor.';
      }

      final auth = AuthModel.fromJson(response.data);
      if (auth.accessToken == 'No token') {
        return 'No se recibió un token de acceso.';
      }

      await _storage.write(key: 'token', value: auth.accessToken);
      return null;
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response?.statusCode == 401) {
          return 'Usuario o contraseña incorrectos.';
        }
        return 'Error del servidor: ${e.response?.statusCode}';
      }
      return 'Error de red. Revisa tu conexión a internet.';
    }
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
