import 'package:afiete/core/network/api_endpoints.dart';
import 'package:afiete/feature/payment/data/models/payment_model.dart';
import 'package:afiete/feature/payment/domain/entities/payment_entity.dart';
import 'package:dio/dio.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentModel> processPayment(PaymentRequestEntity request);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio _dio;

  PaymentRemoteDataSourceImpl({required Dio dio}) : _dio = dio;

  @override
  Future<PaymentModel> processPayment(PaymentRequestEntity request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.appointmentsCreate,
        data: {
          'doctorId': request.doctorId,
          'patientId': request.patientId,
          'doctorName': request.doctorName,
          'scheduledAt': request.scheduledAt.toIso8601String(),
          'durationSlots': request.durationSlots,
          'sessionType': request.sessionType,
          'amount': request.amount,
          'currency': request.currency,
          'method': request.method.name,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data;
        if (body is Map<String, dynamic>) {
          return PaymentModel.fromJson(
            (body['payment'] as Map<String, dynamic>?) ?? body,
          );
        }
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
        requestOptions: RequestOptions(path: ApiEndpoints.appointmentsCreate),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }
}
