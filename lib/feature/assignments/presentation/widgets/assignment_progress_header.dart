import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAssignmentProgressHeader extends StatelessWidget {
  final double progress;
  final int questionIndex;
  final int totalQuestions;

  const CustomAssignmentProgressHeader({
    super.key,
    required this.progress,
    required this.questionIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          color: colorScheme.primary,
          backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Question $questionIndex of $totalQuestions',
            style: AppStyles.bodySmall,
          ),
        ),
      ],
    );
  }
}
