import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/auth/domain/usecases/delete_account_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

class _MockStorage extends Mock implements SecureStorageService {}

/// Этап 24: локальное удаление аккаунта (ТЗ 6.3.39.7, D21-29).
/// Стирается вся локальная БД и SecureStorage; signOut выполняет экран.
/// Серверное удаление (RPC) — TODO(25).
void main() {
  final skip = sqliteSkipReason();

  group('DeleteAccountUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late _MockStorage storage;
    late DeleteAccountUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.tx(id: 't1', amountKopecks: 1000, categoryId: 'c1');
      storage = _MockStorage();
      when(() => storage.deleteAll()).thenAnswer((_) async {});
      useCase = DeleteAccountUseCase(db: db, storage: storage);
    });

    tearDown(() async {
      await db.close();
    });

    test('wipe очищает транзакции, счета, категории и пользователей',
        () async {
      await useCase();

      expect(await db.select(db.transactions).get(), isEmpty);
      expect(await db.select(db.accounts).get(), isEmpty);
      expect(await db.select(db.categories).get(), isEmpty);
      expect(await db.select(db.users).get(), isEmpty);
      verify(() => storage.deleteAll()).called(1);
    });

    test('повторный вызов идемпотентен', () async {
      await useCase();

      await useCase();

      expect(await db.select(db.transactions).get(), isEmpty);
      verify(() => storage.deleteAll()).called(2);
    });

    test('ошибка SecureStorage пробрасывается', () async {
      when(() => storage.deleteAll()).thenThrow(Exception('keystore down'));

      await expectLater(useCase(), throwsA(isA<Exception>()));
    });
  }, skip: skip);
}