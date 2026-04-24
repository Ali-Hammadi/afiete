import 'package:afiete/core/constants/feeling_type.dart';

import 'package:equatable/equatable.dart';

import 'music_entity.dart';

class MusicRecommendationProfileEntity extends Equatable {
  final FeelingType feelingType;
  final MusicTherapeuticGoal therapeuticGoal;
  final List<MusicSourceType> preferredSourceTypes;
  final bool preferInstrumental;
  final int minTempoBpm;
  final int maxTempoBpm;
  final int minDurationSeconds;
  final int maxDurationSeconds;
  final int rotationWindowDays;
  final int limit;

  const MusicRecommendationProfileEntity({
    required this.feelingType,
    required this.therapeuticGoal,
    required this.preferredSourceTypes,
    required this.preferInstrumental,
    required this.minTempoBpm,
    required this.maxTempoBpm,
    required this.minDurationSeconds,
    required this.maxDurationSeconds,
    required this.rotationWindowDays,
    required this.limit,
  });

  @override
  List<Object?> get props => [
    feelingType,
    therapeuticGoal,
    preferredSourceTypes,
    preferInstrumental,
    minTempoBpm,
    maxTempoBpm,
    minDurationSeconds,
    maxDurationSeconds,
    rotationWindowDays,
    limit,
  ];
}
