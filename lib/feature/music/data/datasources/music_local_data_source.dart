import 'dart:math';

import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/music/domain/entities/music_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MusicLocalDataSource {
  Future<FeelingType?> getLastSelectedFeeling();

  Future<void> saveLastSelectedFeeling(FeelingType feeling);

  Future<List<MusicEntity>> getRecommendedTracks({
    required FeelingType feeling,
    int limit,
    String? excludeTrackId,
  });

  Future<List<MusicEntity>> getTracksByGoal(
    MusicTherapeuticGoal goal, {
    int limit,
  });

  Future<List<BreathingExerciseEntity>> getBreathingExercises();

  Future<MusicEntity?> getTrackById(String id);
}

class MusicLocalDataSourceImpl implements MusicLocalDataSource {
  static const String _lastFeelingKey = 'music_last_selected_feeling';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  static final List<MusicEntity> _musicCatalog = [
    MusicEntity(
      id: 'music_01',
      title: 'Cozy Coffeehouse',
      artist: 'Lunar Years',
      description: 'Warm, calming background music for gentle regulation.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [
        FeelingType.neutral,
        FeelingType.anxious,
        FeelingType.sad,
      ],
      therapeuticGoals: [
        MusicTherapeuticGoal.calmDown,
        MusicTherapeuticGoal.stabilize,
        MusicTherapeuticGoal.sleep,
      ],
      isInstrumental: true,
      durationSeconds: 180,
      tempoBpm: 72,
      noveltyScore: 8,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_02',
      title: 'Small Joys',
      artist: 'Aventure',
      description: 'Gentle uplifting music to help restore positive affect.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [FeelingType.happy, FeelingType.neutral],
      therapeuticGoals: [
        MusicTherapeuticGoal.uplift,
        MusicTherapeuticGoal.stabilize,
      ],
      isInstrumental: true,
      durationSeconds: 165,
      tempoBpm: 88,
      noveltyScore: 9,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_03',
      title: 'Long Night',
      artist: 'Aventure',
      description: 'Soft piano and calm textures for down-regulation.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [
        FeelingType.sad,
        FeelingType.anxious,
        FeelingType.neutral,
      ],
      therapeuticGoals: [
        MusicTherapeuticGoal.calmDown,
        MusicTherapeuticGoal.sleep,
      ],
      isInstrumental: true,
      durationSeconds: 210,
      tempoBpm: 66,
      noveltyScore: 10,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_04',
      title: 'Morning Coffee',
      artist: 'Vital',
      description: 'Light positive background track for steady focus.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [FeelingType.happy, FeelingType.neutral],
      therapeuticGoals: [
        MusicTherapeuticGoal.focus,
        MusicTherapeuticGoal.uplift,
      ],
      isInstrumental: true,
      durationSeconds: 195,
      tempoBpm: 84,
      noveltyScore: 7,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_05',
      title: 'Sunlit Depths',
      artist: 'Sound EGO',
      description:
          'Deep chillout textures for anxiety and emotional softening.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [
        FeelingType.anxious,
        FeelingType.sad,
        FeelingType.neutral,
      ],
      therapeuticGoals: [
        MusicTherapeuticGoal.calmDown,
        MusicTherapeuticGoal.stabilize,
      ],
      isInstrumental: true,
      durationSeconds: 200,
      tempoBpm: 70,
      noveltyScore: 8,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_06',
      title: 'Aftermath',
      artist: 'Evert Zeevalkink',
      description: 'Calm sad piano suitable for emotionally heavy moments.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [FeelingType.sad, FeelingType.neutral],
      therapeuticGoals: [
        MusicTherapeuticGoal.calmDown,
        MusicTherapeuticGoal.sleep,
      ],
      isInstrumental: true,
      durationSeconds: 240,
      tempoBpm: 60,
      noveltyScore: 9,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_07',
      title: 'Silent Waves',
      artist: 'Nick Petrov',
      description: 'Positive chill for restoring calm without heaviness.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [
        FeelingType.neutral,
        FeelingType.happy,
        FeelingType.anxious,
      ],
      therapeuticGoals: [
        MusicTherapeuticGoal.stabilize,
        MusicTherapeuticGoal.focus,
      ],
      isInstrumental: true,
      durationSeconds: 175,
      tempoBpm: 78,
      noveltyScore: 6,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
    MusicEntity(
      id: 'music_08',
      title: 'The Light Between Us',
      artist: 'Shaydow',
      description: 'Soft piano for controlled breathing and recovery.',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
      sourceName: 'SoundHelix',
      sourceUrl: 'https://www.soundhelix.com/audio-examples',
      sourceType: MusicSourceType.custom,
      supportedFeelings: [
        FeelingType.anxious,
        FeelingType.sad,
        FeelingType.neutral,
      ],
      therapeuticGoals: [
        MusicTherapeuticGoal.calmDown,
        MusicTherapeuticGoal.sleep,
      ],
      isInstrumental: true,
      durationSeconds: 230,
      tempoBpm: 64,
      noveltyScore: 10,
      licenseText: 'Streamable demo audio from SoundHelix examples.',
      attributionText: 'Audio courtesy of SoundHelix examples',
    ),
  ];

  static final List<BreathingExerciseEntity> _breathingCatalog = [
    BreathingExerciseEntity(
      id: 'breath_01',
      title: 'Box Breathing',
      description: 'Used in stress control and focus training.',
      type: BreathingExerciseType.boxBreathing,
      durationMinutes: 5,
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      restSeconds: 4,
      steps: [
        'Inhale for 4 seconds',
        'Hold for 4 seconds',
        'Exhale for 4 seconds',
        'Hold for 4 seconds',
      ],
      recommendedFor: 'Stress, focus, and emotional reset',
    ),
    BreathingExerciseEntity(
      id: 'breath_02',
      title: '4-7-8 Breathing',
      description: 'Common relaxation technique used for anxiety and sleep.',
      type: BreathingExerciseType.fourSevenEight,
      durationMinutes: 4,
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
      restSeconds: 0,
      steps: [
        'Inhale for 4 seconds',
        'Hold for 7 seconds',
        'Exhale for 8 seconds',
      ],
      recommendedFor: 'Anxiety, insomnia, and pre-sleep calming',
    ),
    BreathingExerciseEntity(
      id: 'breath_03',
      title: 'Diaphragmatic Breathing',
      description: 'Slow belly breathing to support body relaxation.',
      type: BreathingExerciseType.diaphragmatic,
      durationMinutes: 6,
      inhaleSeconds: 5,
      holdSeconds: 0,
      exhaleSeconds: 5,
      restSeconds: 0,
      steps: [
        'Place one hand on chest and one on belly',
        'Breathe in slowly through the nose',
        'Let the belly rise more than the chest',
        'Exhale gently through the mouth',
      ],
      recommendedFor: 'Panic sensitivity, stress, and body tension',
    ),
    BreathingExerciseEntity(
      id: 'breath_04',
      title: 'Paced Breathing',
      description: 'Even breathing rhythm used for heart-rate regulation.',
      type: BreathingExerciseType.pacedBreathing,
      durationMinutes: 5,
      inhaleSeconds: 5,
      holdSeconds: 0,
      exhaleSeconds: 5,
      restSeconds: 0,
      steps: [
        'Inhale for 5 seconds',
        'Exhale for 5 seconds',
        'Keep the rhythm gentle and even',
      ],
      recommendedFor: 'Daily regulation and calming the nervous system',
    ),
    BreathingExerciseEntity(
      id: 'breath_05',
      title: 'Resonance Breathing',
      description: 'Slow therapeutic breathing around six breaths per minute.',
      type: BreathingExerciseType.resonance,
      durationMinutes: 6,
      inhaleSeconds: 5,
      holdSeconds: 0,
      exhaleSeconds: 5,
      restSeconds: 0,
      steps: [
        'Inhale slowly through the nose',
        'Exhale longer and softer than the inhale',
        'Stay relaxed and steady',
      ],
      recommendedFor: 'HRV training and long-term stress regulation',
    ),
  ];

  @override
  Future<FeelingType?> getLastSelectedFeeling() async {
    final preferences = await _prefs;
    final storedValue = preferences.getString(_lastFeelingKey);
    if (storedValue == null || storedValue.isEmpty) {
      return null;
    }

    return FeelingType.values.cast<FeelingType?>().firstWhere(
      (feeling) => feeling?.name == storedValue,
      orElse: () => null,
    );
  }

  @override
  Future<void> saveLastSelectedFeeling(FeelingType feeling) async {
    final preferences = await _prefs;
    await preferences.setString(_lastFeelingKey, feeling.name);
  }

  @override
  Future<List<MusicEntity>> getRecommendedTracks({
    required FeelingType feeling,
    int limit = 5,
    String? excludeTrackId,
  }) async {
    final filteredTracks = _musicCatalog
        .where(
          (track) =>
              track.supportedFeelings.contains(feeling) &&
              track.id != excludeTrackId,
        )
        .toList();

    final fallbackGoal = _goalForFeeling(feeling);
    final pool = filteredTracks.isNotEmpty
        ? filteredTracks
        : _musicCatalog
              .where(
                (track) =>
                    track.therapeuticGoals.contains(fallbackGoal) &&
                    track.id != excludeTrackId,
              )
              .toList();

    final rotated = [...pool]
      ..sort((a, b) => b.noveltyScore.compareTo(a.noveltyScore));
    if (rotated.length > 1) {
      rotated.shuffle(Random(DateTime.now().day + feeling.index * 17));
    }

    return rotated.take(limit).toList();
  }

  @override
  Future<List<MusicEntity>> getTracksByGoal(
    MusicTherapeuticGoal goal, {
    int limit = 5,
  }) async {
    final pool =
        _musicCatalog
            .where((track) => track.therapeuticGoals.contains(goal))
            .toList()
          ..sort((a, b) => b.noveltyScore.compareTo(a.noveltyScore));

    return pool.take(limit).toList();
  }

  @override
  Future<List<BreathingExerciseEntity>> getBreathingExercises() async {
    return List<BreathingExerciseEntity>.unmodifiable(_breathingCatalog);
  }

  @override
  Future<MusicEntity?> getTrackById(String id) async {
    for (final track in _musicCatalog) {
      if (track.id == id) {
        return track;
      }
    }
    return null;
  }

  MusicTherapeuticGoal _goalForFeeling(FeelingType feeling) {
    switch (feeling) {
      case FeelingType.happy:
        return MusicTherapeuticGoal.uplift;
      case FeelingType.sad:
        return MusicTherapeuticGoal.calmDown;
      case FeelingType.angry:
        return MusicTherapeuticGoal.calmDown;
      case FeelingType.neutral:
        return MusicTherapeuticGoal.stabilize;
      case FeelingType.anxious:
        return MusicTherapeuticGoal.calmDown;
    }
  }
}
