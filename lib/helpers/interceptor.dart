import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  static final _storage = FlutterSecureStorage();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.read(key: 'token') ?? '';
    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Ocurrió un error inesperado.';

    if (err.type == DioExceptionType.connectionTimeout) {
      message = 'Tiempo de conexión agotado.';
    } else if (err.type == DioExceptionType.receiveTimeout) {
      message = 'Tiempo de respuesta agotado.';
    } else if (err.type == DioExceptionType.badResponse) {
      final statusCode = err.response?.statusCode;
      if (statusCode == 400) {
        message = 'Petición incorrecta.';
      } else if (statusCode == 401) {
        message = 'No autorizado. Inicia sesión nuevamente.';
        _storage.delete(key: 'token');
      } else if (statusCode == 404) {
        message = 'Recurso no encontrado.';
      } else if (statusCode == 500) {
        message = 'Error del servidor. Intenta más tarde.';
      }
    } else if (err.type == DioExceptionType.unknown) {
      message = 'No hay conexión a internet o el servidor no responde.';
    }

    return handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message,
      ),
    );
  }
}
