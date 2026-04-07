import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/booking_assiments/domain/entities/appointment_entity.dart';
import 'package:afiete/feature/booking_assiments/domain/repositories/appointments_repository.dart';
import 'package:dartz/dartz.dart';

class GetAppointmentsUseCase
    implements UseCase<List<AppointmentEntity>, NoParams> {
  final AppointmentsRepository repository;

  const GetAppointmentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AppointmentEntity>>> call(NoParams params) {
    return repository.getAppointments();
  }
}
