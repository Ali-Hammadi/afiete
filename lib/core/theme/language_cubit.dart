import 'package:afiete/core/constants/settings_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit(this._prefs, Locale initialLocale) : super(initialLocale);

  static const String _languageCodeKey = 'app_language_code';
  final SharedPreferences _prefs;

  static Future<LanguageCubit> create() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCode = prefs.getString(_languageCodeKey);
    final normalized = storedCode == 'ar' ? 'ar' : 'en';
    final initialLocale = Locale(normalized);
    SettingsStrings.setLanguageCode(normalized);
    return LanguageCubit(prefs, initialLocale);
  }

  Future<void> setLanguageCode(String languageCode) async {
    final normalized = languageCode.toLowerCase() == 'ar' ? 'ar' : 'en';
    if (state.languageCode == normalized) return;

    final locale = Locale(normalized);
    SettingsStrings.setLanguageCode(normalized);
    emit(locale);
    await _prefs.setString(_languageCodeKey, normalized);
  }
}
