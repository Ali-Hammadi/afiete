import 'dart:async';

import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/relax/domain/entities/music_entity.dart';
import 'package:afiete/feature/relax/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/relax/presentation/widgets/music_track_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

class MusicTab extends StatefulWidget {
  final VoidCallback onOpenExercise;

  const MusicTab({super.key, required this.onOpenExercise});

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab>
    with SingleTickerProviderStateMixin {
  late final AudioPlayer _audioPlayer;
  late final AnimationController _discRotationController;
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
    _discRotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

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
      _syncDiscRotation();
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
    _discRotationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _syncDiscRotation() {
    if (_audioPlayer.playing) {
      if (!_discRotationController.isAnimating) {
        _discRotationController.repeat();
      }
      return;
    }

    if (_discRotationController.isAnimating) {
      _discRotationController.stop();
    }
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
      if (mounted) {
        setState(() {
          _isLoadingAudio = false;
        });
      }
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
            const SizedBox(height: 20),
            Center(
              child: RotationTransition(
                turns: _discRotationController,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.22),
                        colorScheme.primaryContainer.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.55),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.95),
                      ),
                      child: Icon(
                        Icons.music_note_rounded,
                        size: 38,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
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
                            _syncDiscRotation();
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
