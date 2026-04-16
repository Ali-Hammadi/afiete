import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit(this._prefs, ThemeMode initialMode) : super(initialMode);

  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;

  static Future<ThemeCubit> create() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getString(_themeKey);
    final initialMode = storedTheme == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
    return ThemeCubit(prefs, initialMode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (state == mode) return;
    emit(mode);
    await _prefs.setString(
      _themeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
