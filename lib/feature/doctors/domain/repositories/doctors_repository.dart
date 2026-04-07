import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';

abstract class DoctorsRepository {
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors();
  Future<Either<Failure, List<DoctorEntity>>> getDoctorsBySpecialty(String specialty);
  Future<Either<Failure, DoctorEntity>> getDoctorById(String id);
}
