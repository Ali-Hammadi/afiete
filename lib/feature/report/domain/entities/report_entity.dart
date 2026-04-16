import 'package:equatable/equatable.dart';

enum ReportType { doctor, session, app }

enum ReportReason {
  unprofessional('Unprofessional behavior'),
  harassment('Harassment'),
  inappropriateContent('Inappropriate content'),
  missingAppointment('Missing appointments'),
  appBug('App bug or issue'),
  other('Other');

  final String label;
  const ReportReason(this.label);
}

enum ReportStatus { pending, reviewed, resolved }

class ReportEntity extends Equatable {
  final String id;
  final String userId;
  final ReportType reportType;
  final String? targetId; // doctorId or sessionId
  final String? targetName;
  final ReportReason reason;
  final String description;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const ReportEntity({
    required this.id,
    required this.userId,
    required this.reportType,
    this.targetId,
    this.targetName,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    reportType,
    targetId,
    targetName,
    reason,
    description,
    status,
    createdAt,
    resolvedAt,
  ];
}
