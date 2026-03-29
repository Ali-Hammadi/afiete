import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class DeleteAccountParams {
  final String email;
  final String password;

  const DeleteAccountParams({required this.email, required this.password});
}

class DeleteAccountUseCase
    implements UseCase<UserAuthEntity, DeleteAccountParams> {
  final AuthRepository repository;

  const DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(
    DeleteAccountParams params,
  ) async {
    return await repository.deleteAccount(params.email, params.password);
  }
}
