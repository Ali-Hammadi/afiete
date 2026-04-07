import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String sessionId;
  final int rating;
  final String comment;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.sessionId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, sessionId, rating, comment, createdAt];
}
