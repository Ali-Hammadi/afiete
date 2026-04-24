import 'package:afiete/core/constants/feeling_type.dart';
import 'package:equatable/equatable.dart';

class FeelingEntryEntity extends Equatable {
  final String id;
  final FeelingType feeling;
  final int intensity;
  final DateTime createdAt;

  const FeelingEntryEntity({
    required this.id,
    required this.feeling,
    required this.intensity,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, feeling, intensity, createdAt];
}
