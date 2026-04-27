import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/relax/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/relax/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/relax/presentation/screens/breating_excercise_screen.dart';
import 'package:afiete/feature/relax/presentation/widgets/breathing_tab.dart';
import 'package:afiete/feature/relax/presentation/widgets/music_tab.dart';
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
                  MusicTab(onOpenExercise: _openFirstBreathingExercise),
                  BreathingTab(onOpenExercise: _openExercise),
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
