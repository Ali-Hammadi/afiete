import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:flutter/material.dart';

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
