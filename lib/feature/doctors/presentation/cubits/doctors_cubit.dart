import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/domain/usecase/get_doctors_usecase.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  final GetAllDoctorsUseCase getAllDoctorsUseCase;
  final GetDoctorsBySpecialtyUseCase getDoctorsBySpecialtyUseCase;
  final GetDoctorByIdUseCase getDoctorByIdUseCase;

  DoctorsCubit(
    this.getAllDoctorsUseCase,
    this.getDoctorsBySpecialtyUseCase,
    this.getDoctorByIdUseCase,
  ) : super(const DoctorsInitial());

  Future<void> loadAllDoctors() async {
    emit(const DoctorsLoading());
    final result = await getAllDoctorsUseCase(NoParams());
    result.fold(
      (failure) => emit(DoctorsError(failure.errorMessage)),
      (doctors) => emit(DoctorsLoaded(doctors, null)),
    );
  }

  Future<void> loadDoctorsBySpecialty(String specialty) async {
    emit(const DoctorsLoading());
    final result = await getDoctorsBySpecialtyUseCase(
      GetDoctorsBySpecialtyParams(specialty: specialty),
    );
    result.fold(
      (failure) => emit(DoctorsError(failure.errorMessage)),
      (doctors) => emit(DoctorsLoaded(doctors, specialty)),
    );
  }

  Future<void> loadDoctorById(String id) async {
    emit(const DoctorLoading());
    final result = await getDoctorByIdUseCase(
      GetDoctorByIdParams(id: id),
    );
    result.fold(
      (failure) => emit(DoctorError(failure.errorMessage)),
      (doctor) => emit(DoctorLoaded(doctor)),
    );
  }
}
