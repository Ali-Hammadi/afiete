import 'package:flutter/material.dart';

abstract class AppStyles {
  // padding and border radius
  static const double padding = 16.0;
  static const double borderRadius = 16.0;
  // font sizes
  static const double smallFontSize = 16.0;
  static const double mediumFontSize = 18.0;
  static const double bigFontSize = 20.0;
  static const double veryBigFontSize = 24.0;
  static const double boldfontSize = 20.0;

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: veryBigFontSize,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: bigFontSize,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: smallFontSize,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLarge = TextStyle(fontSize: mediumFontSize);

  static const TextStyle bodyMedium = TextStyle(fontSize: smallFontSize);

  static const TextStyle bodySmall = TextStyle(fontSize: 14);
}
