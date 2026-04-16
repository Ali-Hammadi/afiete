import 'package:flutter/material.dart';

class CustomSectionDividerWidget extends StatelessWidget {
  final String? title;
  final EdgeInsets padding;

  const CustomSectionDividerWidget({
    super.key,
    this.title,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (title != null) {
      return Padding(
        padding: padding,
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                title!,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: padding,
      child: Container(
        height: 1,
        color: colorScheme.outline.withValues(alpha: 0.35),
      ),
    );
  }
}
