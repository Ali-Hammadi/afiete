import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class DeleteAccountParams {
  final String email;
  final String password;
  final String? correlationId;

  const DeleteAccountParams({
    required this.email,
    required this.password,
    this.correlationId,
  });
}

class DeleteAccountUseCase implements UseCase<void, DeleteAccountParams> {
  final AuthRepository repository;

  const DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    return await repository.deleteAccount(
      email: params.email,
      password: params.password,
      correlationId: params.correlationId,
    );
  }
}
