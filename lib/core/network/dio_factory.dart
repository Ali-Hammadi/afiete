import 'package:dio/dio.dart';
import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/core/network/token_storage.dart';

abstract class DioFactory {
  static const String baseUrl = 'https://workserveys.pythonanywhere.com';

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (err, handler) async {
          final unauthorized = err.response?.statusCode == 401;
          final alreadyRetried =
              err.requestOptions.headers['x-no-retry'] == true;

          if (unauthorized && !alreadyRetried) {
            final refreshed = await _tryRefreshToken(dio);
            if (refreshed) {
              final retryOptions = err.requestOptions;
              retryOptions.headers['x-no-retry'] = true;
              final newAccessToken = await TokenStorage.getAccessToken();
              if (newAccessToken != null && newAccessToken.isNotEmpty) {
                retryOptions.headers['Authorization'] =
                    'Bearer $newAccessToken';
              }

              try {
                final retryResponse = await dio.fetch<dynamic>(retryOptions);
                return handler.resolve(retryResponse);
              } catch (_) {
                // Fallback to default mapped error below.
              }
            }
          }

          final cleanMessage = _mapDioErrorToMessage(err);
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              response: err.response,
              type: err.type,
              error: cleanMessage,
              message: cleanMessage,
            ),
          );
        },
      ),
    );

    return dio;
  }

  static Future<bool> _tryRefreshToken(Dio dio) async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      final response = await refreshDio.post<Map<String, dynamic>>(
        ApiEndpoints.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      final refreshedAccessToken = response.data?['access']?.toString() ?? '';
      if (refreshedAccessToken.isEmpty) {
        return false;
      }

      await TokenStorage.saveTokens(
        accessToken: refreshedAccessToken,
        refreshToken: refreshToken,
      );

      return true;
    } catch (_) {
      await TokenStorage.clearTokens();
      return false;
    }
  }

  static String _mapDioErrorToMessage(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return 'The connection timed out. Please try again.';
    }

    if (err.type == DioExceptionType.connectionError) {
      return 'Unable to connect to server. Check your internet connection.';
    }

    if (err.type == DioExceptionType.cancel) {
      return 'Request was cancelled.';
    }

    final statusCode = err.response?.statusCode;
    final data = err.response?.data;
    final responseMessage = _extractResponseMessage(data);

    if (statusCode == 400) {
      return responseMessage ?? 'Invalid request. Please check your input.';
    }
    if (statusCode == 401) {
      return responseMessage ?? 'You are not authorized. Please log in again.';
    }
    if (statusCode == 403) {
      return responseMessage ?? 'Access denied.';
    }
    if (statusCode == 404) {
      return responseMessage ?? 'Requested resource was not found.';
    }
    if (statusCode == 422) {
      return responseMessage ?? 'Validation failed. Please review your input.';
    }
    if (statusCode != null && statusCode >= 500) {
      return responseMessage ?? 'Server error. Please try again later.';
    }

    return responseMessage ?? 'Unexpected error occurred. Please try again.';
  }

  static String? _extractResponseMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final directMessage = data['message']?.toString();
      if (directMessage != null && directMessage.isNotEmpty) {
        return directMessage;
      }

      final errorObj = data['error'];
      if (errorObj is Map<String, dynamic>) {
        final nestedMessage = errorObj['message']?.toString();
        if (nestedMessage != null && nestedMessage.isNotEmpty) {
          return nestedMessage;
        }
      }
    }

    return null;
  }
}
