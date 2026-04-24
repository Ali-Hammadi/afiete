import 'dart:async';

import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/music/domain/entities/music_entity.dart';
import 'package:afiete/feature/music/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/music/presentation/widgets/breathing_exercise_card.dart';
import 'package:afiete/feature/music/presentation/widgets/music_track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class MusicHubScreen extends StatefulWidget {
  const MusicHubScreen({super.key});

  @override
  State<MusicHubScreen> createState() => _MusicHubScreenState();
}

class _MusicHubScreenState extends State<MusicHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<MusicCubit>().state;
      if (state is! MusicLoaded) {
        context.read<MusicCubit>().loadHub();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(SettingsStrings.relax), centerTitle: true),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: SettingsStrings.musicTabLabel),
                Tab(text: SettingsStrings.breathingTabLabel),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _MusicTab(onOpenExercise: _openFirstBreathingExercise),
                  _BreathingTab(onOpenExercise: _openExercise),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openExercise(BreathingExerciseEntity exercise) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<MusicCubit>(),
          child: BreathingExerciseScreen(exercise: exercise),
        ),
      ),
    );
  }

  void _openFirstBreathingExercise() {
    final state = context.read<MusicCubit>().state;
    if (state is MusicLoaded && state.breathingExercises.isNotEmpty) {
      _openExercise(state.breathingExercises.first);
    }
  }
}

class _MusicTab extends StatefulWidget {
  final VoidCallback onOpenExercise;

  const _MusicTab({required this.onOpenExercise});

  @override
  State<_MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<_MusicTab> {
  late final AudioPlayer _audioPlayer;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  Duration _position = Duration.zero;
  Duration _duration = const Duration(seconds: 1);
  bool _isLoadingAudio = false;
  String? _loadedTrackId;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _positionSub = _audioPlayer.positionStream.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _position = value;
      });
    });

    _durationSub = _audioPlayer.durationStream.listen((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _duration = value ?? const Duration(seconds: 1);
      });
    });

    _playerStateSub = _audioPlayer.playerStateStream.listen((playerState) {
      if (!mounted) {
        return;
      }
      if (playerState.processingState == ProcessingState.completed) {
        final musicState = context.read<MusicCubit>().state;
        if (musicState is MusicLoaded) {
          _playNext(musicState, loopToStart: true);
        }
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _prepareTrack(MusicEntity track, {bool autoPlay = false}) async {
    final wasPlaying = _audioPlayer.playing;
    if (_loadedTrackId == track.id && !autoPlay) {
      return;
    }

    setState(() {
      _isLoadingAudio = true;
    });

    try {
      await _audioPlayer.setUrl(track.audioUrl);
      _loadedTrackId = track.id;
      if (autoPlay || wasPlaying) {
        await _audioPlayer.play();
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SettingsStrings.noTracksAvailable)),
        );
      }
    } finally {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingAudio = false;
      });
    }
  }

  void _seekBySeconds(int seconds) {
    final target = _position + Duration(seconds: seconds);
    final clamped = target < Duration.zero
        ? Duration.zero
        : (target > _duration ? _duration : target);
    _audioPlayer.seek(clamped);
  }

  void _playTrackAtIndex(MusicLoaded state, int index, {bool autoPlay = true}) {
    if (index < 0 || index >= state.tracks.length) {
      return;
    }
    final track = state.tracks[index];
    context.read<MusicCubit>().selectTrack(track);
    unawaited(_prepareTrack(track, autoPlay: autoPlay));
  }

  void _playNext(MusicLoaded state, {bool loopToStart = false}) {
    if (state.tracks.isEmpty) {
      return;
    }

    final currentId = state.activeTrack?.id;
    final currentIndex = state.tracks.indexWhere((t) => t.id == currentId);
    if (currentIndex == -1) {
      _playTrackAtIndex(state, 0);
      return;
    }

    final nextIndex = currentIndex + 1;
    if (nextIndex < state.tracks.length) {
      _playTrackAtIndex(state, nextIndex);
      return;
    }

    if (loopToStart) {
      _playTrackAtIndex(state, 0);
    }
  }

  void _playPrevious(MusicLoaded state) {
    if (state.tracks.isEmpty) {
      return;
    }

    final currentId = state.activeTrack?.id;
    final currentIndex = state.tracks.indexWhere((t) => t.id == currentId);
    if (currentIndex <= 0) {
      return;
    }

    _playTrackAtIndex(state, currentIndex - 1);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _trackLengthLabel(int durationSeconds) {
    final minutes = (durationSeconds / 60).ceil();
    return SettingsStrings.isArabic ? '$minutes دقائق' : '$minutes minutes';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocConsumer<MusicCubit, MusicState>(
      listener: (context, state) {
        if (state is MusicLoaded && state.activeTrack != null) {
          unawaited(_prepareTrack(state.activeTrack!));
        }
      },
      builder: (context, state) {
        if (state is MusicLoading || state is MusicInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MusicError) {
          return Center(child: Text(state.message));
        }

        if (state is! MusicLoaded || state.activeTrack == null) {
          return Center(child: Text(SettingsStrings.noTracksAvailable));
        }

        final track = state.activeTrack!;
        final durationForUi = _duration.inSeconds > 1
            ? _duration
            : Duration(seconds: track.durationSeconds);
        final effectiveDuration = durationForUi.inSeconds <= 0
            ? const Duration(seconds: 1)
            : durationForUi;

        final currentPosition = _position > effectiveDuration
            ? effectiveDuration
            : _position;

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          children: [
            Text(
              SettingsStrings.podcastSessionLabel,
              textAlign: TextAlign.center,
              style: AppStyles.headingSmall.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${_trackLengthLabel(track.durationSeconds)} - ${track.title}',
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Image.asset(
                ImageLinks.woman1,
                height: 420,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Icon(
                Icons.graphic_eq_rounded,
                size: 34,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              track.artist,
              textAlign: TextAlign.center,
              style: AppStyles.headingSmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 7,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: currentPosition.inMilliseconds.toDouble(),
                max: effectiveDuration.inMilliseconds.toDouble(),
                onChanged: (value) {
                  _audioPlayer.seek(Duration(milliseconds: value.round()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(currentPosition),
                    style: AppStyles.bodyMedium,
                  ),
                  Text(
                    _formatDuration(effectiveDuration),
                    style: AppStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.outlined(
                  tooltip: SettingsStrings.rewindTenSeconds,
                  onPressed: _isLoadingAudio ? null : () => _seekBySeconds(-10),
                  icon: const Icon(Icons.replay_10_rounded),
                ),
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _isLoadingAudio
                        ? null
                        : () async {
                            if (_audioPlayer.playing) {
                              await _audioPlayer.pause();
                            } else {
                              await _audioPlayer.play();
                            }
                            if (mounted) {
                              setState(() {});
                            }
                          },
                    iconSize: 40,
                    color: colorScheme.onPrimary,
                    icon: Icon(
                      _audioPlayer.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                  ),
                ),
                IconButton.outlined(
                  tooltip: SettingsStrings.forwardTenSeconds,
                  onPressed: _isLoadingAudio ? null : () => _seekBySeconds(10),
                  icon: const Icon(Icons.forward_10_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _isLoadingAudio
                      ? null
                      : () => _playPrevious(state),
                  icon: const Icon(Icons.skip_previous_rounded),
                ),
                const SizedBox(width: 18),
                IconButton(
                  onPressed: _isLoadingAudio ? null : () => _playNext(state),
                  icon: const Icon(Icons.skip_next_rounded),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text(
              SettingsStrings.recommendedForYou,
              style: AppStyles.headingMedium,
            ),
            const SizedBox(height: 10),
            ...state.tracks.map(
              (item) => MusicTrackCard(
                track: item,
                isSelected: state.activeTrack?.id == item.id,
                onPlay: () {
                  _playTrackAtIndex(
                    state,
                    state.tracks.indexWhere((element) => element.id == item.id),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: widget.onOpenExercise,
              icon: const Icon(Icons.air_rounded),
              label: Text(SettingsStrings.startExercise),
            ),
          ],
        );
      },
    );
  }
}

class _BreathingTab extends StatelessWidget {
  final void Function(BreathingExerciseEntity exercise) onOpenExercise;

  const _BreathingTab({required this.onOpenExercise});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                SettingsStrings.breathingSubtitle,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (state.activeBreathingExercise != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsStrings.currentSessionLabel,
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.activeBreathingExercise!.title,
                        style: AppStyles.headingSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.activeBreathingExercise!.description,
                        style: AppStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () =>
                            onOpenExercise(state.activeBreathingExercise!),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(SettingsStrings.startExercise),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                SettingsStrings.viewAllExercises,
                style: AppStyles.headingMedium,
              ),
              const SizedBox(height: 12),
              if (state.breathingExercises.isEmpty)
                Text(
                  SettingsStrings.noExerciseAvailable,
                  style: AppStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ...state.breathingExercises.map(
                  (exercise) => BreathingExerciseCard(
                    exercise: exercise,
                    onStart: () => onOpenExercise(exercise),
                  ),
                ),
            ],
          );
        }

        if (state is MusicLoading || state is MusicInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MusicError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class BreathingExerciseScreen extends StatefulWidget {
  final BreathingExerciseEntity exercise;

  const BreathingExerciseScreen({super.key, required this.exercise});

  @override
  State<BreathingExerciseScreen> createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> {
  late final List<_PhaseStep> _steps;
  late int _currentStepIndex;
  late int _remainingSeconds;
  late int _elapsedSeconds;
  bool _isRunning = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _steps = _buildSteps(widget.exercise);
    _currentStepIndex = 0;
    _remainingSeconds = _steps.first.durationSeconds;
    _elapsedSeconds = 0;
  }

  List<_PhaseStep> _buildSteps(BreathingExerciseEntity exercise) {
    switch (exercise.type) {
      case BreathingExerciseType.boxBreathing:
        return const [
          _PhaseStep(_PhaseType.inhale, 'Inhale', 4),
          _PhaseStep(_PhaseType.hold, 'Hold', 4),
          _PhaseStep(_PhaseType.exhale, 'Exhale', 4),
          _PhaseStep(_PhaseType.rest, 'Hold', 4),
        ];
      case BreathingExerciseType.fourSevenEight:
        return const [
          _PhaseStep(_PhaseType.inhale, 'Inhale', 4),
          _PhaseStep(_PhaseType.hold, 'Hold', 7),
          _PhaseStep(_PhaseType.exhale, 'Exhale', 8),
        ];
      case BreathingExerciseType.diaphragmatic:
        return const [
          _PhaseStep(_PhaseType.inhale, 'Belly inhale', 5),
          _PhaseStep(_PhaseType.exhale, 'Slow exhale', 5),
        ];
      case BreathingExerciseType.pacedBreathing:
        return const [
          _PhaseStep(_PhaseType.inhale, 'Inhale', 5),
          _PhaseStep(_PhaseType.exhale, 'Exhale', 5),
        ];
      case BreathingExerciseType.resonance:
        return const [
          _PhaseStep(_PhaseType.inhale, 'Inhale', 5),
          _PhaseStep(_PhaseType.exhale, 'Exhale', 5),
        ];
    }
  }

  void _toggleRunning() {
    setState(() {
      _isRunning = !_isRunning;
    });
    if (_isRunning) {
      _tick();
    }
  }

  Future<void> _tick() async {
    while (mounted && _isRunning && !_isCompleted) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted || !_isRunning || _isCompleted) {
        break;
      }

      setState(() {
        _elapsedSeconds += 1;
        _remainingSeconds -= 1;
        if (_remainingSeconds <= 0) {
          _currentStepIndex = (_currentStepIndex + 1) % _steps.length;
          _remainingSeconds = _steps[_currentStepIndex].durationSeconds;
        }
        if (_elapsedSeconds >= widget.exercise.durationMinutes * 60) {
          _isRunning = false;
          _isCompleted = true;
        }
      });
    }
  }

  String _phaseLabel(_PhaseType phaseType) {
    switch (phaseType) {
      case _PhaseType.inhale:
        return SettingsStrings.inhaleLabel;
      case _PhaseType.hold:
        return SettingsStrings.holdLabel;
      case _PhaseType.exhale:
        return SettingsStrings.exhaleLabel;
      case _PhaseType.rest:
        return SettingsStrings.restLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStep = _steps[_currentStepIndex];
    final totalSeconds = widget.exercise.durationMinutes * 60;
    final progress = totalSeconds == 0 ? 0.0 : _elapsedSeconds / totalSeconds;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(widget.exercise.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.exercise.description,
              textAlign: TextAlign.center,
              style: AppStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colorScheme.primaryContainer.withValues(alpha: 0.55),
                border: Border.all(color: colorScheme.primary, width: 6),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentStep.label,
                        style: AppStyles.headingMedium.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _remainingSeconds.toString().padLeft(2, '0'),
                        style: AppStyles.headingLarge.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _phaseLabel(currentStep.type),
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              widget.exercise.steps.join('\n'),
              textAlign: TextAlign.center,
              style: AppStyles.bodyMedium.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: _toggleRunning,
                    child: Text(
                      _isRunning
                          ? SettingsStrings.pauseExercise
                          : SettingsStrings.startExercise,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  onPressed: () {
                    setState(() {
                      _isRunning = false;
                      _isCompleted = false;
                      _currentStepIndex = 0;
                      _remainingSeconds = _steps.first.durationSeconds;
                      _elapsedSeconds = 0;
                    });
                  },
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum _PhaseType { inhale, hold, exhale, rest }

class _PhaseStep {
  final _PhaseType type;
  final String label;
  final int durationSeconds;

  const _PhaseStep(this.type, this.label, this.durationSeconds);
}
