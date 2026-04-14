import 'package:afiete/feature/voice/data/datasources/voice_remote_datasource.dart';
import 'package:afiete/feature/voice/data/models/voice_call_model.dart';
import 'package:afiete/feature/voice/domain/entities/voice_call_entity.dart';

class VoiceMockDataSourceImpl implements VoiceRemoteDataSource {
  final List<VoiceCallModel> _calls = [
    VoiceCallModel(
      id: 'voice_1',
      doctorId: 'doctor_1',
      patientId: 'patient_1',
      sessionId: 'session_1',
      startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      endedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      status: VoiceCallStatus.ended,
    ),
  ];

  @override
  Future<List<VoiceCallModel>> getCallHistory(String patientId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return _calls
        .where((item) => item.patientId == patientId)
        .toList(growable: false);
  }

  @override
  Future<VoiceCallModel> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 220));

    final created = VoiceCallModel(
      id: 'voice_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: doctorId,
      patientId: patientId,
      sessionId: sessionId,
      startedAt: DateTime.now(),
      endedAt: null,
      status: VoiceCallStatus.ongoing,
    );

    _calls.add(created);
    return created;
  }

  @override
  Future<VoiceCallModel> endCall(String callId) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));

    final index = _calls.indexWhere((item) => item.id == callId);
    if (index == -1) {
      throw StateError('Voice call not found');
    }

    final existing = _calls[index];
    final updated = VoiceCallModel(
      id: existing.id,
      doctorId: existing.doctorId,
      patientId: existing.patientId,
      sessionId: existing.sessionId,
      startedAt: existing.startedAt,
      endedAt: DateTime.now(),
      status: VoiceCallStatus.ended,
    );

    _calls[index] = updated;
    return updated;
  }
}
