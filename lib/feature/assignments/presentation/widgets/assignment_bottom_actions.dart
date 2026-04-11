import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';

class AssignmentBottomActions extends StatelessWidget {
  final bool showBack;
  final bool isLastQuestion;
  final VoidCallback onBack;
  final VoidCallback onContinueOrSubmit;

  const AssignmentBottomActions({
    super.key,
    required this.showBack,
    required this.isLastQuestion,
    required this.onBack,
    required this.onContinueOrSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      color: const Color(0xFFEAF4F1),
      child: Row(
        children: [
          if (showBack)
            Expanded(
              child: CustomButton(
                widget: Text(
                  'Back',
                  style: AppStyles.bodyMedium.copyWith(color: Colors.white),
                ),
                onPressed: onBack,
              ),
            ),
          if (showBack) const SizedBox(width: 12),
          Expanded(
            child: CustomButton(
              widget: Text(
                isLastQuestion ? 'Submit' : 'Continue',
                style: AppStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              onPressed: onContinueOrSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
