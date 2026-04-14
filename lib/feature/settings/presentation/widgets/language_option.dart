import 'package:flutter/material.dart';

class LanguageOption extends StatelessWidget {
  final String value;

  const LanguageOption({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Radio<String>(value: value);
  }
}
