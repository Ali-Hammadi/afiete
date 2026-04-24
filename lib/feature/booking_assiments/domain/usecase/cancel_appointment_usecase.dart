import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:dartz/dartz.dart';

class CancelAppointmentParams {
  final String appointmentId;

  const CancelAppointmentParams({required this.appointmentId});
}

class CancelAppointmentUseCase implements UseCase<void, CancelAppointmentParams> {
  final AppointmentsRepository repository;

  const CancelAppointmentUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelAppointmentParams params) {
    return repository.cancelAppointment(params.appointmentId);
  }
}
