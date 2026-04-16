import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/feature/report/data/models/report_model.dart';
import 'package:dio/dio.dart';

abstract class ReportRemoteDataSource {
  Future<ReportModel> submitReport({
    required String userId,
    required String reportType,
    String? targetId,
    String? targetName,
    required String reason,
    required String description,
  });

  Future<List<ReportModel>> getReportHistory({required String userId});

  Future<List<ReportModel>> getReportsByType({
    required String userId,
    required String reportType,
  });
}

class ReportRemoteDataSourceImpl implements ReportRemoteDataSource {
  final Dio _dio;

  ReportRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<ReportModel> submitReport({
    required String userId,
    required String reportType,
    String? targetId,
    String? targetName,
    required String reason,
    required String description,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.reportsSubmit,
        data: {
          'userId': userId,
          'reportType': reportType,
          'targetId': targetId,
          'targetName': targetName,
          'reason': reason,
          'description': description,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data;
        if (body is Map<String, dynamic>) {
          final reportJson =
              (body['report'] as Map<String, dynamic>?) ??
              (body['data'] as Map<String, dynamic>?) ??
              body;
          return ReportModel.fromJson(reportJson);
        }
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (error) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reportsSubmit),
        error: error,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<List<ReportModel>> getReportHistory({required String userId}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reportsHistory,
        queryParameters: {'userId': userId},
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body is List) {
          return body
              .whereType<Map<String, dynamic>>()
              .map(ReportModel.fromJson)
              .toList();
        }

        if (body is Map<String, dynamic>) {
          final rawReports = body['reports'] ?? body['data'] ?? body['items'];
          if (rawReports is List) {
            return rawReports
                .whereType<Map<String, dynamic>>()
                .map(ReportModel.fromJson)
                .toList();
          }
        }
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (error) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reportsHistory),
        error: error,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<List<ReportModel>> getReportsByType({
    required String userId,
    required String reportType,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.reportsByType,
        queryParameters: {'userId': userId, 'reportType': reportType},
      );

      if (response.statusCode == 200) {
        final body = response.data;
        if (body is List) {
          return body
              .whereType<Map<String, dynamic>>()
              .map(ReportModel.fromJson)
              .toList();
        }

        if (body is Map<String, dynamic>) {
          final rawReports = body['reports'] ?? body['data'] ?? body['items'];
          if (rawReports is List) {
            return rawReports
                .whereType<Map<String, dynamic>>()
                .map(ReportModel.fromJson)
                .toList();
          }
        }
      }

      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    } on DioException {
      rethrow;
    } catch (error) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.reportsByType),
        error: error,
        type: DioExceptionType.unknown,
      );
    }
  }
}
