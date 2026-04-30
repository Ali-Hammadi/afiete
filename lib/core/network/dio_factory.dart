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

      final refreshedAccessToken =
          _extractAccessToken(response.data) ??
          _extractAccessToken(response.data?['data']) ??
          '';
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
    final responseMessage = _toUserFriendlyMessage(
      _extractResponseMessage(data),
    );

    if (statusCode == 400) {
      return responseMessage ??
          'Your request could not be processed. Please review the entered data and try again.';
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
    if (statusCode == 409) {
      return responseMessage ?? 'A conflicting resource already exists.';
    }
    if (statusCode == 422) {
      return responseMessage ?? 'Validation failed. Please review your input.';
    }
    if (statusCode == 429) {
      return responseMessage ?? 'Too many requests. Please try again later.';
    }
    if (statusCode != null && statusCode >= 500) {
      return responseMessage ?? 'Server error. Please try again later.';
    }

    return responseMessage ?? 'Unexpected error occurred. Please try again.';
  }

  static String? _extractResponseMessage(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is String) {
      final text = data.trim();
      if (text.isEmpty) {
        return null;
      }
      return _isGenericBackendMessage(text) ? null : text;
    }

    if (data is List) {
      for (final item in data) {
        final found = _extractResponseMessage(item);
        if (found != null && found.isNotEmpty) {
          return found;
        }
      }
      return null;
    }

    if (data is Map<String, dynamic>) {
      final directMessage = data['message']?.toString();
      if (directMessage != null &&
          directMessage.isNotEmpty &&
          !_isGenericBackendMessage(directMessage)) {
        return directMessage;
      }

      final detailMessage = data['detail']?.toString();
      if (detailMessage != null &&
          detailMessage.isNotEmpty &&
          !_isGenericBackendMessage(detailMessage)) {
        return detailMessage;
      }

      final nonFieldErrors = data['non_field_errors'];
      final nonFieldMessage = _extractResponseMessage(nonFieldErrors);
      if (nonFieldMessage != null && nonFieldMessage.isNotEmpty) {
        return nonFieldMessage;
      }

      const reservedKeys = {
        'message',
        'detail',
        'error',
        'errors',
        'status',
        'code',
      };

      for (final entry in data.entries) {
        if (reservedKeys.contains(entry.key.toLowerCase())) {
          continue;
        }
        final found = _extractResponseMessage(entry.value);
        if (found != null && found.isNotEmpty) {
          return found;
        }
      }

      final errorObj = data['error'];
      final errorMessage = _extractResponseMessage(errorObj);
      if (errorMessage != null && errorMessage.isNotEmpty) {
        return errorMessage;
      }

      final errors = data['errors'];
      final errorsMessage = _extractResponseMessage(errors);
      if (errorsMessage != null && errorsMessage.isNotEmpty) {
        return errorsMessage;
      }

      if (directMessage != null && directMessage.isNotEmpty) {
        return directMessage;
      }

      if (detailMessage != null && detailMessage.isNotEmpty) {
        return detailMessage;
      }
    }

    return null;
  }

  static bool _isGenericBackendMessage(String message) {
    final normalized = message.trim().toLowerCase();
    return normalized == 'invalid request. please check your input.' ||
        normalized == 'invalid request' ||
        normalized == 'bad request';
  }

  static String? _toUserFriendlyMessage(String? message) {
    if (message == null || message.trim().isEmpty) {
      return null;
    }

    final normalized = message.trim().toLowerCase();
    if (normalized.contains('already verified')) {
      return 'Your account is already verified. Please sign in directly.';
    }
    if (normalized.contains('already exists') ||
        normalized.contains('user with this email')) {
      return 'This email is already registered. Please sign in or use another email.';
    }
    if (normalized.contains('does not exist') ||
        normalized.contains('not found')) {
      return 'No account was found for this data. Please check your input or create a new account.';
    }
    if (normalized.contains('invalid otp') ||
        normalized.contains('invalid code')) {
      return 'The verification code is incorrect or expired. Please request a new code.';
    }
    if (normalized.contains('password') && normalized.contains('incorrect')) {
      return 'The current password is incorrect. Please try again.';
    }
    if (_isGenericBackendMessage(normalized)) {
      return 'Your request could not be processed. Please review the entered data and try again.';
    }

    return message.trim();
  }

  static String? _extractAccessToken(dynamic data) {
    if (data is Map<String, dynamic>) {
      final directAccess = data['access']?.toString();
      if (directAccess != null && directAccess.isNotEmpty) {
        return directAccess;
      }

      final nestedData = data['data'];
      if (nestedData is Map<String, dynamic>) {
        final nestedAccess = nestedData['access']?.toString();
        if (nestedAccess != null && nestedAccess.isNotEmpty) {
          return nestedAccess;
        }
      }
    }

    return null;
  }
}
