import 'package:equatable/equatable.dart';

enum VideoCallStatus { ringing, ongoing, ended, missed }

class VideoCallEntity extends Equatable {
  final String id;
  final String doctorId;
  final String patientId;
  final String sessionId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final VideoCallStatus status;

  const VideoCallEntity({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.sessionId,
    required this.startedAt,
    required this.endedAt,
    required this.status,
  });

  int get durationInSeconds {
    if (endedAt == null) {
      return 0;
    }
    return endedAt!.difference(startedAt).inSeconds;
  }

  @override
  List<Object?> get props => [
    id,
    doctorId,
    patientId,
    sessionId,
    startedAt,
    endedAt,
    status,
  ];
}
