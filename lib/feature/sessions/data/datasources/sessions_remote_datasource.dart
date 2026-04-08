import 'package:afiete/feature/sessions/data/models/review_model.dart';
import 'package:afiete/feature/sessions/data/models/session_model.dart';
import 'package:dio/dio.dart';

abstract class SessionsRemoteDataSource {
  Future<List<SessionModel>> getUpcomingSessions();

  Future<List<SessionModel>> getPastSessions();

  Future<SessionModel> joinSession(String sessionId);

  Future<void> cancelSession(String sessionId);

  Future<SessionModel> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  });

  Future<ReviewModel> addReview({
    required String sessionId,
    required int rating,
    required String comment,
  });
}

class SessionsRemoteDataSourceImpl implements SessionsRemoteDataSource {
  static const String _modulePath = '/api/sessions';
  final Dio _dio;

  SessionsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<SessionModel>> getUpcomingSessions() async {
    try {
      final response = await _dio.get('$_modulePath/upcoming');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sessions'] ?? [];
        return data
            .map(
              (session) =>
                  SessionModel.fromJson(session as Map<String, dynamic>),
            )
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_modulePath/upcoming'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<List<SessionModel>> getPastSessions() async {
    try {
      final response = await _dio.get('$_modulePath/past');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['sessions'] ?? [];
        return data
            .map(
              (session) =>
                  SessionModel.fromJson(session as Map<String, dynamic>),
            )
            .toList();
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_modulePath/past'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<SessionModel> joinSession(String sessionId) async {
    try {
      final response = await _dio.post(
        '$_modulePath/join',
        data: {'sessionId': sessionId},
      );
      if (response.statusCode == 200) {
        return SessionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_modulePath/join'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<void> cancelSession(String sessionId) async {
    try {
      final response = await _dio.post(
        '$_modulePath/cancel',
        data: {'sessionId': sessionId},
      );
      if (response.statusCode != 200) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_modulePath/cancel'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<SessionModel> rescheduleSession({
    required String sessionId,
    required DateTime newScheduledAt,
  }) async {
    try {
      final response = await _dio.post(
        '$_modulePath/reschedule',
        data: {
          'sessionId': sessionId,
          'newScheduledAt': newScheduledAt.toIso8601String(),
        },
      );
      if (response.statusCode == 200) {
        return SessionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_modulePath/reschedule'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<ReviewModel> addReview({
    required String sessionId,
    required int rating,
    required String comment,
  }) async {
    try {
      final response = await _dio.post(
        '$_modulePath/review',
        data: {'sessionId': sessionId, 'rating': rating, 'comment': comment},
      );
      if (response.statusCode == 201) {
        return ReviewModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '$_modulePath/review'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}
