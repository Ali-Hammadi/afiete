import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:dartz/dartz.dart';

abstract class AppointmentsRepository {
  Future<Either<Failure, List<AppointmentEntity>>> getAppointments();

  Future<Either<Failure, AppointmentEntity>> createAppointment({
    required String doctorId,
    required String patientId,
    required String doctorName,
    required DateTime scheduledAt,
    required int durationSlots,
    required ConsultationFee consultationFee,
    required String sessionType,
  });

  Future<Either<Failure, void>> cancelAppointment(String appointmentId);

  Future<Either<Failure, AppointmentEntity>> rescheduleAppointment({
    required String appointmentId,
    required DateTime newScheduledAt,
  });
}
