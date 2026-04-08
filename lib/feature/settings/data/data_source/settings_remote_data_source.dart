import 'package:afiete/feature/settings/data/models/medical_profile_model.dart';
import 'package:afiete/core/network/api_endpoints.dart';
import 'package:dio/dio.dart';

abstract class SettingsRemoteDataSource {
  Future<MedicalProfileModel> getMedicalProfile(String userId);

  Future<String> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  });
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final Dio _dio;

  SettingsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<MedicalProfileModel> getMedicalProfile(String userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.settingsMedicalProfile,
        queryParameters: {'userId': userId},
      );
      if (response.statusCode == 200) {
        return MedicalProfileModel.fromJson(
          (response.data['data'] ?? response.data) as Map<String, dynamic>,
        );
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to load medical profile',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(
          path: ApiEndpoints.settingsMedicalProfile,
        ),
        error: e.toString(),
      );
    }
  }

  @override
  Future<String> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.settingsReports,
        data: {'userId': userId, 'reason': reason, 'details': details},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['message']?.toString() ??
            'Report submitted successfully.';
      }
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Failed to submit report',
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: ApiEndpoints.settingsReports),
        error: e.toString(),
      );
    }
  }
}
