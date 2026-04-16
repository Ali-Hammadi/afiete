import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProfileInfoParams {
  final String userId;
  final String name;
  final DateTime birthDate;
  final String gender;
  final String phoneNumber;

  const UpdateProfileInfoParams({
    required this.userId,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.phoneNumber,
  });
}

class UpdateProfileInfoUseCase
    implements UseCase<UserAuthEntity, UpdateProfileInfoParams> {
  final AuthRepository repository;

  const UpdateProfileInfoUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(UpdateProfileInfoParams params) {
    return repository.updateProfileInfo(
      userId: params.userId,
      name: params.name,
      birthDate: params.birthDate,
      gender: params.gender,
      phoneNumber: params.phoneNumber,
    );
  }
}
