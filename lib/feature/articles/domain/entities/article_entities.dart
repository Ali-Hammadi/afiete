import 'package:equatable/equatable.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';

class ArticleEntity extends Equatable {
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
  final List<String> relatedConditions; // List of diagnoses/conditions

  const ArticleEntity({
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

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    summary,
    doctor,
    createdAt,
    likesCount,
    dislikesCount,
    isLikedByUser,
    isDislikedByUser,
    relatedConditions,
  ];

  ArticleEntity copyWith({
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
    return ArticleEntity(
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
}
