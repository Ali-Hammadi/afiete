import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/feeling/domain/entities/feeling_entry_entity.dart';
import 'package:afiete/feature/feeling/domain/repositories/feeling_repository.dart';
import 'package:dartz/dartz.dart';

class SaveFeelingParams {
  final FeelingType feeling;
  final int intensity;

  const SaveFeelingParams({required this.feeling, this.intensity = 3});
}

class SaveFeelingUseCase
    implements UseCase<FeelingEntryEntity, SaveFeelingParams> {
  final FeelingRepository repository;

  const SaveFeelingUseCase(this.repository);

  @override
  Future<Either<Failure, FeelingEntryEntity>> call(SaveFeelingParams params) {
    return repository.saveFeeling(
      feeling: params.feeling,
      intensity: params.intensity,
    );
  }
}

class GetCurrentFeelingUseCase implements UseCase<FeelingType?, NoParams> {
  final FeelingRepository repository;

  const GetCurrentFeelingUseCase(this.repository);

  @override
  Future<Either<Failure, FeelingType?>> call(NoParams params) {
    return repository.getCurrentFeeling();
  }
}

class GetFeelingHistoryParams {
  final int limit;

  const GetFeelingHistoryParams({this.limit = 30});
}

class GetFeelingHistoryUseCase
    implements UseCase<List<FeelingEntryEntity>, GetFeelingHistoryParams> {
  final FeelingRepository repository;

  const GetFeelingHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<FeelingEntryEntity>>> call(
    GetFeelingHistoryParams params,
  ) {
    return repository.getFeelingHistory(limit: params.limit);
  }
}
