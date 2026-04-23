import 'package:afiete/core/constants/styles.dart';
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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppStyles.padding,
        AppStyles.padding,
        AppStyles.padding,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How are you felling today ?",
            style: AppStyles.headingSmall,
            textAlign: TextAlign.left,
          ),
          CustomEmotionsWidget(),
          CustomAssignmentWidget(),
          CustomMusicWidget(),
          Text("Top Doctors", style: AppStyles.headingMedium),
          CustomTopDoctorsWidget(),
          const SizedBox(height: 20),
          BlocBuilder<AssignmentsCubit, AssignmentsState>(
            builder: (context, assignmentsState) {
              return BlocBuilder<ArticlesCubit, ArticlesState>(
                builder: (context, articlesState) {
                  if (articlesState is ArticlesInitial) {
                    context.read<ArticlesCubit>().loadArticlesForHome(
                      userDiagnosis: _resolveClosestDiagnosis(assignmentsState),
                    );
                  }
                  return ArticlesHomeSection(
                    userDiagnosis: _resolveClosestDiagnosis(assignmentsState),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
