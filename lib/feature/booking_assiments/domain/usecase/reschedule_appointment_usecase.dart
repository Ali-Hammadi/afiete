import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:dartz/dartz.dart';

class RescheduleAppointmentParams {
  final String appointmentId;
  final DateTime newScheduledAt;

  const RescheduleAppointmentParams({
    required this.appointmentId,
    required this.newScheduledAt,
  });
}

class RescheduleAppointmentUseCase
    implements UseCase<AppointmentEntity, RescheduleAppointmentParams> {
  final AppointmentsRepository repository;

  const RescheduleAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, AppointmentEntity>> call(
    RescheduleAppointmentParams params,
  ) {
    return repository.rescheduleAppointment(
      appointmentId: params.appointmentId,
      newScheduledAt: params.newScheduledAt,
    );
  }
}
