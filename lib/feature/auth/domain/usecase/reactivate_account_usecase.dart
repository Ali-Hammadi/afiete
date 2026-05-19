import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ReactivateAccountParams {
  final String email;
  final String password;
  final String? correlationId;

  const ReactivateAccountParams({
    required this.email,
    required this.password,
    this.correlationId,
  });
}

class ReactivateAccountUseCase
    implements UseCase<void, ReactivateAccountParams> {
  final AuthRepository repository;

  const ReactivateAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ReactivateAccountParams params) async {
    return repository.reactivateAccount(
      email: params.email,
      password: params.password,
      correlationId: params.correlationId,
    );
  }
}