import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class SignupParams {
  final String nickname;
  final String email;
  final String password;

  const SignupParams({
    required this.nickname,
    required this.email,
    required this.password,
  });
}

class SignupUseCase implements UseCase<UserAuthEntity, SignupParams> {
  final AuthRepository repository;

  const SignupUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(SignupParams params) async {
    return await repository.signup(
      params.nickname,
      params.email,
      params.password,
    );
  }
}
