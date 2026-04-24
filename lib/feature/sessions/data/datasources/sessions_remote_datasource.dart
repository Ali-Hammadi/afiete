import 'package:afiete/feature/sessions/data/models/review_model.dart';
import 'package:afiete/feature/sessions/data/models/session_model.dart';
import 'package:afiete/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

abstract class SessionsRemoteDataSource {
  Future<List<SessionModel>> getUpcomingSessions();

  Future<List<SessionModel>> getPastSessions();

  Future<SessionModel> joinSession(String sessionId);

  Future<void> cancelSession({
    required String sessionId,
    required String doctorId,
  });

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
  final Dio _dio;

  SessionsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<SessionModel>> getUpcomingSessions() async {
    try {
      final response = await _dio.get(ApiEndpoints.sessionsUpcoming);
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
        requestOptions: RequestOptions(path: ApiEndpoints.sessionsUpcoming),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<List<SessionModel>> getPastSessions() async {
    try {
      final response = await _dio.get(ApiEndpoints.sessionsPast);
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
        requestOptions: RequestOptions(path: ApiEndpoints.sessionsPast),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<SessionModel> joinSession(String sessionId) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.sessionsJoin,
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
        requestOptions: RequestOptions(path: ApiEndpoints.sessionsJoin),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<void> cancelSession({
    required String sessionId,
    required String doctorId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.sessionsCancel,
        data: {'sessionId': sessionId, 'doctorId': doctorId},
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
        requestOptions: RequestOptions(path: ApiEndpoints.sessionsCancel),
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
        ApiEndpoints.sessionsReschedule,
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
        requestOptions: RequestOptions(path: ApiEndpoints.sessionsReschedule),
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
        ApiEndpoints.sessionsReview,
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
        requestOptions: RequestOptions(path: ApiEndpoints.sessionsReview),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}
