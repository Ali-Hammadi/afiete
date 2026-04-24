import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/presentation/cubits/assignments_cubit.dart';
import 'package:afiete/feature/assignments/presentation/screens/assignment_result_screen.dart';
import 'package:afiete/feature/assignments/presentation/widgets/assignment_bottom_actions.dart';
import 'package:afiete/feature/assignments/presentation/widgets/assignment_error_view.dart';
import 'package:afiete/feature/assignments/presentation/widgets/assignment_option_tile.dart';
import 'package:afiete/feature/assignments/presentation/widgets/assignment_progress_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentTestScreen extends StatelessWidget {
  const AssignmentTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          SettingsStrings.assessmentTitle,
          style: AppStyles.headingMedium,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AssignmentsCubit, AssignmentsState>(
        builder: (context, state) {
          if (state is AssignmentsLoading || state is AssignmentsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentsSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AssignmentsError) {
            return CustomAssignmentErrorView(
              message: state.message,
              onRetry: () => context.read<AssignmentsCubit>().loadQuestions(),
            );
          }

          if (state is AssignmentsResultLoaded) {
            return AssignmentResultScreen(state: state);
          }

          if (state is! AssignmentsLoaded) {
            return const SizedBox.shrink();
          }

          final question = state.currentQuestion;
          final selectedAnswer = state.selectedAnswers[question.id] ?? '';
          final isLastQuestion =
              state.currentQuestionIndex == state.questions.length - 1;
          final progress =
              (state.currentQuestionIndex + 1) / state.questions.length;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.padding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAssignmentProgressHeader(
                        progress: progress,
                        questionIndex: state.currentQuestionIndex + 1,
                        totalQuestions: state.questions.length,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        question.questionText,
                        style: AppStyles.headingMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        SettingsStrings.assessmentPrompt,
                        style: AppStyles.bodyMedium.copyWith(
                          color:
                              (theme.textTheme.bodyMedium?.color ??
                                      colorScheme.onSurface)
                                  .withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._buildOptions(
                        context: context,
                        questionId: question.id,
                        selectedAnswer: selectedAnswer,
                        options: question.options.isNotEmpty
                            ? question.options
                            : AssignmentEntity.standardOptions,
                      ),
                      if (state.validationError != null &&
                          state.validationError!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          state.validationError!,
                          style: AppStyles.bodySmall.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              CustomAssignmentBottomActions(
                showBack: state.currentQuestionIndex > 0,
                isLastQuestion: isLastQuestion,
                onBack: () =>
                    context.read<AssignmentsCubit>().goToPreviousQuestion(),
                onContinueOrSubmit: () {
                  if (isLastQuestion) {
                    context.read<AssignmentsCubit>().submitCurrentAssignment();
                    return;
                  }
                  context.read<AssignmentsCubit>().goToNextQuestion();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildOptions({
    required BuildContext context,
    required String questionId,
    required String selectedAnswer,
    required List<String> options,
  }) {
    return options
        .map(
          (option) => CustomAssignmentOptionTile(
            option: SettingsStrings.assignmentOptionLabel(option),
            isSelected: selectedAnswer == option,
            onTap: () => context.read<AssignmentsCubit>().selectAnswer(
              questionId: questionId,
              answer: option,
            ),
          ),
        )
        .toList();
  }
}
