import 'package:afiete/feature/articles/domain/entities/article_entities.dart';
import 'package:afiete/feature/booking_assiments/domain/values/consultation_fee.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';

class ArticleModel {
  final String id;
  final String title;
  final String content;
  final String summary;
  final DoctorEntity doctor;
  final DateTime createdAt;
  final int likesCount;
  final int dislikesCount;
  final bool isLikedByUser;
  final bool isDislikedByUser;
  final List<String> relatedConditions;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.doctor,
    required this.createdAt,
    required this.likesCount,
    required this.dislikesCount,
    required this.isLikedByUser,
    required this.isDislikedByUser,
    required this.relatedConditions,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      summary: json['summary'] ?? '',
      doctor: _doctorFromJson(json['doctor'] as Map<String, dynamic>? ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      likesCount: json['likesCount'] ?? 0,
      dislikesCount: json['dislikesCount'] ?? 0,
      isLikedByUser: json['isLikedByUser'] ?? false,
      isDislikedByUser: json['isDislikedByUser'] ?? false,
      relatedConditions: List<String>.from(json['relatedConditions'] ?? []),
    );
  }

  ArticleModel copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    DoctorEntity? doctor,
    DateTime? createdAt,
    int? likesCount,
    int? dislikesCount,
    bool? isLikedByUser,
    bool? isDislikedByUser,
    List<String>? relatedConditions,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      doctor: doctor ?? this.doctor,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      isLikedByUser: isLikedByUser ?? this.isLikedByUser,
      isDislikedByUser: isDislikedByUser ?? this.isDislikedByUser,
      relatedConditions: relatedConditions ?? this.relatedConditions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'doctor': {
        'id': doctor.id,
        'name': doctor.name,
        'specialization': doctor.specialization,
        'imageUrl': doctor.imageUrl,
      },
      'createdAt': createdAt.toIso8601String(),
      'likesCount': likesCount,
      'dislikesCount': dislikesCount,
      'isLikedByUser': isLikedByUser,
      'isDislikedByUser': isDislikedByUser,
      'relatedConditions': relatedConditions,
    };
  }

  ArticleEntity toEntity() {
    return ArticleEntity(
      id: id,
      title: title,
      content: content,
      summary: summary,
      doctor: doctor,
      createdAt: createdAt,
      likesCount: likesCount,
      dislikesCount: dislikesCount,
      isLikedByUser: isLikedByUser,
      isDislikedByUser: isDislikedByUser,
      relatedConditions: relatedConditions,
    );
  }

  static DoctorEntity _doctorFromJson(Map<String, dynamic> json) {
    return DoctorEntity(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Unknown Doctor').toString(),
      specialization: (json['specialization'] ?? json['specialty'] ?? 'General')
          .toString(),
      experience: (json['experience'] ?? '5+ years').toString(),
      rating: (json['rating'] ?? '4.8').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      isOnline: json['isOnline'] == true,
      ratingValue: (json['ratingValue'] is num)
          ? (json['ratingValue'] as num).toDouble()
          : 4.8,
      createdAt: DateTime.now(),
      availableTimes: const [],
      availableDurations: const [1, 2],
      availableSessionTypes: const ['video_call', 'voice_call', 'text_chat'],
      consultationFee: const ConsultationFee(
        textChat: 10,
        videoCall: 20,
        voiceCall: 15,
      ),
    );
  }
}
