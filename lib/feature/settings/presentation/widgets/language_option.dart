import 'package:flutter/material.dart';

class CustomLanguageOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final VoidCallback onTap;

  const CustomLanguageOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = value == groupValue;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 0.85,
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.35),
          ),
          color: isSelected
              ? colorScheme.primaryContainer.withValues(alpha: 0.35)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            RadioGroup<String>(
              groupValue: groupValue,
              onChanged: (selected) {
                if (selected == value) onTap();
              },
              child: Radio<String>(value: value),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
