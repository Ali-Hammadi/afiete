import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    final cleanError = dioError.error?.toString().trim();
    if (cleanError != null && cleanError.isNotEmpty) {
      if (_isGenericMessage(cleanError)) {
        final statusCode = dioError.response?.statusCode;
        final responseData = dioError.response?.data;
        final parsed = ServerFailure.fromResponse(statusCode, responseData);
        if (parsed.errorMessage.isNotEmpty &&
            !_isGenericMessage(parsed.errorMessage)) {
          return parsed;
        }
      }

      return ServerFailure(_toUserFriendlyMessage(cleanError));
    }

    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timed out');

      case DioExceptionType.receiveTimeout:
        return ServerFailure('Failed to receive data');

      case DioExceptionType.sendTimeout:
        return ServerFailure('Failed to send data');

      case DioExceptionType.badCertificate:
        return ServerFailure('Certificate is not trusted');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioError.response?.statusCode,
          dioError.response?.data,
        );

      case DioExceptionType.cancel:
        return ServerFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return ServerFailure('Failed to connect to server');

      case DioExceptionType.unknown:
        if (dioError.message?.contains('SocketException') ?? false) {
          return ServerFailure('No internet connection');
        }
        return ServerFailure("Unexpected error, please try again");
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    String? extractedMessage;
    String code = '';

    if (response is Map<String, dynamic>) {
      final error = response['error'];
      if (error is Map<String, dynamic>) {
        extractedMessage = error['message']?.toString();
        code = error['code']?.toString() ?? '';
      }

      extractedMessage ??= _nonGeneric(response['detail']?.toString());
      extractedMessage ??= _nonGeneric(response['message']?.toString());

      final nonFieldErrors = response['non_field_errors'];
      if (extractedMessage == null &&
          nonFieldErrors is List &&
          nonFieldErrors.isNotEmpty) {
        extractedMessage = _extractNestedMessage(nonFieldErrors);
      }

      extractedMessage ??= _extractNestedMessage(response);

      extractedMessage ??= response['message']?.toString();
      extractedMessage ??= response['detail']?.toString();
    } else {
      extractedMessage = _extractNestedMessage(response);
    }

    extractedMessage = _toUserFriendlyMessage(extractedMessage ?? '');

    if (statusCode == 400) {
      return ServerFailure(
        extractedMessage.isNotEmpty
            ? extractedMessage
            : 'Your request could not be processed. Please review the entered data and try again.',
      );
    } else if (statusCode == 401) {
      return ServerFailure(
        extractedMessage.isNotEmpty
            ? extractedMessage
            : 'Authentication failed. Please sign in again.',
      );
    } else if (statusCode == 403) {
      return ServerFailure(
        extractedMessage.isNotEmpty
            ? extractedMessage
            : 'Access is forbidden for this account or action.',
      );
    } else if (statusCode == 404) {
      return ServerFailure(
        "${code.isNotEmpty ? '$code ' : ''}Your request was not found, please try again",
      );
    } else if (statusCode == 500) {
      return ServerFailure(
        "${code.isNotEmpty ? '$code ' : ''}Internal server error, please try later",
      );
    } else {
      return ServerFailure(
        extractedMessage.isNotEmpty
            ? extractedMessage
            : 'Something went wrong. Please try again.',
      );
    }
  }

  static String? _extractNestedMessage(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final text = value.trim();
      if (text.isEmpty) {
        return null;
      }
      return _isGenericMessage(text) ? null : text;
    }

    if (value is List) {
      for (final item in value) {
        final found = _extractNestedMessage(item);
        if (found != null && found.isNotEmpty) {
          return found;
        }
      }
      return null;
    }

    if (value is Map) {
      const reservedKeys = {
        'message',
        'detail',
        'error',
        'errors',
        'status',
        'code',
      };

      final map = value.cast<dynamic, dynamic>();
      final directMessage = map['message']?.toString();
      final directDetail = map['detail']?.toString();

      final messageCandidate = _nonGeneric(directMessage);
      if (messageCandidate != null) {
        return messageCandidate;
      }

      final detailCandidate = _nonGeneric(directDetail);
      if (detailCandidate != null) {
        return detailCandidate;
      }

      for (final entry in map.entries) {
        final key = entry.key.toString().toLowerCase();
        if (reservedKeys.contains(key)) {
          continue;
        }
        final found = _extractNestedMessage(entry.value);
        if (found != null && found.isNotEmpty) {
          return found;
        }
      }

      final fromError = _extractNestedMessage(map['error']);
      if (fromError != null && fromError.isNotEmpty) {
        return fromError;
      }

      final fromErrors = _extractNestedMessage(map['errors']);
      if (fromErrors != null && fromErrors.isNotEmpty) {
        return fromErrors;
      }

      if (directMessage != null && directMessage.trim().isNotEmpty) {
        return directMessage.trim();
      }
      if (directDetail != null && directDetail.trim().isNotEmpty) {
        return directDetail.trim();
      }
      return null;
    }

    return value.toString();
  }

  static String? _nonGeneric(String? message) {
    if (message == null) {
      return null;
    }
    final text = message.trim();
    if (text.isEmpty || _isGenericMessage(text)) {
      return null;
    }
    return text;
  }

  static bool _isGenericMessage(String message) {
    final normalized = message.trim().toLowerCase();
    return normalized == 'invalid request. please check your input.' ||
        normalized == 'invalid request' ||
        normalized == 'bad request' ||
        normalized == 'authentication error' ||
        normalized == 'ops there was an error, please try again';
  }

  static String _toUserFriendlyMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      return trimmed;
    }

    final normalized = trimmed.toLowerCase();
    if (normalized.contains('inactive') ||
        normalized.contains('disabled') ||
        normalized.contains('blocked') ||
        normalized.contains('suspended') ||
        normalized.contains('deactivated')) {
      return 'This account is inactive or restricted on the server, so sign-in is currently unavailable. Please contact support if you believe this is an error.';
    }
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
    if (_isGenericMessage(normalized)) {
      return 'Your request could not be processed. Please review the entered data and try again.';
    }

    return trimmed;
  }
}
