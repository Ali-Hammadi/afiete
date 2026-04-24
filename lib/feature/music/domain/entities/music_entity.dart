import 'package:afiete/core/constants/feeling_type.dart';
import 'package:equatable/equatable.dart';

enum MusicTherapeuticGoal { calmDown, uplift, stabilize, focus, sleep }

enum MusicSourceType {
  bensound,
  freemusicarchive,
  pixabay,
  incompetech,
  custom,
}

class MusicEntity extends Equatable {
  final String id;
  final String title;
  final String artist;
  final String? description;
  final String audioUrl;
  final String? previewUrl;
  final String? coverUrl;
  final String sourceName;
  final String sourceUrl;
  final MusicSourceType sourceType;
  final List<FeelingType> supportedFeelings;
  final List<MusicTherapeuticGoal> therapeuticGoals;
  final bool isInstrumental;
  final int durationSeconds;
  final int tempoBpm;
  final int noveltyScore;
  final String licenseText;
  final String? attributionText;

  const MusicEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.sourceName,
    required this.sourceUrl,
    required this.sourceType,
    required this.supportedFeelings,
    required this.therapeuticGoals,
    required this.isInstrumental,
    required this.durationSeconds,
    required this.tempoBpm,
    required this.noveltyScore,
    required this.licenseText,
    this.description,
    this.previewUrl,
    this.coverUrl,
    this.attributionText,
  });

  MusicEntity copyWith({
    String? id,
    String? title,
    String? artist,
    String? description,
    String? audioUrl,
    String? previewUrl,
    String? coverUrl,
    String? sourceName,
    String? sourceUrl,
    MusicSourceType? sourceType,
    List<FeelingType>? supportedFeelings,
    List<MusicTherapeuticGoal>? therapeuticGoals,
    bool? isInstrumental,
    int? durationSeconds,
    int? tempoBpm,
    int? noveltyScore,
    String? licenseText,
    String? attributionText,
  }) {
    return MusicEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      description: description ?? this.description,
      audioUrl: audioUrl ?? this.audioUrl,
      previewUrl: previewUrl ?? this.previewUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      sourceName: sourceName ?? this.sourceName,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      sourceType: sourceType ?? this.sourceType,
      supportedFeelings: supportedFeelings ?? this.supportedFeelings,
      therapeuticGoals: therapeuticGoals ?? this.therapeuticGoals,
      isInstrumental: isInstrumental ?? this.isInstrumental,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      tempoBpm: tempoBpm ?? this.tempoBpm,
      noveltyScore: noveltyScore ?? this.noveltyScore,
      licenseText: licenseText ?? this.licenseText,
      attributionText: attributionText ?? this.attributionText,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    artist,
    description,
    audioUrl,
    previewUrl,
    coverUrl,
    sourceName,
    sourceUrl,
    sourceType,
    supportedFeelings,
    therapeuticGoals,
    isInstrumental,
    durationSeconds,
    tempoBpm,
    noveltyScore,
    licenseText,
    attributionText,
  ];
}
