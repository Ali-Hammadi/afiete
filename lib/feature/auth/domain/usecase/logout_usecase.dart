import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class LogoutParams {
  final String email;
  final String password;

  const LogoutParams({required this.email, required this.password});
}

class LogoutUseCase implements UseCase<UserAuthEntity, LogoutParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(LogoutParams params) async {
    return await repository.logout(params.email, params.password);
  }
}
