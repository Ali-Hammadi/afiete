import 'package:equatable/equatable.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final String doctorName;
  final DateTime scheduledAt;
  final int durationSlots;
  final ConsultationFee consultationFee;
  final String sessionType;
  final String status;
  final bool requiresPayment;

  const AppointmentEntity({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.scheduledAt,
    required this.durationSlots,
    required this.consultationFee,
    required this.sessionType,
    required this.status,
    required this.requiresPayment,
  });

  DateTime get endAt => scheduledAt.add(Duration(minutes: durationSlots * 30));

  double get totalFee => consultationFee.getFeeBySType(sessionType);

  @override
  List<Object> get props => [
    id,
    doctorId,
    patientId,
    doctorName,
    scheduledAt,
    durationSlots,
    consultationFee,
    sessionType,
    status,
    requiresPayment,
  ];
}
