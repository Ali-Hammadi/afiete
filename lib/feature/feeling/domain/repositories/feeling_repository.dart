import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/feeling/domain/entities/feeling_entry_entity.dart';
import 'package:dartz/dartz.dart';

abstract class FeelingRepository {
  Future<Either<Failure, FeelingType?>> getCurrentFeeling();

  Future<Either<Failure, FeelingEntryEntity>> saveFeeling({
    required FeelingType feeling,
    int intensity,
  });

  Future<Either<Failure, List<FeelingEntryEntity>>> getFeelingHistory({
    int limit,
  });
}
