import 'package:equatable/equatable.dart';

class SessionEntity extends Equatable {
  final String id;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialization;
  final String? doctorImageUrl;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String sessionType;
  final String status;
  final bool isUpcoming;

  const SessionEntity({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialization,
    this.doctorImageUrl,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.sessionType,
    required this.status,
    required this.isUpcoming,
  });

  DateTime get endAt => scheduledAt.add(Duration(minutes: durationMinutes));

  String get timeRange {
    final start = '${scheduledAt.hour}:${scheduledAt.minute.toString().padLeft(2, '0')}';
    final end = '${endAt.hour}:${endAt.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  @override
  List<Object?> get props => [
    id,
    doctorId,
    doctorName,
    doctorSpecialization,
    doctorImageUrl,
    scheduledAt,
    durationMinutes,
    sessionType,
    status,
    isUpcoming,
  ];
}
