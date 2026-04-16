import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/report/data/datasources/report_remote_datasource.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/domain/repositories/report_repository.dart';
import 'package:dio/dio.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReportEntity>> submitReport({
    required String userId,
    required ReportType reportType,
    String? targetId,
    String? targetName,
    required ReportReason reason,
    required String description,
  }) async {
    try {
      final reportModel = await remoteDataSource.submitReport(
        userId: userId,
        reportType: reportType.name,
        targetId: targetId,
        targetName: targetName,
        reason: reason.name,
        description: description,
      );
      return Right(reportModel.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReportHistory({
    required String userId,
  }) async {
    try {
      final reports = await remoteDataSource.getReportHistory(userId: userId);
      return Right(reports.map((report) => report.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> getReportsByType({
    required String userId,
    required ReportType reportType,
  }) async {
    try {
      final reports = await remoteDataSource.getReportsByType(
        userId: userId,
        reportType: reportType.name,
      );
      return Right(reports.map((report) => report.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
