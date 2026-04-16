import 'package:flutter/material.dart';

class CustomLanguageOption extends StatelessWidget {
  final String value;

  const CustomLanguageOption({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Radio<String>(value: value);
  }
}
