import 'package:afiete/feature/voice/domain/entities/voice_call_entity.dart';

class VoiceCallModel extends VoiceCallEntity {
  const VoiceCallModel({
    required super.id,
    required super.doctorId,
    required super.patientId,
    required super.sessionId,
    required super.startedAt,
    required super.endedAt,
    required super.status,
  });

  factory VoiceCallModel.fromJson(Map<String, dynamic> json) {
    return VoiceCallModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      sessionId: json['sessionId'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] == null
          ? null
          : DateTime.parse(json['endedAt'] as String),
      status: _statusFromJson(json['status'] as String? ?? 'ringing'),
    );
  }

  factory VoiceCallModel.fromEntity(VoiceCallEntity entity) {
    return VoiceCallModel(
      id: entity.id,
      doctorId: entity.doctorId,
      patientId: entity.patientId,
      sessionId: entity.sessionId,
      startedAt: entity.startedAt,
      endedAt: entity.endedAt,
      status: entity.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'patientId': patientId,
      'sessionId': sessionId,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'status': _statusToJson(status),
    };
  }

  static VoiceCallStatus _statusFromJson(String value) {
    switch (value) {
      case 'ongoing':
        return VoiceCallStatus.ongoing;
      case 'ended':
        return VoiceCallStatus.ended;
      case 'missed':
        return VoiceCallStatus.missed;
      default:
        return VoiceCallStatus.ringing;
    }
  }

  static String _statusToJson(VoiceCallStatus status) {
    switch (status) {
      case VoiceCallStatus.ongoing:
        return 'ongoing';
      case VoiceCallStatus.ended:
        return 'ended';
      case VoiceCallStatus.missed:
        return 'missed';
      case VoiceCallStatus.ringing:
        return 'ringing';
    }
  }
}
