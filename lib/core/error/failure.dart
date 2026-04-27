import 'package:dio/dio.dart';

abstract class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    final cleanError = dioError.error?.toString();
    if (cleanError != null && cleanError.isNotEmpty) {
      return ServerFailure(cleanError);
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

      extractedMessage ??= response['detail']?.toString();
      extractedMessage ??= response['message']?.toString();

      final nonFieldErrors = response['non_field_errors'];
      if (extractedMessage == null &&
          nonFieldErrors is List &&
          nonFieldErrors.isNotEmpty) {
        extractedMessage = nonFieldErrors.first.toString();
      }

      if (extractedMessage == null) {
        for (final value in response.values) {
          if (value is List && value.isNotEmpty) {
            extractedMessage = value.first.toString();
            break;
          }
        }
      }
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(extractedMessage ?? "Authentication error");
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
        extractedMessage ?? "Ops there was an error, please try again",
      );
    }
  }
}
