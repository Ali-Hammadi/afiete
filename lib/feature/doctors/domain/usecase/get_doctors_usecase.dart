import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/domain/repositories/doctors_repository.dart';

class GetAllDoctorsUseCase implements UseCase<List<DoctorEntity>, NoParams> {
  final DoctorsRepository repository;

  const GetAllDoctorsUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(NoParams params) {
    return repository.getAllDoctors();
  }
}

class GetDoctorsBySpecialtyParams {
  final String specialty;

  const GetDoctorsBySpecialtyParams({required this.specialty});
}

class GetDoctorsBySpecialtyUseCase
    implements UseCase<List<DoctorEntity>, GetDoctorsBySpecialtyParams> {
  final DoctorsRepository repository;

  const GetDoctorsBySpecialtyUseCase(this.repository);

  @override
  Future<Either<Failure, List<DoctorEntity>>> call(
    GetDoctorsBySpecialtyParams params,
  ) {
    return repository.getDoctorsBySpecialty(params.specialty);
  }
}

class GetDoctorByIdParams {
  final String id;

  const GetDoctorByIdParams({required this.id});
}

class GetDoctorByIdUseCase implements UseCase<DoctorEntity, GetDoctorByIdParams> {
  final DoctorsRepository repository;

  const GetDoctorByIdUseCase(this.repository);

  @override
  Future<Either<Failure, DoctorEntity>> call(GetDoctorByIdParams params) {
    return repository.getDoctorById(params.id);
  }
}
