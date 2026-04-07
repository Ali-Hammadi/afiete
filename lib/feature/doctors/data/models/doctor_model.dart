import 'package:equatable/equatable.dart';
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
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
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
              (json['availableTimes'] as List)
                  .map((e) => DateTime.parse(e as String)),
            )
          : [],
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
      ];
}
