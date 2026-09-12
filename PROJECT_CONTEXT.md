# КОНТЕКСТ ПРОЕКТА: Budget Assistant v6.0

## 📌 Иерархия документов
При работе над кодом и архитектурой руководствуйся следующей иерархией:
1. **`DECISIONS.md`** — Конституция проекта. Жёсткие технологические и архитектурные ограничения (IntColumn, E2E, Offline-First, Riverpod, Drift). Приоритет №1.
2. **`ТЗ 6.0`** — Полное техническое задание в 7 Томах. Приоритет №2.
3. **`PROJECT_CONTEXT.md`** (этот файл) — Краткая сводка и навигатор по проекту.

*Примечание: Все эволюционные изменения (Multi-group, Batch-импорт, ML Kit, Year in Review), которые ранее планировались как отдельные фичи, а также базовая логика, уже полностью инкорпорированы и синтезированы в ТЗ 6.0. Отдельных документов для них не существует.*

---

## 🏗 31 Зафиксированное Архитектурное Решение (Шпаргалка)

### Архитектура и Стек
- **Multi-group:** Связь Many-to-Many через `memberships`. Таблица `users` НЕ имеет `space_id`.
- **Секретность:** Режим секретности (подарки) — личная настройка в `app_settings`, а не глобальный свитч админа.
- **Импорт:** ПОЛНЫЙ ОТКАЗ от OpenAPI банков и API Т-Инвестиций. Только Batch-импорт (CSV/XLSX/PDF) + ручной ввод.
- **Платформа:** ТОЛЬКО Android.
- **БД:** `schemaVersion` стартует с `1` (чистая установка).

### Бизнес-логика и Данные
- **Деньги:** Все суммы в `IntColumn` (копейки). Проценты в базисных пунктах.
- **Переводы:** `trusted_counterparties` УДАЛЕНА. Автодетект переводов через алгоритмы (Сценарий А: Межбанк ±3 дня, Сценарий Б: СБП ±5 мин).
- **Конфликты:** `sync_conflicts` — гибрид (диалог для настроек/групп, Last-Write-Wins для транзакций).
- **Инвестиции:** Полностью исключены из P&L (пополнение = `transfer`). Портфель шифруется E2E.
- **Возвраты:** Логика `is_refund` УДАЛЕНА.
- **Кэшбэк:** Считаем только факт трат (NET-сумма с учётом возвратов). Обнуление недельного — Понедельник 00:00.
- **Уведомления:** 27 типов пушей. Все генерируются локально (WorkManager), так как сервер не имеет доступа к E2E-данным.

### UI/UX
- **Dashboard:** Кастомизируемый. FAB быстрых действий перенесён на Экран лога операций.
- **Privacy Matrix:** 3 режима (visible / partial / hidden). Централизованный `PrivacyFormatter`.
- **Empty States:** Обязательны для всех списков. Позитивные (нет долгов) с конфетти.

---

## 🛡 5 ЖЁСТКИХ ПРАВИЛ БИЗНЕС-ЛОГИКИ
1. **Сплит-чеки и Кэшбэк:** UseCase кэшбэка обязан делать JOIN с `transaction_splits`.
2. **Мультивалютность:** Суммы трат приводятся к валюте карты по курсу на дату транзакции.
3. **Переводы:** Жёсткий фильтр `type != 'transfer'` во всех расчётах P&L и лимитов.
4. **Возвраты:** Виджет кэшбэка считает NET-сумму: `SUM(expense) - SUM(income с той же категорией)`.
5. **Часовые пояса:** Циклы рассчитываются строго в локальном часовом поясе (`flutter_timezone`).

---

## 📚 Структура ТЗ 6.0 (Навигатор)
ТЗ 6.0 разбито на 7 Томов. При работе над конкретной фичей подгружай соответствующий Том:
- **ТОМ 1:** Архитектура, Multi-group, Безопасность (E2E, HKDF).
- **ТОМ 2:** База Данных (Полная Схема ~35 таблиц, индексы, E2E-пометки).
- **ТОМ 3:** Безопасность (PIN, Биометрия, FLAG_SECURE, Shake/Face-down).
- **ТОМ 4:** Бизнес-Логика (P&L, Кэшбэк, Лимиты, Прогнозы, Мультивалютность).
- **ТОМ 5:** Уведомления (Матрица 27 пушей, WorkManager, Дайджесты).
- **ТОМ 6:** UI/UX (52+ экрана, Privacy Matrix, Empty States, Экспорт).
- **ТОМ 7:** Синхронизация, Импорт (Batch, OCR), Роутинг, Тестирование.

---

## 🚀 Регламент работы с AI
1. **Один шаг = один коммит.** Не пытайся сгенерировать весь проект за один промпт.
2. **Сначала архитектура/псевдокод,** потом реализация.
3. **Сверяйся с `DECISIONS.md`** перед каждым архитектурным выбором.
4. **Используй `PROJECT_CONTEXT.md`** как быструю шпаргалку, чтобы не перечитывать все 7 томов.
5. **При обнаружении противоречия** в ТЗ 6.0 — приоритет у `DECISIONS.md`. Если противоречие внутри ТЗ 6.0 — приоритет у более позднего Тома (Том 7 > Том 1).

## Known Issues / Долги (актуально после Этапа 8 + микро-коммитов)

### Текущая схема БД
- schemaVersion = 4.
- v4: `transactions.is_large_expense` (Bool, default false) + индекс `idx_transactions_large_expense`.
- `transactions.sync_locked_started_at` / `sync_locked_duration_ms` — монотонные часы (Этап 6).
- `sync_conflicts`: id, entity_type, entity_id, local_value, remote_value, created_at, resolved_at, resolution. Поля `status` НЕТ.
- `sync_logs`: id, user_id, timestamp, status, error_message, entities_synced_count.

### Закрыто
- [x] Auth flow end-to-end (регистрация Supabase, онбординг, PIN, биометрия)
- [x] Персист флага онбординга (onboarding_completed в SecureStorage + bootstrap в main)
- [x] Полные 7 типов счетов в UI создания/редактирования
- [x] CRUD категорий: Update/Delete + дочерние категории
- [x] Update счёта (Edit по тапу)
- [x] **Этап 8: Sync Service** — SyncService + WorkManager (период 1 час, constraint: сеть) + Supabase UPSERT, retry + exponential backoff, pull-to-refresh
- [x] **E2E-шифрование payload** счетов/категорий/транзакций перед Supabase (EncryptionService AES-256-GCM; ключи `enc_key_{space_id}` / `enc_key_personal` в SecureStorage; Supabase url/anon тоже в SecureStorage)
- [x] **Конфликты**: LWW для транзакций (applyRemoteRow + запись в sync_conflicts), `pending_resolution` для счетов/категорий
- [x] **Монотонные часы**: `SystemClock.elapsedRealtime()` через MethodChannel `budget_assistant/clock` (ElapsedRealtimeService); авто-блокировка sync_locked_* для расходов >= `large_transaction_threshold` при `enable_secrecy_mode`
- [x] **«Исключить из учёта (сторно)» ПОЛНОСТЬЮ УДАЛЕНО**: пункты long-press меню, IgnoreTransactionUseCase, RestoreTransactionUseCase, методы репозитория ignore()/restoreFromIgnored(). `AuditStatus.ignored` оставлен в enum, но в UI не используется.
- [x] **Крупные траты (`is_large_expense`)**: long-press «Отметить как крупную трату 💎» / снять пометку; иконка 💎 в TransactionRow; чип-фильтр «Без крупных» (`excludeLargeExpenses`) в логе транзакций. В лимитах по категориям фильтр НЕ применяется (решение владельца).
- [x] **Экран редактирования транзакции**: роут `/transactions/edit/:id`, EditTransactionScreen, long-press «Редактировать»
- [x] Фильтр суммы в логе транзакций считает по модулю `ABS(amount)` (решение владельца)

### Открыто
- [ ] l10n-фундамент: RU как основной язык (flutter_localizations + .arb). Микро-коммит после Этапа 7 — переводить все экраны за один раз.
- [ ] Фильтр `excludeLargeExpenses` применить в аналитике Этапов 9-11 (P&L, Dashboard, Monthly): добавлять `if (filter.excludeLargeExpenses) expressions.add(t.isLargeExpense.equals(false));` в SQL UseCase. В лимитах — НЕ применять.
- [ ] Ручное «Засекретить (Подарок)» сейчас меняет только `is_hidden_by_calendar`; привязка к календарю (holidays) и sync_locked — Этап 14/15.
- [ ] Drag-and-drop сортировка счетов в UI (UseCase UpdateAccountSortOrder готов) — Этап 21
- [ ] Форма создания ипотеки (account_type='mortgage') — Этап 21
- [ ] Авто-создание системных счетов (is_system) — Этап 21
- [ ] enable_biometric_login не персистится в app_settings — Этап 21
- [ ] space_selector: заглушка вместо реального списка пространств — Этап 17/21
- [ ] `onlyDebts`-фильтр в логе транзакций — включится на Этапе 13 (таблица debts)
- [ ] l10n: перевод TransactionsLogLabels в .arb — микро-коммит после Этапа 7
- [ ] `initializeDateFormatting()` + `Intl.defaultLocale = 'ru'` в main — временное решение до l10n-микро-коммита
- [ ] Продуктовое решение: сегмент «Семейные» = все транзакции активного пространства; «только члены семьи» = чип «Без моих». Отклонение от ТЗ 6.3.2.3 согласовано владельцем.
- [ ] Миграция onUpgrade: ветка `from < 2` с DROP TABLE всех таблиц — историческая мина (Этап 3/5). На v4+ не срабатывает, удалить при следующем bump schemaVersion (Этап 9+).
- [ ] workmanager 0.7.0 применяет KGP — warning о будущем Flutter; мониторить релизы плагина (Built-in Kotlin).
- [ ] Эмулятор dev-среды: internal storage 10 GB, после wipe данные стабильны; полный `flutter run` безопасен, основной workflow — hot reload/restart.