import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/di/injection_container.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:afiete/feature/articles/presentation/widgets/articles_home_section.dart';
import 'package:afiete/feature/feeling/presentation/cubit/feeling_cubit.dart';
import 'package:afiete/feature/home/presentation/widgets/assignment_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/emotions_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/music_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/top_doctor.dart';
import 'package:afiete/feature/music/presentation/cubit/music_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstHomeScreen extends StatelessWidget {
  const FirstHomeScreen({super.key});

  FeelingType? _selectedFeelingFromState(FeelingState state) {
    if (state is FeelingLoaded) {
      return state.selectedFeeling;
    }
    if (state is FeelingError) {
      return state.selectedFeeling;
    }
    return null;
  }

  String? _resolveClosestDiagnosis(AssignmentsState assignmentsState) {
    if (assignmentsState is! AssignmentsResultLoaded) {
      return null;
    }

    final AssignmentEntity result = assignmentsState.result;
    if (result.recommendedSpecialties.isNotEmpty) {
      return result.recommendedSpecialties.first;
    }

    if (result.severity.trim().isNotEmpty) {
      return result.severity;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<MusicCubit>(create: (_) => sl<MusicCubit>()..loadHub()),
          BlocProvider<FeelingCubit>(
            create: (_) => sl<FeelingCubit>()..loadFeelingHub(),
          ),
        ],
        child: BlocListener<FeelingCubit, FeelingState>(
          listenWhen: (previous, current) =>
              _selectedFeelingFromState(previous) !=
              _selectedFeelingFromState(current),
          listener: (context, state) {
            final selectedFeeling = _selectedFeelingFromState(state);
            if (selectedFeeling == null) {
              return;
            }
            final musicState = context.read<MusicCubit>().state;
            if (musicState is MusicLoaded &&
                musicState.selectedFeeling == selectedFeeling) {
              return;
            }
            context.read<MusicCubit>().selectFeeling(selectedFeeling);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.padding),
            child: SingleChildScrollView(
              key: const PageStorageKey('first_home_scroll'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SettingsStrings.howAreYouFeelingToday,
                    style: AppStyles.headingSmall,
                    textAlign: TextAlign.start,
                  ),

                  const CustomEmotionsWidget(),
                  const CustomAssignmentWidget(),
                  const CustomMusicWidget(),
                  Text(
                    SettingsStrings.topDoctorsTitle,
                    style: AppStyles.headingMedium,
                  ),
                  const CustomTopDoctorsWidget(),
                  const SizedBox(height: 20),
                  BlocBuilder<AssignmentsCubit, AssignmentsState>(
                    builder: (context, assignmentsState) {
                      return BlocBuilder<ArticlesCubit, ArticlesState>(
                        builder: (context, articlesState) {
                          if (articlesState is ArticlesInitial) {
                            context.read<ArticlesCubit>().loadArticlesForHome(
                              userDiagnosis: _resolveClosestDiagnosis(
                                assignmentsState,
                              ),
                            );
                          }
                          return ArticlesHomeSection(
                            userDiagnosis: _resolveClosestDiagnosis(
                              assignmentsState,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
