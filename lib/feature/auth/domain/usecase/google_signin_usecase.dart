import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class GoogleSignInParams {
  const GoogleSignInParams();
}

class GoogleSignInUseCase implements UseCase<UserAuthEntity, GoogleSignInParams> {
  final AuthRepository repository;

  const GoogleSignInUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(GoogleSignInParams params) async {
    return await repository.googleSignIn();
  }
}
