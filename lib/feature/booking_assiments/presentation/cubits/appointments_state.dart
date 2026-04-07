part of 'appointments_cubit.dart';

abstract class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object> get props => [];
}

class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentEntity> appointments;
  final List<DoctorEntity>? doctors;

  const AppointmentsLoaded(this.appointments, {this.doctors = const []});

  @override
  List<Object> get props => [appointments, doctors ?? const <DoctorEntity>[]];
}

class AppointmentsError extends AppointmentsState {
  final String message;

  const AppointmentsError(this.message);

  @override
  List<Object> get props => [message];
}
