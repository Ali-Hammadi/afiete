import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/core/utils/logger.dart';
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
  final _log = loggerFor('LogoutUseCase');

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LogoutParams params) async {
    debugPrint('[LogoutUseCase] call() invoked');
    _log.info('logout_usecase:start', data: {
      'cid': params.correlationId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      debugPrint('[LogoutUseCase] Calling repository.logout()');
      _log.info('logout_usecase:calling_repository', data: {
        'cid': params.correlationId,
      });

      final result = await repository.logout(correlationId: params.correlationId);

      debugPrint('[LogoutUseCase] Repository logout result: ${result.runtimeType}');

      result.fold(
        (failure) {
          debugPrint('[LogoutUseCase] Logout failed: ${failure.errorMessage}');
          _log.error('logout_usecase:failed', data: {
            'cid': params.correlationId,
            'failure': failure.errorMessage,
            'failureType': failure.runtimeType.toString(),
          });
        },
        (_) {
          debugPrint('[LogoutUseCase] Logout succeeded');
          _log.info('logout_usecase:completed', data: {
            'cid': params.correlationId,
          });
        },
      );

      return result;
    } catch (e, st) {
      debugPrint('[LogoutUseCase] Exception: $e');
      _log.error('logout_usecase:exception', data: {
        'cid': params.correlationId,
        'error': e.toString(),
        'stackTrace': st.toString(),
      }, error: e, stackTrace: st);
      rethrow;
    }
  }
}
