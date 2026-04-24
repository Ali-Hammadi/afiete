import 'dart:convert';

import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/feature/feeling/domain/entities/feeling_entry_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FeelingLocalDataSource {
  Future<FeelingType?> getCurrentFeeling();

  Future<FeelingEntryEntity> saveFeeling({
    required FeelingType feeling,
    int intensity,
  });

  Future<List<FeelingEntryEntity>> getFeelingHistory({int limit});
}

class FeelingLocalDataSourceImpl implements FeelingLocalDataSource {
  static const String _currentFeelingKey = 'feeling_current_value';
  static const String _historyKey = 'feeling_history_v1';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  @override
  Future<FeelingType?> getCurrentFeeling() async {
    final preferences = await _prefs;
    final stored = preferences.getString(_currentFeelingKey);
    if (stored == null || stored.isEmpty) {
      return null;
    }
    for (final feeling in FeelingType.values) {
      if (feeling.name == stored) {
        return feeling;
      }
    }
    return null;
  }

  @override
  Future<FeelingEntryEntity> saveFeeling({
    required FeelingType feeling,
    int intensity = 3,
  }) async {
    final preferences = await _prefs;
    final now = DateTime.now();
    final entry = FeelingEntryEntity(
      id: now.microsecondsSinceEpoch.toString(),
      feeling: feeling,
      intensity: intensity,
      createdAt: now,
    );

    final currentHistory = await getFeelingHistory(limit: 120);
    final updatedHistory = [entry, ...currentHistory];
    final serialized = updatedHistory.map(_encodeEntry).toList(growable: false);

    await preferences.setString(_currentFeelingKey, feeling.name);
    await preferences.setString(_historyKey, jsonEncode(serialized));
    return entry;
  }

  @override
  Future<List<FeelingEntryEntity>> getFeelingHistory({int limit = 30}) async {
    final preferences = await _prefs;
    final raw = preferences.getString(_historyKey);
    if (raw == null || raw.isEmpty) {
      return const <FeelingEntryEntity>[];
    }

    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      return const <FeelingEntryEntity>[];
    }

    final entries = <FeelingEntryEntity>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        final entry = _decodeEntry(item);
        if (entry != null) {
          entries.add(entry);
        }
      } else if (item is Map) {
        final map = item.map((key, value) => MapEntry(key.toString(), value));
        final entry = _decodeEntry(map);
        if (entry != null) {
          entries.add(entry);
        }
      }
    }

    return entries.take(limit).toList(growable: false);
  }

  Map<String, dynamic> _encodeEntry(FeelingEntryEntity entry) {
    return <String, dynamic>{
      'id': entry.id,
      'feeling': entry.feeling.name,
      'intensity': entry.intensity,
      'createdAt': entry.createdAt.toIso8601String(),
    };
  }

  FeelingEntryEntity? _decodeEntry(Map<String, dynamic> json) {
    final id = json['id']?.toString();
    final feelingRaw = json['feeling']?.toString();
    final intensityRaw = json['intensity'];
    final createdAtRaw = json['createdAt']?.toString();

    if (id == null || feelingRaw == null || createdAtRaw == null) {
      return null;
    }

    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) {
      return null;
    }

    FeelingType? feeling;
    for (final value in FeelingType.values) {
      if (value.name == feelingRaw) {
        feeling = value;
      }
    }
    if (feeling == null) {
      return null;
    }

    final intensity = intensityRaw is int
        ? intensityRaw
        : int.tryParse(intensityRaw?.toString() ?? '3') ?? 3;

    return FeelingEntryEntity(
      id: id,
      feeling: feeling,
      intensity: intensity.clamp(1, 5),
      createdAt: createdAt,
    );
  }
}
