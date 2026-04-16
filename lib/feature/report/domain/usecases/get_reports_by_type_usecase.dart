import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/domain/repositories/report_repository.dart';

class GetReportsByTypeParams {
  final String userId;
  final ReportType reportType;

  const GetReportsByTypeParams({
    required this.userId,
    required this.reportType,
  });
}

class GetReportsByTypeUseCase
    implements UseCase<List<ReportEntity>, GetReportsByTypeParams> {
  final ReportRepository repository;

  const GetReportsByTypeUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReportEntity>>> call(
    GetReportsByTypeParams params,
  ) async {
    return await repository.getReportsByType(
      userId: params.userId,
      reportType: params.reportType,
    );
  }
}
