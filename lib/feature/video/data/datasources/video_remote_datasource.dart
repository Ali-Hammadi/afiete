import 'package:afiete/feature/video/data/models/video_call_model.dart';
import 'package:dio/dio.dart';

abstract class VideoRemoteDataSource {
  Future<List<VideoCallModel>> getCallHistory(String patientId);

  Future<VideoCallModel> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  });

  Future<VideoCallModel> endCall(String callId);
}

class VideoRemoteDataSourceImpl implements VideoRemoteDataSource {
  final Dio dio;

  const VideoRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<VideoCallModel>> getCallHistory(String patientId) async {
    final response = await dio.get(
      '/video/calls',
      queryParameters: {'patientId': patientId},
    );
    final data = response.data as List<dynamic>;
    return data
        .map((item) => VideoCallModel.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);
  }

  @override
  Future<VideoCallModel> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  }) async {
    final response = await dio.post(
      '/video/calls/start',
      data: {
        'doctorId': doctorId,
        'patientId': patientId,
        'sessionId': sessionId,
      },
    );
    return VideoCallModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<VideoCallModel> endCall(String callId) async {
    final response = await dio.post('/video/calls/$callId/end');
    return VideoCallModel.fromJson(response.data as Map<String, dynamic>);
  }
}
