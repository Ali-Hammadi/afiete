import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';

class CustomAssignmentErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CustomAssignmentErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
