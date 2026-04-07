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
  });
}
