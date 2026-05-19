import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/core/utils/logger.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class DeleteAccountParams {
  final String password;
  final String? correlationId;

  const DeleteAccountParams({required this.password, this.correlationId});
}

class DeleteAccountUseCase implements UseCase<void, DeleteAccountParams> {
  final AuthRepository repository;
  final _log = loggerFor('DeleteAccountUseCase');

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAccountParams params) async {
    debugPrint('[DeleteAccountUseCase] call() invoked');
    _log.warn('delete_account_usecase:start', data: {
      'cid': params.correlationId,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      debugPrint('[DeleteAccountUseCase] Calling repository.deleteAccount()');
      _log.warn('delete_account_usecase:calling_repository', data: {
        'cid': params.correlationId,
      });

      final result = await repository.deleteAccount(
        password: params.password,
        correlationId: params.correlationId,
      );

      debugPrint(
        '[DeleteAccountUseCase] Repository deleteAccount result: ${result.runtimeType}',
      );

      result.fold(
        (failure) {
          debugPrint(
            '[DeleteAccountUseCase] Delete account failed: ${failure.errorMessage}',
          );
          _log.error('delete_account_usecase:failed', data: {
            'cid': params.correlationId,
            'failure': failure.errorMessage,
            'failureType': failure.runtimeType.toString(),
          });
        },
        (_) {
          debugPrint('[DeleteAccountUseCase] Delete account succeeded');
          _log.info('delete_account_usecase:completed', data: {
            'cid': params.correlationId,
          });
        },
      );

      return result;
    } catch (e, st) {
      debugPrint('[DeleteAccountUseCase] Exception: $e');
      _log.error('delete_account_usecase:exception', data: {
        'cid': params.correlationId,
        'error': e.toString(),
        'stackTrace': st.toString(),
      }, error: e, stackTrace: st);
      rethrow;
    }
  }
}
