import 'package:afiete/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static final ColorScheme _lightColorScheme = const ColorScheme.light(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: AppColors.primarybackgroundColor,
    primaryContainer: AppColors.primaryFillColor,
    onPrimaryContainer: AppColors.primarytextColor,
    error: AppColors.errorColor,
    onPrimary: AppColors.whiteColor,
    onSecondary: AppColors.whiteColor,
    onSurface: AppColors.primarytextColor,
    onError: AppColors.whiteColor,
  );

  static final ColorScheme _darkColorScheme = const ColorScheme.dark(
    primary: AppColors.primaryColor,
    secondary: AppColors.secondaryColor,
    surface: AppColors.darkSecondaryBackgroundColor,
    primaryContainer: AppColors.darkPrimaryFillColor,
    onPrimaryContainer: AppColors.whiteColor,
    error: AppColors.errorColor,
    onPrimary: AppColors.whiteColor,
    onSecondary: AppColors.whiteColor,
    onSurface: AppColors.darkPrimaryTextColor,
    onError: AppColors.whiteColor,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _lightColorScheme,
      scaffoldBackgroundColor: AppColors.primarybackgroundColor,
      cardColor: AppColors.whiteColor,
      dividerColor: AppColors.primaryFillColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primarybackgroundColor,
        foregroundColor: AppColors.primarytextColor,
        elevation: 0,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.primaryColor,
        contentTextStyle: TextStyle(color: AppColors.whiteColor),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.whiteColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.unselectedFieldColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.unselectedFieldColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.4,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.secondarytextColor),
        labelStyle: const TextStyle(color: AppColors.primarytextColor),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.primarytextColor),
        displayMedium: TextStyle(color: AppColors.primarytextColor),
        displaySmall: TextStyle(color: AppColors.primarytextColor),
        headlineLarge: TextStyle(color: AppColors.primarytextColor),
        headlineMedium: TextStyle(color: AppColors.primarytextColor),
        headlineSmall: TextStyle(color: AppColors.primarytextColor),
        titleLarge: TextStyle(color: AppColors.primarytextColor),
        titleMedium: TextStyle(color: AppColors.primarytextColor),
        titleSmall: TextStyle(color: AppColors.primarytextColor),
        bodyLarge: TextStyle(color: AppColors.primarytextColor),
        bodyMedium: TextStyle(color: AppColors.primarytextColor),
        bodySmall: TextStyle(color: AppColors.secondarytextColor),
      ),
      iconTheme: const IconThemeData(color: AppColors.unselectedIconColor),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? _lightColorScheme.primary
              : AppColors.unselectedFieldColor,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.selectedFieldColor
              : AppColors.primaryFillColor,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(
          AppColors.themeToggleOutlineColor,
        ),
        trackOutlineWidth: const WidgetStatePropertyAll(1.2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: AppColors.whiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,
      scaffoldBackgroundColor: AppColors.darkBackgroundColor,
      cardColor: AppColors.darkSecondaryBackgroundColor,
      dividerColor: AppColors.darkDividerColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackgroundColor,
        foregroundColor: AppColors.darkPrimaryTextColor,
        elevation: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primaryColor,
        contentTextStyle: const TextStyle(color: AppColors.whiteColor),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSecondaryBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.darkUnselectedFieldColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.darkUnselectedFieldColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.4,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.darkSecondaryTextColor),
        labelStyle: const TextStyle(color: AppColors.darkPrimaryTextColor),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: AppColors.darkPrimaryTextColor),
        displayMedium: TextStyle(color: AppColors.darkPrimaryTextColor),
        displaySmall: TextStyle(color: AppColors.darkPrimaryTextColor),
        headlineLarge: TextStyle(color: AppColors.darkPrimaryTextColor),
        headlineMedium: TextStyle(color: AppColors.darkPrimaryTextColor),
        headlineSmall: TextStyle(color: AppColors.darkPrimaryTextColor),
        titleLarge: TextStyle(color: AppColors.darkPrimaryTextColor),
        titleMedium: TextStyle(color: AppColors.darkPrimaryTextColor),
        titleSmall: TextStyle(color: AppColors.darkPrimaryTextColor),
        bodyLarge: TextStyle(color: AppColors.darkPrimaryTextColor),
        bodyMedium: TextStyle(color: AppColors.darkPrimaryTextColor),
        bodySmall: TextStyle(color: AppColors.darkSecondaryTextColor),
      ),
      iconTheme: const IconThemeData(color: AppColors.darkUnselectedIconColor),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryColor
              : AppColors.unselectedFieldColor,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.darkSwitchSelectedTrackColor
              : AppColors.darkSwitchTrackColor,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(
          AppColors.themeToggleOutlineColor,
        ),
        trackOutlineWidth: const WidgetStatePropertyAll(1.2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.whiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
    );
  }
}
