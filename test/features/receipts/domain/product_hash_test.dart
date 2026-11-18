import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/receipts/domain/services/product_hash_util.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/hash_product_name_usecase.dart';

/// Этап 24: product_hash = SHA-256(lowercase(trim(name))) — ТЗ 6.3.24.12.4.
/// Открытый ключ группировки покупок без расшифровки E2E-имени.
void main() {
  late HashProductNameUseCase useCase;

  setUp(() {
    useCase = HashProductNameUseCase();
  });

  test('хэш детерминирован', () {
    expect(ProductHashUtil.hash('молоко'), ProductHashUtil.hash('молоко'));
  });

  test('регистр не влияет на хэш', () {
    expect(ProductHashUtil.hash('МОЛОКО'), ProductHashUtil.hash('молоко'));
  });

  test('пробелы по краям обрезаются', () {
    expect(
      ProductHashUtil.hash('  молоко  '),
      ProductHashUtil.hash('молоко'),
    );
  });

  test('разные имена дают разные хэши', () {
    expect(
      ProductHashUtil.hash('молоко'),
      isNot(ProductHashUtil.hash('хлеб')),
    );
  });

  test('хэш — 64 hex-символа', () {
    final h = ProductHashUtil.hash('молоко');
    expect(h.length, 64);
    expect(RegExp(r'^[0-9a-f]{64}$').hasMatch(h), isTrue);
  });

  test('UseCase и утилита дают одинаковый результат', () {
    expect(useCase('  МОЛОКО  '), ProductHashUtil.hash('молоко'));
  });

  test('внутренние пробелы значимы (схлопывания нет)', () {
    expect(
      ProductHashUtil.hash('молоко 1'),
      isNot(ProductHashUtil.hash('молоко1')),
    );
    expect(
      ProductHashUtil.hash('молоко  1'),
      isNot(ProductHashUtil.hash('молоко 1')),
    );
  });
}