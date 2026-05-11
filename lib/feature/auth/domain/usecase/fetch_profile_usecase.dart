import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class FetchProfileParams {
  final String? correlationId;

  const FetchProfileParams({this.correlationId});
}

class FetchProfileUseCase
    implements UseCase<UserAuthEntity, FetchProfileParams> {
  final AuthRepository repository;

  const FetchProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(
    FetchProfileParams params,
  ) async {
    return repository.fetchProfile(correlationId: params.correlationId);
  }
}
