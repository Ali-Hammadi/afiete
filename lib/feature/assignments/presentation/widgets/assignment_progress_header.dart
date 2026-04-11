import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class AssignmentProgressHeader extends StatelessWidget {
  final double progress;
  final int questionIndex;
  final int totalQuestions;

  const AssignmentProgressHeader({
    super.key,
    required this.progress,
    required this.questionIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          color: AppColors.primaryColor,
          backgroundColor: const Color(0xFFD8F1E8),
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
