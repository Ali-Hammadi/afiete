import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Colors
  static const Color primaryColor = Color(0xFF0493E2);
  static const Color secondaryColor = Color(0xFF0051FF);
  // Filed Colors
  static const Color primaryFillColor = Color(0xFFD8E1EA);
  static const Color unselectedFieldColor = Color(0xFF7FAEDB);
  static const Color selectedFieldColor = Color(0xFF4FA3E3);
  // Background Colors
  static const Color primarybackgroundColor = Color(0xFFF5F6F8);
  static const Color secondarybackgroundColor = Color(0xFFD9F7FF);
  static const Color darkBackgroundColor = Color(0xFF111A27);
  static const Color darkSecondaryBackgroundColor = Color(0xFF1A2433);
  // Text Colors
  static const Color primarytextColor = Color(0xFF1E1E1E);
  static const Color secondarytextColor = Color(0xFF8A9A98);
  static const Color darkPrimaryTextColor = Color(0xFFE6ECF3);
  static const Color darkSecondaryTextColor = Color(0xFFA7B9CC);
  // Error Colors
  static const Color errorColor = Color(0xFFF01F1F);
  // Icon Colors
  static const Color unselectedIconColor = secondarytextColor;
  static const Color selectedIconcolor = secondaryColor;
  static const Color darkUnselectedIconColor = Color(0xFFC4D4E5);
  static const Color darkUnselectedFieldColor = Color(0xFF35465A);
  static const Color darkPrimaryFillColor = Color(0xFF243548);
  static const Color darkDividerColor = Color(0xFF2D3A4D);
  static const Color darkSwitchTrackColor = Color(0xFF3A495B);
  static const Color darkSwitchSelectedTrackColor = Color(0xFF2E5F85);
  // Other Colors
  static const Color whiteColor = Color(0xFFFFFFFF);

  static Color primaryTextFor(bool isDark) =>
      isDark ? darkPrimaryTextColor : primarytextColor;

  static Color secondaryTextFor(bool isDark) =>
      isDark ? darkSecondaryTextColor : secondarytextColor;
}
