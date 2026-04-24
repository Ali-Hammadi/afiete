import 'package:flutter/material.dart';
import 'package:afiete/core/constants/styles.dart';

class CustomReportReasonCard extends StatelessWidget {
  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String? color;

  const CustomReportReasonCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  Color _getIconColor(ColorScheme colorScheme) {
    if (color == 'red') return colorScheme.error;
    if (color == 'orange') return colorScheme.secondary;
    if (color == 'gray') return colorScheme.outline;
    return colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isSelected
          ? colorScheme.primaryContainer.withValues(alpha: 0.45)
          : theme.cardColor,
      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppStyles.padding),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(AppStyles.borderRadius),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(_getIconData(), color: _getIconColor(colorScheme), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppStyles.bodyLarge.copyWith(
                    color: isSelected
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.75),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              if (isSelected)
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                  child: Icon(
                    Icons.check,
                    color: colorScheme.onPrimary,
                    size: 14,
                  ),
                )
              else
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.outline, width: 1),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData() {
    switch (icon) {
      case 'warning':
        return Icons.warning_amber;
      case 'block':
        return Icons.block;
      case 'error':
        return Icons.error;
      case 'schedule':
        return Icons.schedule;
      case 'bug_report':
        return Icons.bug_report;
      case 'close':
        return Icons.close;
      case 'payment':
        return Icons.payment;
      case 'help':
        return Icons.help;
      default:
        return Icons.info;
    }
  }
}
