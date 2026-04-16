import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';
import 'package:afiete/feature/report/domain/usecases/submit_report_usecase.dart';
import 'package:afiete/feature/report/domain/usecases/get_report_history_usecase.dart';
import 'package:afiete/feature/report/domain/usecases/get_reports_by_type_usecase.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUseCase submitReportUseCase;
  final GetReportHistoryUseCase getReportHistoryUseCase;
  final GetReportsByTypeUseCase getReportsByTypeUseCase;

  ReportCubit({
    required this.submitReportUseCase,
    required this.getReportHistoryUseCase,
    required this.getReportsByTypeUseCase,
  }) : super(const ReportInitial());

  Future<void> submitReport({
    required String userId,
    required ReportType reportType,
    String? targetId,
    String? targetName,
    required ReportReason reason,
    required String description,
  }) async {
    emit(const ReportSubmitting());

    final result = await submitReportUseCase(
      SubmitReportParams(
        userId: userId,
        reportType: reportType,
        targetId: targetId,
        targetName: targetName,
        reason: reason,
        description: description,
      ),
    );

    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (report) => emit(ReportSubmitted(report)),
    );
  }

  Future<void> getReportHistory({required String userId}) async {
    emit(const ReportHistoryLoading());

    final result = await getReportHistoryUseCase(
      GetReportHistoryParams(userId: userId),
    );

    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (reports) => reports.isEmpty
          ? emit(const ReportHistoryEmpty())
          : emit(ReportHistoryLoaded(reports)),
    );
  }

  Future<void> getReportsByType({
    required String userId,
    required ReportType reportType,
  }) async {
    emit(const ReportsByTypeLoading());

    final result = await getReportsByTypeUseCase(
      GetReportsByTypeParams(userId: userId, reportType: reportType),
    );

    result.fold(
      (failure) => emit(ReportError(failure.errorMessage)),
      (reports) => emit(ReportsByTypeLoaded(reports, reportType)),
    );
  }

  void resetState() {
    emit(const ReportInitial());
  }
}
