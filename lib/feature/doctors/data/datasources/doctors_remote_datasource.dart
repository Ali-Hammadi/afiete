import 'package:dio/dio.dart';
import 'package:afiete/feature/doctors/data/models/doctor_model.dart';

abstract class DoctorsRemoteDataSource {
  Future<List<DoctorModel>> getAllDoctors();
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty);
  Future<DoctorModel> getDoctorById(String id);
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  static const String _modulePath = '/api/doctors';
  final Dio _dio;

  DoctorsRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final response = await _dio.get(_modulePath);
      if (response.statusCode == 200) {
        final doctors = List<DoctorModel>.from(
          (response.data['doctors'] as List? ?? response.data as List)
              .map((model) => DoctorModel.fromJson(model as Map<String, dynamic>))
        );
        return doctors;
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
        requestOptions: RequestOptions(path: _modulePath),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    try {
      final response = await _dio.get(
        _modulePath,
        queryParameters: {'specialization': specialty},
      );
      if (response.statusCode == 200) {
        final doctors = List<DoctorModel>.from(
          (response.data['doctors'] as List? ?? response.data as List)
              .map((model) => DoctorModel.fromJson(model as Map<String, dynamic>))
        );
        return doctors;
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
        requestOptions: RequestOptions(path: _modulePath),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    try {
      final response = await _dio.get('$_modulePath/$id');
      if (response.statusCode == 200) {
        return DoctorModel.fromJson(response.data as Map<String, dynamic>);
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
        requestOptions: RequestOptions(path: '$_modulePath/$id'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}
