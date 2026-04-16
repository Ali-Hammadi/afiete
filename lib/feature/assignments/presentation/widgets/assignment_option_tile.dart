import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAssignmentOptionTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomAssignmentOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.55),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: Text(option, style: AppStyles.headingSmall)),
              if (isSelected)
                Icon(Icons.check_circle_outline, color: colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
