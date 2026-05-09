import 'dart:developer' as developer;
import 'dart:convert';

/// Lightweight structured logger used across the app.
class AppLogger {
  final String name;

  const AppLogger._(this.name);

  static AppLogger of(String name) => AppLogger._(name);

  void info(String message, {Map<String, dynamic>? data}) {
    developer.log(_format(message, data), name: name, level: 800); // INFO
  }

  void warn(String message, {Map<String, dynamic>? data}) {
    developer.log(_format(message, data), name: name, level: 900); // WARNING
  }

  void error(
    String message, {
    Map<String, dynamic>? data,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final payload = _format(message, data);
    developer.log(
      payload,
      name: name,
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _format(String message, Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) return message;
    try {
      return '$message | ${jsonEncode(data)}';
    } catch (_) {
      return '$message | $data';
    }
  }
}

// Convenience top-level helpers
AppLogger loggerFor(String name) => AppLogger.of(name);
