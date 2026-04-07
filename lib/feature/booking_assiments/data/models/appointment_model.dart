import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.doctorId,
    required super.patientId,
    required super.doctorName,
    required super.scheduledAt,
    required super.durationSlots,
    required super.consultationFee,
    required super.sessionType,
    required super.status,
    required super.requiresPayment,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String? ?? 'unknown_doctor',
      patientId: json['patientId'] as String? ?? 'unknown_patient',
      doctorName: json['doctorName'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      durationSlots: json['durationSlots'] as int,
      consultationFee: ConsultationFee(
        textChat: (json['consultationFee']['textChat'] as num).toDouble(),
        videoCall: (json['consultationFee']['videoCall'] as num).toDouble(),
        voiceCall: (json['consultationFee']['voiceCall'] as num).toDouble(),
      ),
      sessionType: json['sessionType'] as String,
      status: json['status'] as String,
      requiresPayment: json['requiresPayment'] as bool,
    );
  }

  factory AppointmentModel.fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      doctorId: entity.doctorId,
      patientId: entity.patientId,
      doctorName: entity.doctorName,
      scheduledAt: entity.scheduledAt,
      durationSlots: entity.durationSlots,
      consultationFee: entity.consultationFee,
      sessionType: entity.sessionType,
      status: entity.status,
      requiresPayment: entity.requiresPayment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'status': status,
      'requiresPayment': requiresPayment,
    };
  }
}
