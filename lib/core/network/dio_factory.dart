import 'package:dio/dio.dart';

abstract class DioFactory {
  static const String baseUrl = 'https://api.example.com';

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }
}
