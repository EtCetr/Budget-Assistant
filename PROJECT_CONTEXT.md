КОНТЕКСТ ПРОЕКТА: Budget Assistant v6.0
Навигатор по проекту. Обновлено: Этап 12 в работе (микро-коммиты 12.1–12.5 готовы).

📌 Иерархия документов
1. DECISIONS.md — Конституция проекта. Жёсткие ограничения (IntColumn, E2E, Offline-First, Riverpod, Drift). Приоритет №1.
2. ТЗ 6.0 — Полное техническое задание в 7 Томах. Приоритет №2.
3. PROJECT_CONTEXT.md (этот файл) — Краткая сводка и навигатор. Приоритет №3.
4. AI_RULES.md — Правила взаимодействия с ИИ (сбор контекста одной командой, правки одним скриптом, UTF8 без BOM).
Примечание: все эволюционные изменения (Multi-group, Batch-импорт, ML Kit, Year in Review) полностью инкорпорированы в ТЗ 6.0. Отдельных документов для них не существует.

🏗 31 Зафиксированное Архитектурное Решение (Шпаргалка)
Архитектура и Стек
- Multi-group: Связь Many-to-Many через memberships. Таблица users НЕ имеет space_id.
- Секретность: Режим секретности (подарки) — личная настройка в app_settings, а не глобальный свитч админа.
- Импорт: ПОЛНЫЙ ОТКАЗ от OpenAPI банков и API Т-Инвестиций. Только Batch-импорт (CSV/XLSX/PDF) + ручной ввод.
- Платформа: ТОЛЬКО Android.
- БД: schemaVersion стартует с 1 (чистая установка).
Бизнес-логика и Данные
- Деньги: Все суммы в IntColumn (копейки). Проценты в базисных пунктах.
- Переводы: trusted_counterparties УДАЛЕНА. Автодетект переводов через алгоритмы (Сценарий А: Межбанк ±3 дня, Сценарий Б: СБП ±5 мин).
- Конфликты: sync_conflicts — гибрид (диалог для настроек/групп, Last-Write-Wins для транзакций).
- Инвестиции: Полностью исключены из P&L (пополнение = transfer). Портфель шифруется E2E.
- Возвраты: Логика is_refund УДАЛЕНА.
- Кэшбэк: Считаем только факт трат (NET-сумма с учётом возвратов). Обнуление недельного — Понедельник 00:00.
- Уведомления: 27 типов пушей. Все генерируются локально (WorkManager), сервер не имеет доступа к E2E-данным.
UI/UX
- Dashboard: Кастомизируемый. FAB быстрых действий перенесён на Экран лога операций.
- Privacy Matrix: 3 режима (visible / partial / hidden). Централизованный PrivacyFormatter.
- Empty States: Обязательны для всех списков. Позитивные (нет долгов) с конфетти.

🛡 5 ЖЁСТКИХ ПРАВИЛ БИЗНЕС-ЛОГИКИ
1. Сплит-чеки и Кэшбэк: UseCase кэшбэка обязан делать JOIN с transaction_splits.
2. Мультивалютность: Суммы трат приводятся к валюте карты по курсу на дату транзакции.
3. Переводы: Жёсткий фильтр type != 'transfer' во всех расчётах P&L и лимитов.
4. Возвраты: NET = SUM(expense) - SUM(income с той же категорией).
5. Часовые пояса: Циклы в локальном часовом поясе (ПН 00:00 / 1-е число 00:00; в БД — UTC).

📚 Структура ТЗ 6.0 (Навигатор)
ТОМ 1: Архитектура, Multi-group, Безопасность (E2E, HKDF).
ТОМ 2: База Данных (Полная Схема ~35 таблиц, индексы, E2E-пометки).
ТОМ 3: Безопасность (PIN, Биометрия, FLAG_SECURE, Shake/Face-down).
ТОМ 4: Бизнес-Логика (P&L, Кэшбэк, Лимиты, Прогнозы, Мультивалютность).
ТОМ 5: Уведомления (Матрица 27 пушей, WorkManager, Дайджесты).
ТОМ 6: UI/UX (52+ экрана, Privacy Matrix, Empty States, Экспорт).
ТОМ 7: Синхронизация, Импорт (Batch, OCR), Роутинг, Тестирование.

🚀 Регламент работы с AI
1. Один шаг = один коммит. Не пытаться сгенерировать весь проект за один промпт.
2. Сначала архитектура/псевдокод, потом реализация.
3. Сверяться с DECISIONS.md перед каждым архитектурным выбором.
4. Использовать PROJECT_CONTEXT.md как быструю шпаргалку, чтобы не перечитывать все 7 томов.
5. При противоречии в ТЗ 6.0 — приоритет у DECISIONS.md; внутри ТЗ — у более позднего Тома (Том 7 > Том 1).

🧭 Статус этапов
Этапы 1–11: завершены (детали — в архиве «Закрыто»).
Этап 12 «Savings Goals»: В РАБОТЕ.
  Готово:
  [x] 12.1 Data: таблицы savings_goals / savings_goal_drafts (schemaVersion 9), Freezed-сущности, DAO, репозиторий.
  [x] 12.2 Domain: 19 UseCases + SavingsGoalProgressPort + провайдеры.
  [x] 12.3 Интеграция: CreateTransactionUseCase двигает прогресс через порт; getTransactionsByGoalId; фикс smoke-теста.
  [x] 12.4 Экран целей: вкладки Активные/Архив, мультивалютная сводка, фильтры (тип + тумблер дедлайна), карточки, листы пополнения/изъятия, long-press меню, конфетти (кроме hidden), empty states, privacy.
  [x] 12.5 Форма создания/редактирования: секции, эмодзи, пикер счёта (BottomSheet с балансами), автосейв черновика (5 сек) + восстановление, live-предпросмотр плана, privacy.
  Не сделано:
  [ ] 12.6 Архив: BottomSheet «История цели» (fl_chart график накопления + список транзакций) + кнопка «📜 История» на карточке архива.
  [ ] 12.7 SavingsAnalyticsScreen (/savings-analytics): период-селектор, Summary Grid 2×2, график накопления + прогноз, сортируемая таблица целей, валютный баннер, иконка 📊 в AppBar SavingsGoalsScreen.
  [ ] 12.8 Экспорт аналитики: XLSX + CSV + PNG + PDF (зависимости excel/pdf/share_plus; PNG через RepaintBoundary без доп. пакета).
  [ ] 12.9 Lottie: заменить 9 заглушек на рабочие анимации (confetti, celebration, empty_piggy, empty_box, search, pause_savings, broken_chart, empty_wallet, lonely_silhouette).
  [ ] 12.10 Финал: обновление PROJECT_CONTEXT.md + DECISIONS.md + коммит этапа.

🗄 Текущая схема БД
schemaVersion = 9.
v4: transactions.is_large_expense; sync_locked_started_at / sync_locked_duration_ms (монотонные часы); sync_conflicts; sync_logs.
v5 (Этап 9): budget_limits + уникальный индекс (space_id, user_id, category_id, year, month) + индексы.
v6 (Этап 10): exchange_rates (уникальный индекс from_currency + to_currency + date); cashback_matrix + индексы.
v7 (Этап 11): dashboard_widgets + уникальный idx_dashboard_widgets_user_type.
v8 (Этап 11, фикс): идемпотентная фикс-миграция dashboard_widgets.
v9 (Этап 12): savings_goals (name/target_amount/current_amount/draft_amount — E2E; auto_reminder_enabled default TRUE; status; is_archived; completed_at) + savings_goal_drafts (локальная, без sync) + индексы (user_id, space_id, status, deadline, sync_status; sync_status; drafts user_id, updated_at).
Деньги — ТОЛЬКО IntColumn (копейки). Даты — ТОЛЬКО UTC.

💰 Справка по механикам Этапа 10
(без изменений: цепочка курса ЦБ, NET-кэшбэк, матрица выгоды, статусы potential/approved, семейные скоупы.)

🖥 Справка по механикам Этапа 11 (Dashboard)
(без изменений: раскладка dashboard_widgets, SpaceSelector, PrivacyToggle, тёмная тема, Drawer.)
Изменение Этапа 12: виджет «Движение расходов» — окно 30 дней (владелец вернул месячное), только расходы, БЕЗ линии доходов (решение владельца).

🎯 Справка по механикам Этапа 12 (Savings Goals)
- current_amount меняется ТОЛЬКО через UpdateSavingsGoalProgressUseCase / SavingsGoalProgressPort; порт вызывает CreateTransactionUseCase при создании транзакции с savings_goal_id != null.
- Пополнение = транзакция type='expense' + savings_goal_id; изъятие = type='income' + is_withdrawal=TRUE (исключены из P&L и Total Income).
- draft_amount обновляется при пополнении (автоподстановка последней суммы кнопкой «Подставить»).
- Фильтры активных: тип (Все/Виртуальные/Привязанные) одиночный выбор, повторный тап сбрасывает в «Все»; «С дедлайном» — независимый тумблер, комбинируется с типом (решение владельца).
- Черновик формы: автосейв каждые 5 сек в savings_goal_drafts; восстановление если младше 24 ч; удаляется после успешного сохранения (markSaved + deleteDraftByUser).
- Privacy: суммы/названия через PrivacyFormatter; процент и конфетти скрыты в hidden; экспорт (12.8) будет заблокирован в hidden.
- Достижение цели: конфетти + диалог «Отметить завершённой / Продолжить копить»; completed_at ставится только через CompleteSavingsGoalUseCase (одноразовое конфетти).
- Выбор счёта в форме и в листах пополнения/изъятия: BottomSheet-пикер с балансами счетов (privacy-aware), вместо DropdownButton.
- Виртуальная цель: пополнение всегда expense с выбранного счёта (не transfer).

🔧 Журнал фиксов Этапа 12
1. drift orderBy: нужны лямбды ((g) => OrderingTerm...) — исправлено в DAO.
2. savings_goals_repository_impl: добавлены импорты AppDatabase, SyncStatus.
3. Smoke-тест Этапа 6: в FakeTransactionsRepository добавлен getTransactionsByGoalId.
4. Riverpod 3: AsyncValue.valueOrNull удалён → заменён на .value во всех провайдерах/экранах копилок.
5. create_savings_goal_screen: добавлены недостающие импорты провайдеров usecase.
6. use_build_context_synchronously: long-press меню читает UseCase ДО закрытия шита; ScaffoldMessenger захватывается до await.
7. Кэшбэк-карточка RenderFlex overflow 38px: чипы перенесены в Wrap.
8. DropdownButton: параметра enabled нет → блокировка валюты через onChanged: null.
9. const [MoneyTextInputFormatter()] → [MoneyTextInputFormatter()] (конструктор не const).
10. Черновик удаляется после успешного сохранения цели (ранее воскресал).
11. Фильтры и компактные empty-состояния приведены к решениям владельца (см. отклонения).

👥 Семьи (Multi-group) — текущая реализация
(без изменений: spaces + memberships, currentSpaceIdProvider, семантика «Семейные», кэшбэк-скоупы.)
ДОБАВЛЕНО: создание семейного (shared) счёта в UI НЕ готово: диалог счёта не выставляет space_id / is_shared_balance. Запланировано на Этапы 17/21 (владелец уведомлён).

📝 Отклонения от ТЗ (согласованы с владельцем)
(прежние: сегмент «Семейные», циклы кэшбэка без flutter_timezone, фильтр суммы по ABS, is_large_expense не в лимитах, approved вручную, «Лучшая карта» по проценту, 4 виджета вместо 6, Drawer вместо BottomNavigation, раскладка pending до Этапа 25, Lottie-заглушки.)
Новые (Этап 12):
- Фильтр «С дедлайном» — независимый тумблер, комбинируется с типом (владелец).
- Пустое состояние фильтра — компактный блок, фильтры остаются кликабельными (владелец).
- auto_reminder_enabled default TRUE (владелец; в ТОМ 2 дефолт не указан).
- savings_goals.completed_at добавлен (нет в ТОМ 2) — одноразовое конфетти + дата в архиве.
- Пополнение привязанной цели = expense с выбранного счёта (не transfer).
- Мультивалютная агрегация сводок — в Dart через ConvertCurrencyUseCase (цепочка Этапа 10), не SQL-JOIN.
- Движение расходов на дашборде: 30 дней, только расходы, без линии доходов (владелец).
- Ввод сумм с группировкой разрядов (MoneyTextInputFormatter) во всех формах приложения.

✅ Закрыто (архив — НЕ удалять, это история)
Этапы 1–11: (прежний список без изменений.)
Этап 12 (частично):
[x] 12.1 Data: savings_goals/savings_goal_drafts (v9), Freezed-сущности, DAO, репозиторий.
[x] 12.2 Domain: 19 UseCases + порт прогресса + провайдеры.
[x] 12.3 Интеграция: прогресс через порт, getTransactionsByGoalId, фикс теста.
[x] 12.4 Экран целей: вкладки, сводка, фильтры, карточки, листы, конфетти, empty states.
[x] 12.5 Форма создания/редактирования цели.

📂 Открыто (долги и примечания)
(прежние открытые пункты без изменений: l10n, excludeLargeExpenses UI, засекретить подарок, drag-and-drop счетов, ипотека, системные счета, biometric_login, space_selector, onlyDebts, workmanager KGP, PGRST205 до Этапа 25, cashback_matrix/dashboard_widgets не в defaultSpecs, exchange_rates не синхронизируется, семейные счета в матрице после Этапа 25, approved авто, use_historical_exchange_rate, источники privacy-режимов, виджеты 13/14, Lottie-дизайн, BottomNavigation.)
Добавлено:
[ ] 12.6 Архив: BottomSheet «История цели» + кнопка «📜 История».
[ ] 12.7 SavingsAnalyticsScreen + иконка 📊 в AppBar целей.
[ ] 12.8 Экспорт XLSX/CSV/PNG/PDF (зависимости excel, pdf, share_plus).
[ ] 12.9 Lottie: 9 рабочих анимаций вместо заглушек.
[ ] 12.10 Финал: PROJECT_CONTEXT.md + DECISIONS.md + коммит.
[ ] Создание семейного (shared) счёта в UI — Этапы 17/21.

Примечания:
Эмулятор dev-среды: internal storage 10 GB, после wipe данные стабильны; полный flutter run безопасен, основной workflow — hot reload/restart.
Два терминала: №1 — flutter run (r/R/q); №2 — скрипты правок, flutter analyze, git.