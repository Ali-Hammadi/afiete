import 'package:equatable/equatable.dart';
import 'package:afiete/core/constants/settings_strings.dart';

enum ReportType { doctor, session, app }

enum ReportReason {
  unprofessional('unprofessional'),
  harassment('harassment'),
  inappropriateContent('inappropriateContent'),
  missingAppointment('missingAppointment'),
  appBug('appBug'),
  crashOrFreeze('crashOrFreeze'),
  paymentIssue('paymentIssue'),
  other('other');

  final String key;
  const ReportReason(this.key);

  String get localizedLabel {
    switch (this) {
      case ReportReason.unprofessional:
        return SettingsStrings.unprofessionalBehavior;
      case ReportReason.harassment:
        return SettingsStrings.harassment;
      case ReportReason.inappropriateContent:
        return SettingsStrings.inappropriateContent;
      case ReportReason.missingAppointment:
        return SettingsStrings.missingAppointments;
      case ReportReason.appBug:
        return SettingsStrings.appBugOrIssue;
      case ReportReason.crashOrFreeze:
        return SettingsStrings.appCrashesOrFreezes;
      case ReportReason.paymentIssue:
        return SettingsStrings.paymentOrTransactionIssue;
      case ReportReason.other:
        return SettingsStrings.otherIssue;
    }
  }
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
