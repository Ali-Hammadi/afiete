import 'package:afiete/feature/video/data/datasources/video_remote_datasource.dart';
import 'package:afiete/feature/video/data/models/video_call_model.dart';
import 'package:afiete/feature/video/domain/entities/video_call_entity.dart';

class VideoMockDataSourceImpl implements VideoRemoteDataSource {
  final List<VideoCallModel> _calls = [
    VideoCallModel(
      id: 'video_1',
      doctorId: 'doctor_1',
      patientId: 'patient_1',
      sessionId: 'session_1',
      startedAt: DateTime.now().subtract(const Duration(hours: 2)),
      endedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 35)),
      status: VideoCallStatus.ended,
    ),
  ];

  @override
  Future<List<VideoCallModel>> getCallHistory(String patientId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _calls
        .where((item) => item.patientId == patientId)
        .toList(growable: false);
  }

  @override
  Future<VideoCallModel> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    final created = VideoCallModel(
      id: 'video_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      patientId: patientId,
      sessionId: sessionId,
      startedAt: DateTime.now(),
      endedAt: null,
      status: VideoCallStatus.ongoing,
    );

    _calls.add(created);
    return created;
  }

  @override
  Future<VideoCallModel> endCall(String callId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));

    final index = _calls.indexWhere((item) => item.id == callId);
    if (index == -1) {
      throw StateError('Video call not found');
    }

    final existing = _calls[index];
    final updated = VideoCallModel(
      id: existing.id,
      doctorId: existing.doctorId,
      patientId: existing.patientId,
      sessionId: existing.sessionId,
      startedAt: existing.startedAt,
      endedAt: DateTime.now(),
      status: VideoCallStatus.ended,
    );

    _calls[index] = updated;
    return updated;
  }
}
