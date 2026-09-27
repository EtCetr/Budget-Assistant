import 'package:drift/drift.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/logger.dart';
import '../app_database.dart';

/// Пресеты государственных праздников РФ (ТОМ 2 §15.2, ТЗ 6.3.8).
///
/// Локальные сиды: is_preset = TRUE, sync_status = 'synced' (не улетают в
/// Supabase). Год даты — опорный 2000: ежегодные праздники матчатся по
/// месяц/день, UI форматирует месяц/день.
class DefaultHolidaysSeed {
  static const List<_Preset> _presets = [
    _Preset('preset_rf_0101', 'Новый год', 1, 1, '🎄'),
    _Preset('preset_rf_0102', 'Новогодние каникулы', 1, 2, '🎄'),
    _Preset('preset_rf_0103', 'Новогодние каникулы', 1, 3, '🎄'),
    _Preset('preset_rf_0104', 'Новогодние каникулы', 1, 4, '🎄'),
    _Preset('preset_rf_0105', 'Новогодние каникулы', 1, 5, '🎄'),
    _Preset('preset_rf_0106', 'Новогодние каникулы', 1, 6, '🎄'),
    _Preset('preset_rf_0107', 'Рождество Христово', 1, 7, '🎄'),
    _Preset('preset_rf_0108', 'Новогодние каникулы', 1, 8, '🎄'),
    _Preset('preset_rf_0223', 'День защитника Отечества', 2, 23, '🎖'),
    _Preset('preset_rf_0308', 'Международный женский день', 3, 8, '🌷'),
    _Preset('preset_rf_0501', 'Праздник Весны и Труда', 5, 1, '🌱'),
    _Preset('preset_rf_0509', 'День Победы', 5, 9, '🎖'),
    _Preset('preset_rf_0612', 'День России', 6, 12, '🇷🇺'),
    _Preset('preset_rf_1104', 'День народного единства', 11, 4, '🤝'),
  ];

  /// Идемпотентный сид: вставляет пресеты, только если их ещё нет.
  static Future<void> seedIfEmpty(AppDatabase db) async {
    try {
      final row = await db.customSelect(
        'SELECT COUNT(*) AS c FROM holidays WHERE is_preset = 1',
      ).getSingle();
      if (row.read<int>('c') > 0) return;
      await db.batch((b) {
        for (final p in _presets) {
          b.insert(
            db.holidays,
            HolidaysCompanion.insert(
              id: p.id,
              name: p.name,
              date: DateTime.utc(2000, p.month, p.day),
              iconEmoji: Value(p.emoji),
              colorHex: const Value('#F59E0B'),
              isPreset: const Value(true),
              isAnnuallyRecurring: const Value(true),
              isEnabled: const Value(true),
              syncStatus: const Value(SyncStatus.synced),
            ),
          );
        }
      });
      AppLogger.i('✅ DefaultHolidaysSeed: ${_presets.length} presets seeded');
    } catch (e, st) {
      AppLogger.e('DefaultHolidaysSeed failed', e, st);
      rethrow;
    }
  }
}

class _Preset {
  const _Preset(this.id, this.name, this.month, this.day, this.emoji);
  final String id;
  final String name;
  final int month;
  final int day;
  final String emoji;
}