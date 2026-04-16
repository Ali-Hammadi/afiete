import 'package:equatable/equatable.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';

class DoctorModel extends Equatable {
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

  const DoctorModel({
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
    required this.availableDurations,
    required this.availableSessionTypes,
    required this.consultationFee,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final consultationFee = json['consultationFee'] as Map<String, dynamic>?;

    return DoctorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      experience: json['experience'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      description: json['description'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      ratingValue: (json['ratingValue'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      availableTimes: json['availableTimes'] != null
          ? List<DateTime>.from(
              (json['availableTimes'] as List).map(
                (e) => DateTime.parse(e as String),
              ),
            )
          : [],
      availableDurations: json['availableDurations'] != null
          ? List<int>.from(
              (json['availableDurations'] as List).map(
                (e) => e is int ? e : int.tryParse(e.toString()) ?? 1,
              ),
            )
          : const [1, 2],
      availableSessionTypes: json['availableSessionTypes'] != null
          ? List<String>.from(
              (json['availableSessionTypes'] as List).map((e) => '$e'),
            )
          : const ['video_call', 'voice_call', 'text_chat'],
      consultationFee: consultationFee != null
          ? ConsultationFee(
              textChat:
                  ((consultationFee['textChat'] ?? consultationFee['text_chat'])
                              as num? ??
                          10)
                      .toDouble(),
              videoCall:
                  ((consultationFee['videoCall'] ??
                                  consultationFee['video_call'])
                              as num? ??
                          20)
                      .toDouble(),
              voiceCall:
                  ((consultationFee['voiceCall'] ??
                                  consultationFee['voice_call'])
                              as num? ??
                          15)
                      .toDouble(),
            )
          : const ConsultationFee(textChat: 10, videoCall: 20, voiceCall: 15),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialization': specialization,
    'experience': experience,
    'rating': rating,
    'imageUrl': imageUrl,
    'description': description,
    'isOnline': isOnline,
    'ratingValue': ratingValue,
    'createdAt': createdAt.toIso8601String(),
    'availableTimes': availableTimes.map((e) => e.toIso8601String()).toList(),
    'availableDurations': availableDurations,
    'availableSessionTypes': availableSessionTypes,
    'consultationFee': {
      'textChat': consultationFee.textChat,
      'videoCall': consultationFee.videoCall,
      'voiceCall': consultationFee.voiceCall,
    },
  };

  DoctorEntity toEntity() => DoctorEntity(
    id: id,
    name: name,
    specialization: specialization,
    experience: experience,
    rating: rating,
    imageUrl: imageUrl,
    description: description,
    isOnline: isOnline,
    ratingValue: ratingValue,
    createdAt: createdAt,
    availableTimes: availableTimes,
    availableDurations: availableDurations,
    availableSessionTypes: availableSessionTypes,
    consultationFee: consultationFee,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    specialization,
    experience,
    rating,
    imageUrl,
    description,
    isOnline,
    ratingValue,
    createdAt,
    availableTimes,
    availableDurations,
    availableSessionTypes,
    consultationFee,
  ];
}
