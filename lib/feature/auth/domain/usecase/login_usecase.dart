import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<UserAuthEntity, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}
