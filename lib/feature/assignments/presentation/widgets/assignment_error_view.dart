import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';

class AssignmentErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AssignmentErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            CustomButton(
              widget: Text(
                'Retry',
                style: AppStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
