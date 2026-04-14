import 'package:afiete/feature/video/domain/entities/video_call_entity.dart';

class VideoCallModel extends VideoCallEntity {
  const VideoCallModel({
    required super.id,
    required super.doctorId,
    required super.patientId,
    required super.sessionId,
    required super.startedAt,
    required super.endedAt,
    required super.status,
  });

  factory VideoCallModel.fromJson(Map<String, dynamic> json) {
    return VideoCallModel(
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

  factory VideoCallModel.fromEntity(VideoCallEntity entity) {
    return VideoCallModel(
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

  static VideoCallStatus _statusFromJson(String value) {
    switch (value) {
      case 'ongoing':
        return VideoCallStatus.ongoing;
      case 'ended':
        return VideoCallStatus.ended;
      case 'missed':
        return VideoCallStatus.missed;
      default:
        return VideoCallStatus.ringing;
    }
  }

  static String _statusToJson(VideoCallStatus status) {
    switch (status) {
      case VideoCallStatus.ongoing:
        return 'ongoing';
      case VideoCallStatus.ended:
        return 'ended';
      case VideoCallStatus.missed:
        return 'missed';
      case VideoCallStatus.ringing:
        return 'ringing';
    }
  }
}
