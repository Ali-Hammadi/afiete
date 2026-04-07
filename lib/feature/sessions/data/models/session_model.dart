import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';

class SessionModel extends SessionEntity {
  const SessionModel({
    required super.id,
    required super.doctorId,
    required super.doctorName,
    required super.doctorSpecialization,
    super.doctorImageUrl,
    required super.scheduledAt,
    required super.durationMinutes,
    required super.sessionType,
    required super.status,
    required super.isUpcoming,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final scheduledAt = DateTime.parse(json['scheduledAt'] as String);
    return SessionModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      doctorSpecialization: json['doctorSpecialization'] as String,
      doctorImageUrl: json['doctorImageUrl'] as String?,
      scheduledAt: scheduledAt,
      durationMinutes: json['durationMinutes'] as int,
      sessionType: json['sessionType'] as String,
      status: json['status'] as String,
      isUpcoming: scheduledAt.isAfter(DateTime.now()),
    );
  }

  factory SessionModel.fromEntity(SessionEntity entity) {
    return SessionModel(
      id: entity.id,
      doctorId: entity.doctorId,
      doctorName: entity.doctorName,
      doctorSpecialization: entity.doctorSpecialization,
      doctorImageUrl: entity.doctorImageUrl,
      scheduledAt: entity.scheduledAt,
      durationMinutes: entity.durationMinutes,
      sessionType: entity.sessionType,
      status: entity.status,
      isUpcoming: entity.isUpcoming,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialization': doctorSpecialization,
      'doctorImageUrl': doctorImageUrl,
      'scheduledAt': scheduledAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'sessionType': sessionType,
      'status': status,
    };
  }
}
