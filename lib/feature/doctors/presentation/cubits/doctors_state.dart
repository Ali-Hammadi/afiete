part of 'doctors_cubit.dart';

abstract class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object?> get props => [];
}

class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

class DoctorsLoaded extends DoctorsState {
  final List<DoctorEntity> doctors;
  final String? selectedSpecialty;

  const DoctorsLoaded(this.doctors, this.selectedSpecialty);

  @override
  List<Object?> get props => [doctors, selectedSpecialty];
}

class DoctorsError extends DoctorsState {
  final String message;

  const DoctorsError(this.message);

  @override
  List<Object> get props => [message];
}

// Single doctor states
class DoctorLoading extends DoctorsState {
  const DoctorLoading();
}

class DoctorLoaded extends DoctorsState {
  final DoctorEntity doctor;

  const DoctorLoaded(this.doctor);

  @override
  List<Object> get props => [doctor];
}

class DoctorError extends DoctorsState {
  final String message;

  const DoctorError(this.message);

  @override
  List<Object> get props => [message];
}
