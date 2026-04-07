import 'package:afiete/feature/booking_assiments/data/models/appointment_model.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:dio/dio.dart';

abstract class AppointmentsRemoteDataSource {
  Future<List<AppointmentModel>> getAppointments();

  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required String patientId,
    required String doctorName,
    required DateTime scheduledAt,
    required int durationSlots,
    required ConsultationFee consultationFee,
    required String sessionType,
  });
}

class AppointmentsRemoteDataSourceImpl implements AppointmentsRemoteDataSource {
  static const String _baseUrl = 'https://api.example.com/api/appointments/';
  late final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _dio.get('/list');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['appointments'] ?? [];
        return data
            .map(
              (apt) => AppointmentModel.fromJson(apt as Map<String, dynamic>),
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
        requestOptions: RequestOptions(path: _baseUrl),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  @override
  Future<AppointmentModel> createAppointment({
    required String doctorId,
    required String patientId,
    required String doctorName,
    required DateTime scheduledAt,
    required int durationSlots,
    required ConsultationFee consultationFee,
    required String sessionType,
  }) async {
    try {
      final response = await _dio.post(
        '/create',
        data: {
          'doctorId': doctorId,
          'patientId': patientId,
          'doctorName': doctorName,
          'scheduledAt': scheduledAt.toIso8601String(),
          'durationSlots': durationSlots,
          'consultationFee': {
            'textChat': consultationFee.textChat,
            'videoCall': consultationFee.videoCall,
            'voiceCall': consultationFee.voiceCall,
          },
          'sessionType': sessionType,
        },
      );

      if (response.statusCode == 201) {
        return AppointmentModel.fromJson(response.data as Map<String, dynamic>);
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
        requestOptions: RequestOptions(path: _baseUrl),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}
