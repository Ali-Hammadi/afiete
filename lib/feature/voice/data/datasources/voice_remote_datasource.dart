import 'package:afiete/feature/voice/data/models/voice_call_model.dart';
import 'package:dio/dio.dart';

abstract class VoiceRemoteDataSource {
  Future<List<VoiceCallModel>> getCallHistory(String patientId);

  Future<VoiceCallModel> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  });

  Future<VoiceCallModel> endCall(String callId);
}

class VoiceRemoteDataSourceImpl implements VoiceRemoteDataSource {
  final Dio dio;

  const VoiceRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VoiceCallModel>> getCallHistory(String patientId) async {
    final response = await dio.get(
      '/voice/calls',
      queryParameters: {'patientId': patientId},
    );
    final data = response.data as List<dynamic>;
    return data
        .map((item) => VoiceCallModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<VoiceCallModel> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  }) async {
    final response = await dio.post(
      '/voice/calls/start',
      data: {
        'doctorId': doctorId,
        'patientId': patientId,
        'sessionId': sessionId,
      },
    );
    return VoiceCallModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<VoiceCallModel> endCall(String callId) async {
    final response = await dio.post('/voice/calls/$callId/end');
    return VoiceCallModel.fromJson(response.data as Map<String, dynamic>);
  }
}
