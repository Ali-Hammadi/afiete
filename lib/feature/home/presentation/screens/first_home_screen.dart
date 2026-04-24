import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'package:afiete/feature/articles/presentation/cubits/articles_cubit.dart';
import 'package:afiete/feature/articles/presentation/widgets/articles_home_section.dart';
import 'package:afiete/feature/home/presentation/widgets/assignment_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/emotions_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/music_widget.dart';
import 'package:afiete/feature/home/presentation/widgets/top_doctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirstHomeScreen extends StatelessWidget {
  const FirstHomeScreen({super.key});

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
      body: Padding(
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

              CustomEmotionsWidget(),
              CustomAssignmentWidget(),
              CustomMusicWidget(),
              Text(
                SettingsStrings.topDoctorsTitle,
                style: AppStyles.headingMedium,
              ),
              CustomTopDoctorsWidget(),
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
    );
  }
}
