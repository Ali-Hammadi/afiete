import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:dartz/dartz.dart';

class CreateAppointmentParams {
  final String doctorId;
  final String patientId;
  final String doctorName;
  final DateTime scheduledAt;
  final int durationSlots;
  final ConsultationFee consultationFee;
  final String sessionType;

  const CreateAppointmentParams({
    required this.doctorId,
    required this.patientId,
    required this.doctorName,
    required this.scheduledAt,
    required this.durationSlots,
    required this.consultationFee,
    required this.sessionType,
  });
}

class CreateAppointmentUseCase
    implements UseCase<AppointmentEntity, CreateAppointmentParams> {
  final AppointmentsRepository repository;

  const CreateAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    CreateAppointmentParams params,
  ) {
    return repository.createAppointment(
      doctorId: params.doctorId,
      patientId: params.patientId,
      doctorName: params.doctorName,
      scheduledAt: params.scheduledAt,
      durationSlots: params.durationSlots,
      consultationFee: params.consultationFee,
      sessionType: params.sessionType,
    );
  }
}
