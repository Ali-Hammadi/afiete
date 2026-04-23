import 'package:flutter/material.dart';

class CustomLanguageOption extends StatelessWidget {
  final String value;
  final String? label;

  const CustomLanguageOption({super.key, required this.value, this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Radio<String>(value: value),
          Expanded(
            child: Text(label ?? value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
