part of 'report_cubit.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {
  const ReportInitial();
}

// Submit Report States
class ReportSubmitting extends ReportState {
  const ReportSubmitting();
}

class ReportSubmitted extends ReportState {
  final ReportEntity report;

  const ReportSubmitted(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportError extends ReportState {
  final String message;

  const ReportError(this.message);

  @override
  List<Object?> get props => [message];
}

// History States
class ReportHistoryLoading extends ReportState {
  const ReportHistoryLoading();
}

class ReportHistoryLoaded extends ReportState {
  final List<ReportEntity> reports;

  const ReportHistoryLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class ReportHistoryEmpty extends ReportState {
  const ReportHistoryEmpty();
}

// Type-specific States
class ReportsByTypeLoading extends ReportState {
  const ReportsByTypeLoading();
}

class ReportsByTypeLoaded extends ReportState {
  final List<ReportEntity> reports;
  final ReportType reportType;

  const ReportsByTypeLoaded(this.reports, this.reportType);

  @override
  List<Object?> get props => [reports, reportType];
}
