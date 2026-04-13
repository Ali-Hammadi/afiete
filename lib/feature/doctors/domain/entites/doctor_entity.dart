import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';

class DoctorEntity {
  final String id;
  final String name;
  final String specialization;
  final String experience;
  final String rating;
  final String imageUrl;
  final String description;
  final bool isOnline;
  final double ratingValue;
  final DateTime createdAt;
  final List<DateTime> availableTimes;
  final List<int> availableDurations;
  final List<String> availableSessionTypes;
  final ConsultationFee consultationFee;

  DoctorEntity({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.isOnline,
    required this.ratingValue,
    required this.createdAt,
    required this.availableTimes,
    this.availableDurations = const [1, 2],
    this.availableSessionTypes = const [
      'video_call',
      'voice_call',
      'text_chat',
    ],
    this.consultationFee = const ConsultationFee(
      textChat: 10,
      videoCall: 20,
      voiceCall: 15,
    ),
  });
}
