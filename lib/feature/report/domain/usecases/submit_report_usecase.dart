import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/domain/repositories/report_repository.dart';

class SubmitReportParams {
  final String userId;
  final ReportType reportType;
  final String? targetId;
  final String? targetName;
  final ReportReason reason;
  final String description;

  const SubmitReportParams({
    required this.userId,
    required this.reportType,
    this.targetId,
    this.targetName,
    required this.reason,
    required this.description,
  });
}

class SubmitReportUseCase implements UseCase<ReportEntity, SubmitReportParams> {
  final ReportRepository repository;

  const SubmitReportUseCase(this.repository);

  @override
  Future<Either<Failure, ReportEntity>> call(SubmitReportParams params) async {
    return await repository.submitReport(
      userId: params.userId,
      reportType: params.reportType,
      targetId: params.targetId,
      targetName: params.targetName,
      reason: params.reason,
      description: params.description,
    );
  }
}
