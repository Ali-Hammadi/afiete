import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class FetchProfileUseCase implements UseCase<UserAuthEntity, NoParams> {
  final AuthRepository repository;

  const FetchProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(NoParams params) async {
    final cachedUser = await repository.getCachedSession();
    if (cachedUser == null) {
      return Left(ServerFailure('No cached auth session found.'));
    }
    return Right(cachedUser);
  }
}
