import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class LogoutParams {
  final String? correlationId;

  const LogoutParams({this.correlationId});
}

/// Usecase for logout.
/// No parameters needed; uses current authenticated session (token from header).
/// Returns void on success.
class LogoutUseCase implements UseCase<void, LogoutParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LogoutParams params) async {
    return await repository.logout(correlationId: params.correlationId);
  }
}
