import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/music/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/music/presentation/widgets/breathing_exercise_card.dart';
import 'package:afiete/feature/music/presentation/widgets/music_track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: AppColors.secondarybackgroundColor.withValues(
        alpha: 0.26,
      ),
      appBar: AppBar(
        title: Text(SettingsStrings.musicTitle),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.55),
                      AppColors.secondarybackgroundColor.withValues(alpha: 0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                ),
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<MusicCubit, MusicState>(
                  builder: (context, state) {
                    if (state is MusicLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SettingsStrings.musicSubtitle,
                            style: AppStyles.bodyMedium.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: FeelingType.values.map((feeling) {
                              final isSelected =
                                  feeling == state.selectedFeeling;
                              return ChoiceChip(
                                selected: isSelected,
                                label: Text(_labelForFeeling(feeling)),
                                onSelected: (_) => context
                                    .read<MusicCubit>()
                                    .selectFeeling(feeling),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.hasSavedFeeling
                                ? SettingsStrings.continueFromLastMood
                                : SettingsStrings.chooseMoodHint,
                            style: AppStyles.bodySmall.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          SettingsStrings.musicSubtitle,
                          style: AppStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          SettingsStrings.chooseMoodHint,
                          style: AppStyles.bodySmall.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
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

  String _labelForFeeling(FeelingType feeling) {
    switch (feeling) {
      case FeelingType.happy:
        return SettingsStrings.isArabic ? 'سعيد' : 'Happy';
      case FeelingType.sad:
        return SettingsStrings.isArabic ? 'حزين' : 'Sad';
      case FeelingType.angry:
        return SettingsStrings.isArabic ? 'غاضب' : 'Angry';
      case FeelingType.neutral:
        return SettingsStrings.isArabic ? 'عادي' : 'Neutral';
      case FeelingType.anxious:
        return SettingsStrings.isArabic ? 'قلق' : 'Anxious';
    }
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

class _MusicTab extends StatelessWidget {
  final VoidCallback onOpenExercise;

  const _MusicTab({required this.onOpenExercise});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        if (state is MusicLoading || state is MusicInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MusicLoaded) {
          final track = state.activeTrack;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      SettingsStrings.recommendedForYou,
                      style: AppStyles.headingSmall.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      track?.description ?? SettingsStrings.noTracksAvailable,
                      style: AppStyles.bodyMedium.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (track != null)
                      MusicTrackCard(
                        track: track,
                        isSelected: true,
                        onPlay: () =>
                            context.read<MusicCubit>().selectTrack(track),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                SettingsStrings.recommendedForYou,
                style: AppStyles.headingMedium,
              ),
              const SizedBox(height: 12),
              if (state.tracks.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    SettingsStrings.noTracksAvailable,
                    style: AppStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                ...state.tracks.map(
                  (track) => MusicTrackCard(
                    track: track,
                    isSelected: state.activeTrack?.id == track.id,
                    onPlay: () => context.read<MusicCubit>().selectTrack(track),
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onOpenExercise,
                icon: const Icon(Icons.air_rounded),
                label: Text(SettingsStrings.startExercise),
              ),
            ],
          );
        }

        if (state is MusicError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
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

  @override
  void dispose() {
    super.dispose();
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
      backgroundColor: AppColors.secondarybackgroundColor.withValues(
        alpha: 0.45,
      ),
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
