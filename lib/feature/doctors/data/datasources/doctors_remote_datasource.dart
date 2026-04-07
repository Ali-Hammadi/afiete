import 'package:dio/dio.dart';
import 'package:afiete/feature/doctors/data/models/doctor_model.dart';

abstract class DoctorsRemoteDataSource {
  Future<List<DoctorModel>> getAllDoctors();
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty);
  Future<DoctorModel> getDoctorById(String id);
}

class DoctorsRemoteDataSourceImpl implements DoctorsRemoteDataSource {
  static const String _baseUrl = 'https://api.example.com/api/doctors/';
  late final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  @override
  Future<List<DoctorModel>> getAllDoctors() async {
    try {
      final response = await _dio.get('/');
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
        requestOptions: RequestOptions(path: '/'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    try {
      final response = await _dio.get('/', queryParameters: {'specialization': specialty});
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
        requestOptions: RequestOptions(path: '/'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<DoctorModel> getDoctorById(String id) async {
    try {
      final response = await _dio.get('/$id');
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
        requestOptions: RequestOptions(path: '/$id'),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}
