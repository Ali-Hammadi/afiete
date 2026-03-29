import 'package:dartz/dartz.dart';
import '../error/failure.dart';

abstract class UseCase<DataType, Params> {
  Future<Either<Failure, DataType>> call(Params params);
}

class NoParams {}
