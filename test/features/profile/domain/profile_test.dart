import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/profile/domain/models/user_dto.dart';
import 'package:budget_assistant/features/profile/domain/usecases/update_profile_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: профиль (ТЗ 6.3.39.3). display_name / display_name_dative — [E2E]
/// при синке; avatar_path — [LOCAL], не синхронизируется.
///
/// updated_at: Drift хранит DateTime с точностью до СЕКУНД, а сид и правка
/// выполняются в пределах одной секунды. Поэтому базовое значение задаётся
/// явно (2020 год) — сдвиг виден при любой гранулярности и часовом поясе.
void main() {
  group('UserDto', () {
    test('JSON round-trip сохраняет все поля', () {
      final dto = UserDto(
        id: 'u1',
        email: 'a@b.c',
        displayName: 'Иван',
        displayNameDative: 'Ивану',
        avatarUrl: 'https://x/y.png',
        avatarPath: '/local/a.jpg',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 7, 1),
        syncStatus: 'pending',
      );

      final restored = UserDto.fromJson(dto.toJson());

      expect(restored, dto);
    });

    test('необязательные поля остаются null', () {
      final dto = UserDto(
        id: 'u1',
        email: 'a@b.c',
        displayName: 'Иван',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
        syncStatus: 'synced',
      );

      final restored = UserDto.fromJson(dto.toJson());

      expect(restored.displayNameDative, isNull);
      expect(restored.avatarUrl, isNull);
      expect(restored.avatarPath, isNull);
    });
  });

  final skip = sqliteSkipReason();

  group('UpdateProfileUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late UpdateProfileUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.user(kUserId);
      useCase = UpdateProfileUseCase(db: db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<DateTime> readUpdatedAt() async {
      final row = await (db.select(db.users)
            ..where((t) => t.id.equals(kUserId)))
          .getSingle();
      return row.updatedAt;
    }

    test('имя и дательный падеж обновляются, запись уходит в pending',
        () async {
      await useCase(
        userId: kUserId,
        displayName: 'Иван Петров',
        displayNameDative: 'Ивану Петрову',
      );

      final row = await (db.select(db.users)
            ..where((t) => t.id.equals(kUserId)))
          .getSingle();
      expect(row.displayName, 'Иван Петров');
      expect(row.displayNameDative, 'Ивану Петрову');
      expect(row.syncStatus, 'pending');
    });

    test('avatarPath = null не трогает существующий аватар', () async {
      await useCase(
        userId: kUserId,
        displayName: 'Иван',
        displayNameDative: 'Ивану',
        avatarPath: '/local/a.jpg',
      );

      await useCase(
        userId: kUserId,
        displayName: 'Иван Новый',
        displayNameDative: 'Ивану Новому',
      );

      final row = await (db.select(db.users)
            ..where((t) => t.id.equals(kUserId)))
          .getSingle();
      expect(row.avatarPath, '/local/a.jpg');
      expect(row.displayName, 'Иван Новый');
    });

    test('clearAvatar обнуляет локальный аватар', () async {
      await useCase(
        userId: kUserId,
        displayName: 'Иван',
        displayNameDative: 'Ивану',
        avatarPath: '/local/a.jpg',
      );

      await useCase(
        userId: kUserId,
        displayName: 'Иван',
        displayNameDative: 'Ивану',
        clearAvatar: true,
      );

      final row = await (db.select(db.users)
            ..where((t) => t.id.equals(kUserId)))
          .getSingle();
      expect(row.avatarPath, isNull);
    });

    test('updated_at сдвигается вперёд (важно для LWW-синка)', () async {
      final old = DateTime.utc(2020, 1, 1);
      await (db.update(db.users)..where((t) => t.id.equals(kUserId)))
          .write(UsersCompanion(updatedAt: Value(old)));
      expect(await readUpdatedAt(), isNotNull);

      await useCase(
        userId: kUserId,
        displayName: 'Иван',
        displayNameDative: 'Ивану',
      );

      final after = await readUpdatedAt();
      expect(
        after.isAfter(old),
        isTrue,
        reason: 'правка профиля обязана обновлять updated_at',
      );
    });
  }, skip: skip);
}