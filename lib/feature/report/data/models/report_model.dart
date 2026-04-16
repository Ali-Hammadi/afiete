import 'package:equatable/equatable.dart';
import 'package:afiete/feature/report/domain/entities/report_entity.dart';

class ReportModel extends Equatable {
  final String id;
  final String userId;
  final String reportType;
  final String? targetId;
  final String? targetName;
  final String reason;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const ReportModel({
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

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt'] ?? json['created_at'];
    final resolvedAtRaw = json['resolvedAt'] ?? json['resolved_at'];

    return ReportModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      reportType: (json['reportType'] ?? json['report_type'] ?? 'app')
          .toString(),
      targetId: (json['targetId'] ?? json['target_id'])?.toString(),
      targetName: (json['targetName'] ?? json['target_name'])?.toString(),
      reason: (json['reason'] ?? 'other').toString(),
      description: (json['description'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      createdAt: createdAtRaw != null
          ? DateTime.parse(createdAtRaw.toString())
          : DateTime.now(),
      resolvedAt: resolvedAtRaw != null
          ? DateTime.parse(resolvedAtRaw.toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'reportType': reportType,
      'targetId': targetId,
      'targetName': targetName,
      'reason': reason,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'resolvedAt': resolvedAt?.toIso8601String(),
    };
  }

  ReportEntity toEntity() {
    return ReportEntity(
      id: id,
      userId: userId,
      reportType: ReportType.values.firstWhere(
        (e) => e.name == reportType,
        orElse: () => ReportType.app,
      ),
      targetId: targetId,
      targetName: targetName,
      reason: ReportReason.values.firstWhere(
        (e) => e.name == reason,
        orElse: () => ReportReason.other,
      ),
      description: description,
      status: ReportStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => ReportStatus.pending,
      ),
      createdAt: createdAt,
      resolvedAt: resolvedAt,
    );
  }

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
