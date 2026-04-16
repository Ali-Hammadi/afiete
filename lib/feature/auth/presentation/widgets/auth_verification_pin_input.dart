import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomAuthVerificationPinInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onCompleted;

  const CustomAuthVerificationPinInput({
    super.key,
    required this.controller,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    PinTheme buildPinTheme({
      required Color textColor,
      required BoxDecoration decoration,
    }) {
      return PinTheme(
        width: 56,
        height: 56,
        textStyle: TextStyle(
          fontSize: 20,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
        decoration: decoration,
      );
    }

    final sharedDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      color: colorScheme.primaryContainer.withValues(alpha: 0.4),
    );

    return Pinput(
      length: 4,
      controller: controller,
      onCompleted: onCompleted,
      defaultPinTheme: buildPinTheme(
        textColor: colorScheme.onSurface,
        decoration: sharedDecoration.copyWith(
          border: Border.all(color: colorScheme.outline),
        ),
      ),
      focusedPinTheme: buildPinTheme(
        textColor: colorScheme.onSurface,
        decoration: sharedDecoration.copyWith(
          border: Border.all(color: colorScheme.primary),
        ),
      ),
      submittedPinTheme: buildPinTheme(
        textColor: colorScheme.onPrimary,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          color: colorScheme.primary,
          border: Border.all(color: colorScheme.primary),
        ),
      ),
      errorPinTheme: buildPinTheme(
        textColor: colorScheme.onSurface,
        decoration: sharedDecoration.copyWith(
          border: Border.all(color: colorScheme.error),
        ),
      ),
    );
  }
}
