import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomPaymentMethodTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const CustomPaymentMethodTile({
    super.key,
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.35),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 20,
              color: selected ? colorScheme.primary : theme.cardColor,
            ),
            const SizedBox(width: 12),
            Icon(icon, color: colorScheme.onSurface.withValues(alpha: 0.75)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppStyles.headingSmall)),
          ],
        ),
      ),
    );
  }
}
