import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// РўР°Р±Р»РёС†С‹ РёР· Р­С‚Р°РїР° 3 (С„СѓРЅРґР°РјРµРЅС‚Р°Р»СЊРЅС‹Рµ СЃСѓС‰РЅРѕСЃС‚Рё)
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
import 'tables/users.dart';
import 'tables/spaces.dart';
import 'tables/memberships.dart';
import 'tables/app_settings.dart';
import 'tables/notifications.dart';
import 'tables/sync_conflicts.dart';
import 'tables/sync_logs.dart';

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Enum'С‹ Р­С‚Р°РїР° 6 (type, audit_status, sync_status)
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
import 'package:budget_assistant/core/enums/transaction_enums.dart';

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// DAO (Data Access Objects) вЂ” С‚РёРїРѕР±РµР·РѕРїР°СЃРЅС‹Рµ Р·Р°РїСЂРѕСЃС‹
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
import 'daos/users_dao.dart';
import 'daos/spaces_dao.dart';
import 'daos/memberships_dao.dart';
import 'daos/app_settings_dao.dart';
import 'daos/notifications_dao.dart';
import 'daos/sync_conflicts_dao.dart';
import 'daos/sync_logs_dao.dart';
import 'daos/budget_limits_dao.dart';

import 'package:budget_assistant/core/logger.dart';

part 'app_database.g.dart';

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// РўР°Р±Р»РёС†С‹ РёР· Р­С‚Р°РїР° 5 (СѓР¶Рµ СЂРµР°Р»РёР·РѕРІР°РЅС‹, РѕСЃС‚Р°СЋС‚СЃСЏ Р·РґРµСЃСЊ)
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get bankName => text()();
  TextColumn get customName => text()();
  TextColumn get cardNumberMask => text().nullable()();
  TextColumn get accountType => text()();
  TextColumn get currency => text()();
  IntColumn get currentBalance => integer()();
  IntColumn get creditLimit => integer().nullable()();
  DateTimeColumn get gracePeriodEnd => dateTime().nullable()();
  IntColumn get minPaymentAmount => integer().nullable()();
  BoolColumn get includeInPersonalBalance =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get includeInFamilyBalance =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSharedBalance =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSharedExpenses =>
      boolean().withDefault(const Constant(false))();
  TextColumn get expenseDetailLevel =>
      text().withDefault(const Constant('total_only'))();
  BoolColumn get isSharedIncomes =>
      boolean().withDefault(const Constant(false))();
  TextColumn get incomeDetailLevel =>
      text().withDefault(const Constant('total_only'))();
  IntColumn get sortOrder => integer().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Mortgages extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id).unique()();
  IntColumn get initialLoanAmount => integer()();
  IntColumn get propertyValue => integer()();
  IntColumn get interestRateBps => integer()();
  IntColumn get remainingTermMonths => integer()();
  IntColumn get monthlyPayment => integer()();
  DateTimeColumn get nextPaymentDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get iconEmoji => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  BoolColumn get isPinnedForCashback =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryRules extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get bankName => text()();
  TextColumn get triggerString => text()();
  TextColumn get targetCategoryId => text().references(Categories, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Р­РўРђРџ 6: РўР°Р±Р»РёС†Р° С‚СЂР°РЅР·Р°РєС†РёР№
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
@DataClassName('TransactionDb')
class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get linkedAccountId =>
      text().nullable().references(Accounts, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get originalSpaceId => text().nullable().references(Spaces, #id)();
  TextColumn get bankTransactionId => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get amount => integer()();
  TextColumn get originalCurrency => text().nullable()();
  IntColumn get originalAmount => integer().nullable()();
  TextColumn get type => textEnum<TransactionType>()();
  TextColumn get bankCategory => text().nullable()();
  TextColumn get customCategoryId =>
      text().nullable().references(Categories, #id)();
  TextColumn get merchantName => text().nullable()();
  TextColumn get comment => text().nullable()();
  BoolColumn get isUserEdited => boolean().withDefault(const Constant(false))();
  TextColumn get auditStatus =>
      textEnum<AuditStatus>().withDefault(const Constant('verified'))();
  BoolColumn get isHiddenByCalendar =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get hiddenUntilDate => dateTime().nullable()();
  IntColumn get syncLockedStartedAt => integer().nullable()();
  IntColumn get syncLockedDurationMs => integer().nullable()();
  BoolColumn get isArchivedForSpace =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get businessMirror =>
      boolean().withDefault(const Constant(false))();
  TextColumn get savingsGoalId => text().nullable()();
  BoolColumn get isWithdrawal => boolean().withDefault(const Constant(false))();
  BoolColumn get isSplit => boolean().withDefault(const Constant(false))();
  TextColumn get receiptId => text().nullable()();
  BoolColumn get isLargeExpense =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Р­РўРђРџ 6: РЎРїР»РёС‚С‹ С‡РµРєР°/РґРѕР»РіР°
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
@DataClassName('TransactionSplitDb')
class TransactionSplits extends Table {
  TextColumn get id => text()();
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  IntColumn get amount => integer()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Р­РўРђРџ 9: Р‘СЋРґР¶РµС‚РЅС‹Рµ Р»РёРјРёС‚С‹ РїРѕ РєР°С‚РµРіРѕСЂРёСЏРј
//
// РЈРЅРёРєР°Р»СЊРЅС‹Р№ РєРѕРЅСЃС‚СЂРµР№РЅС‚: (space_id, user_id, category_id, year, month)
// Р”РµРЅСЊРіРё: IntColumn (РєРѕРїРµР№РєРё), E2E-С€РёС„СЂРѕРІР°РЅРёРµ limit_amount Рё alert_amount
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
@DataClassName('BudgetLimitDb')
class BudgetLimits extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get categoryId => text().references(Categories, #id)();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get limitAmount => integer()();
  IntColumn get alertPercent => integer().withDefault(const Constant(80))();
  IntColumn get alertAmount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// РћСЃРЅРѕРІРЅР°СЏ РєРѕРЅС„РёРіСѓСЂР°С†РёСЏ Р‘Р”
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Р­РўРђРџ 10: РљСѓСЂСЃС‹ РІР°Р»СЋС‚ (РјСѓР»СЊС‚РёРІР°Р»СЋС‚РЅРѕСЃС‚СЊ, РўРћРњ 2 В§18.2)
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
@DataClassName('ExchangeRateDb')
class ExchangeRates extends Table {
  TextColumn get id => text()();
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  DateTimeColumn get date => dateTime()();
  // РњСѓР»СЊС‚РёРїР»РёРєР°С‚РѕСЂ (РЅРµ РґРµРЅСЊРіРё).
  RealColumn get rate => real()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
// Р­РўРђРџ 10: РњР°С‚СЂРёС†Р° РєСЌС€Р±СЌРєР° РїРѕ РєР°СЂС‚Р°Рј (РўРћРњ 2 В§14.3)
// в•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђв•ђ
@DataClassName('CashbackMatrixDb')
class CashbackMatrix extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().references(Accounts, #id)();
  // РџСЂРёРІСЏР·РєР° Рє Р»РѕРєР°Р»СЊРЅРѕР№ РєР°С‚РµРіРѕСЂРёРё РґР»СЏ СЂР°СЃС‡С‘С‚Р° NET-СЃСѓРјРјС‹ (РўРћРњ 4 РџСЂР°РІРёР»Рѕ 1).
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  // РќР°Р·РІР°РЅРёРµ РєР°С‚РµРіРѕСЂРёРё Р±Р°РЅРєР° (РІ Supabase С€РёС„СЂСѓРµС‚СЃСЏ [E2E]).
  TextColumn get categoryName => text()();
  IntColumn get percentBps => integer()();
  TextColumn get status => text().withDefault(const Constant('potential'))();
  TextColumn get lifetimeType => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus =>
      textEnum<SyncStatus>().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
class DashboardWidgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get widgetType => text()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}
@DriftDatabase(
  tables: [
    // Р­С‚Р°Рї 3: Р¤СѓРЅРґР°РјРµРЅС‚Р°Р»СЊРЅС‹Рµ СЃСѓС‰РЅРѕСЃС‚Рё
    Users,
    Spaces,
    Memberships,
    AppSettings,
    Notifications,
    SyncConflicts,
    SyncLogs,
    // Р­С‚Р°Рї 5: РЎС‡РµС‚Р°, РёРїРѕС‚РµРєРё, РєР°С‚РµРіРѕСЂРёРё
    Accounts,
    Mortgages,
    Categories,
    CategoryRules,
    // Р­С‚Р°Рї 6: РўСЂР°РЅР·Р°РєС†РёРё Рё СЃРїР»РёС‚С‹
    Transactions,
    TransactionSplits,
    // Р­С‚Р°Рї 9: Р‘СЋРґР¶РµС‚РЅС‹Рµ Р»РёРјРёС‚С‹
    BudgetLimits,
    // Р­С‚Р°Рї 10: РљСЌС€Р±СЌРє Рё РєСѓСЂСЃС‹ РІР°Р»СЋС‚
    ExchangeRates,
    CashbackMatrix,
    DashboardWidgets,
  ],
  daos: [
    UsersDao,
    SpacesDao,
    MembershipsDao,
    AppSettingsDao,
    NotificationsDao,
    SyncConflictsDao,
    SyncLogsDao,
    BudgetLimitsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase._internal() : super(_openConnection());

  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;

  AppDatabase.forTesting(super.e);
  AppDatabase.forBackground(super.e);

  /// v1: СЃС‚Р°СЂС‚ (Р­С‚Р°Рї 3)
  /// v2: РјРёРіСЂР°С†РёСЏ SyncableTable (Р­С‚Р°Рї 3/5) вЂ” РРЎРўРћР РР§Р•РЎРљРђРЇ РњРРќРђ, СѓРґР°Р»РµРЅР° РІ v5
  /// v3: Р­С‚Р°Рї 6 вЂ” С‚Р°Р±Р»РёС†С‹ transactions Рё transaction_splits
  /// v4: Р­С‚Р°Рї 8+ вЂ” РїРѕР»Рµ is_large_expense
  /// v5: Р­С‚Р°Рї 9 вЂ” С‚Р°Р±Р»РёС†Р° budget_limits + РёРЅРґРµРєСЃС‹
  @override
  int get schemaVersion => 8;

  Future<void> _createAllIndexes() async {
    // РРќР”Р•РљРЎР« Р”Р›РЇ Р­РўРђРџРђ 3
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_memberships_user
      ON memberships(user_id, status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_memberships_space
      ON memberships(space_id, status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_app_settings_user
      ON app_settings(user_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_notifications_user_read
      ON notifications(user_id, is_read, created_at DESC)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_notifications_space
      ON notifications(space_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_conflicts_unresolved
      ON sync_conflicts(entity_type, entity_id)
      WHERE resolved_at IS NULL
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_logs_user_timestamp
      ON sync_logs(user_id, timestamp DESC)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_sync_logs_status
      ON sync_logs(status)
    ''');

    // РРќР”Р•РљРЎР« Р”Р›РЇ Р­РўРђРџРђ 5
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_accounts_user_space
      ON accounts(user_id, space_id, sync_status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_accounts_type
      ON accounts(account_type)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_mortgages_account
      ON mortgages(account_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_space_user
      ON categories(space_id, user_id, type)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_categories_parent
      ON categories(parent_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_category_rules_space_bank
      ON category_rules(space_id, bank_name)
    ''');

    // РРќР”Р•РљРЎР« Р”Р›РЇ Р­РўРђРџРђ 6
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_user_space_date
      ON transactions(user_id, space_id, date)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_date
      ON transactions(date)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_account_category
      ON transactions(account_id, custom_category_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_sync_status
      ON transactions(sync_status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_audit_status
      ON transactions(audit_status)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_savings_goal
      ON transactions(savings_goal_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transactions_large_expense
      ON transactions(is_large_expense)
    ''');
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_transactions_bank_tx_id
      ON transactions(bank_transaction_id)
      WHERE bank_transaction_id IS NOT NULL
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_transaction
      ON transaction_splits(transaction_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_transaction_splits_sync_status
      ON transaction_splits(sync_status)
    ''');

    // РРќР”Р•РљРЎР« Р”Р›РЇ Р­РўРђРџРђ 9 (budget_limits)
    // РЈРЅРёРєР°Р»СЊРЅС‹Р№ РєРѕРЅСЃС‚СЂРµР№РЅС‚: РѕРґРёРЅ Р»РёРјРёС‚ РЅР° РєР°С‚РµРіРѕСЂРёСЋ РІ РјРµСЃСЏС†
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_budget_limits_unique
      ON budget_limits(space_id, user_id, category_id, year, month)
    ''');
    // РџРѕРёСЃРє Р»РёРјРёС‚РѕРІ РїРѕ РєР°С‚РµРіРѕСЂРёРё
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_budget_limits_category
      ON budget_limits(category_id)
    ''');
    // Pending-Р»РёРјРёС‚С‹ РґР»СЏ СЃРёРЅС…СЂРѕРЅРёР·Р°С†РёРё
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_budget_limits_sync_status
      ON budget_limits(sync_status)
    ''');
    // Р¤РёР»СЊС‚СЂР°С†РёСЏ РїРѕ РїРѕР»СЊР·РѕРІР°С‚РµР»СЋ Рё РїСЂРѕСЃС‚СЂР°РЅСЃС‚РІСѓ
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_budget_limits_user_space
      ON budget_limits(user_id, space_id)
    ''');
    // РРќР”Р•РљРЎР« Р”Р›РЇ Р­РўРђРџРђ 10 (РєСЌС€Р±СЌРє + РєСѓСЂСЃС‹ РІР°Р»СЋС‚)
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_exchange_rates_unique
      ON exchange_rates(from_currency, to_currency, date)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_cashback_matrix_account
      ON cashback_matrix(account_id, expires_at)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_cashback_matrix_sync_status
      ON cashback_matrix(sync_status)
    ''');

  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createAllIndexes();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // РРЎРўРћР РР§Р•РЎРљРђРЇ РњРРќРђ РЈР”РђР›Р•РќРђ: РІРµС‚РєР° from < 2 СЃ DROP TABLE
      // Р±РѕР»СЊС€Рµ РЅРµ РЅСѓР¶РЅР°, С‚.Рє. СЃС…РµРјР° СЃС‚Р°Р±РёР»РёР·РёСЂРѕРІР°РЅР° РЅР° v4+
      if (from < 3) {
        await m.createTable(transactions);
        await m.createTable(transactionSplits);
        await _createAllIndexes();
      }
      if (from < 4) {
        await customStatement(
          'ALTER TABLE transactions '
          'ADD COLUMN is_large_expense INTEGER NOT NULL DEFAULT 0',
        );
        await customStatement(
          'CREATE INDEX IF NOT EXISTS idx_transactions_large_expense '
          'ON transactions(is_large_expense)',
        );
      }
      if (from < 5) {
        // Р­РўРђРџ 9: СЃРѕР·РґР°С‘Рј С‚Р°Р±Р»РёС†Сѓ budget_limits
        await m.createTable(budgetLimits);
        // РЎРѕР·РґР°С‘Рј РёРЅРґРµРєСЃС‹ РґР»СЏ budget_limits
        await customStatement('''
              CREATE UNIQUE INDEX IF NOT EXISTS idx_budget_limits_unique
              ON budget_limits(space_id, user_id, category_id, year, month)
            ''');
        await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_budget_limits_category
              ON budget_limits(category_id)
            ''');
        await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_budget_limits_sync_status
              ON budget_limits(sync_status)
            ''');
        await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_budget_limits_user_space
              ON budget_limits(user_id, space_id)
            ''');
      }
    
        if (from < 6) {
          // Р­РўРђРџ 10: РєСЌС€Р±СЌРє + РјСѓР»СЊС‚РёРІР°Р»СЋС‚РЅРѕСЃС‚СЊ
          await m.createTable(exchangeRates);
          await m.createTable(cashbackMatrix);
          await customStatement('''
            CREATE UNIQUE INDEX IF NOT EXISTS idx_exchange_rates_unique
            ON exchange_rates(from_currency, to_currency, date)
          ''');
          await customStatement('''
            CREATE INDEX IF NOT EXISTS idx_cashback_matrix_account
            ON cashback_matrix(account_id, expires_at)
          ''');
          await customStatement('''
            CREATE INDEX IF NOT EXISTS idx_cashback_matrix_sync_status
            ON cashback_matrix(sync_status)
          ''');
        }
        if (from < 8) {
          // Stage 11 fix: v7 migration was nested incorrectly and
          // dashboard_widgets may be missing on upgraded devices.
          final dashboardTableExists = await customSelect(
            "SELECT COUNT(*) AS c FROM sqlite_master "
            "WHERE type='table' AND name='dashboard_widgets'",
          ).getSingle();
          if (dashboardTableExists.read<int>('c') == 0) {
            await m.createTable(dashboardWidgets);
          }
          await customStatement('''
CREATE UNIQUE INDEX IF NOT EXISTS idx_dashboard_widgets_user_type
ON dashboard_widgets(user_id, widget_type)
        ''');
          await customStatement('''
CREATE INDEX IF NOT EXISTS idx_dashboard_widgets_sync_status
ON dashboard_widgets(sync_status)
        ''');
        }
},
    beforeOpen: (details) async {
      AppLogger.i(
        'рџ”§ Migration details: wasCreated=${details.wasCreated}, hadUpgrade=${details.hadUpgrade}, versionNow=${details.versionNow}, versionBefore=${details.versionBefore}',
      );
      await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('CREATE UNIQUE INDEX IF NOT EXISTS idx_dashboard_widgets_user_type ON dashboard_widgets(user_id, widget_type)');
          await customStatement('CREATE INDEX IF NOT EXISTS idx_dashboard_widgets_sync_status ON dashboard_widgets(sync_status)');
      await customStatement('PRAGMA journal_mode = WAL');
      await customStatement('PRAGMA synchronous = NORMAL');
      final tables = await customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
      ).get();
      AppLogger.i(
        'рџ“‹ Tables in DB: ${tables.map((r) => r.read<String>('name')).join(', ')}',
      );
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'budget_assistant.sqlite');
    AppLogger.i('рџ“Ѓ DB Path: $dbPath');
    AppLogger.i(
      'рџ“‚ Directory exists: ${await Directory(dbFolder.path).exists()}',
    );
    final fileExists = await File(dbPath).exists();
    AppLogger.i('рџ’ѕ DB file exists before open: $fileExists');
    return NativeDatabase(File(dbPath));
  });
}
