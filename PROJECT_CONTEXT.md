КОНТЕКСТ ПРОЕКТА: Budget Assistant v6.0
Навигатор по проекту. Обновлено после закрытия Этапа 11 (Dashboard).
📌 Иерархия документов
При работе над кодом и архитектурой руководствуйтесь следующей иерархией:
DECISIONS.md — Конституция проекта. Жёсткие ограничения (IntColumn, E2E, Offline-First, Riverpod, Drift). Приоритет №1.
ТЗ 6.0 — Полное техническое задание в 7 Томах. Приоритет №2.
PROJECT_CONTEXT.md (этот файл) — Краткая сводка и навигатор. Приоритет №3.
AI_RULES.md — Правила взаимодействия с ИИ (сбор контекста одной командой, правки одним скриптом, UTF8 без BOM).
Примечание: все эволюционные изменения (Multi-group, Batch-импорт, ML Kit, Year in Review) полностью инкорпорированы в ТЗ 6.0. Отдельных документов для них не существует.
🏗 31 Зафиксированное Архитектурное Решение (Шпаргалка)
Архитектура и Стек
Multi-group: Связь Many-to-Many через memberships. Таблица users НЕ имеет space_id.
Секретность: Режим секретности (подарки) — личная настройка в app_settings, а не глобальный свитч админа.
Импорт: ПОЛНЫЙ ОТКАЗ от OpenAPI банков и API Т-Инвестиций. Только Batch-импорт (CSV/XLSX/PDF) + ручной ввод.
Платформа: ТОЛЬКО Android.
БД: schemaVersion стартует с 1 (чистая установка).
Бизнес-логика и Данные
Деньги: Все суммы в IntColumn (копейки). Проценты в базисных пунктах.
Переводы: trusted_counterparties УДАЛЕНА. Автодетект переводов через алгоритмы (Сценарий А: Межбанк ±3 дня, Сценарий Б: СБП ±5 мин).
Конфликты: sync_conflicts — гибрид (диалог для настроек/групп, Last-Write-Wins для транзакций).
Инвестиции: Полностью исключены из P&L (пополнение = transfer). Портфель шифруется E2E.
Возвраты: Логика is_refund УДАЛЕНА.
Кэшбэк: Считаем только факт трат (NET-сумма с учётом возвратов). Обнуление недельного — Понедельник 00:00.
Уведомления: 27 типов пушей. Все генерируются локально (WorkManager), сервер не имеет доступа к E2E-данным.
UI/UX
Dashboard: Кастомизируемый. FAB быстрых действий перенесён на Экран лога операций.
Privacy Matrix: 3 режима (visible / partial / hidden). Централизованный PrivacyFormatter.
Empty States: Обязательны для всех списков. Позитивные (нет долгов) с конфетти.
🛡 5 ЖЁСТКИХ ПРАВИЛ БИЗНЕС-ЛОГИКИ
Сплит-чеки и Кэшбэк: UseCase кэшбэка обязан делать JOIN с transaction_splits.
Мультивалютность: Суммы трат приводятся к валюте карты по курсу на дату транзакции.
Переводы: Жёсткий фильтр type != 'transfer' во всех расчётах P&L и лимитов.
Возвраты: NET = SUM(expense) - SUM(income с той же категорией).
Часовые пояса: Циклы в локальном часовом поясе (ПН 00:00 / 1-е число 00:00; в БД — UTC).
📚 Структура ТЗ 6.0 (Навигатор)
ТОМ 1: Архитектура, Multi-group, Безопасность (E2E, HKDF).
ТОМ 2: База Данных (Полная Схема ~35 таблиц, индексы, E2E-пометки).
ТОМ 3: Безопасность (PIN, Биометрия, FLAG_SECURE, Shake/Face-down).
ТОМ 4: Бизнес-Логика (P&L, Кэшбэк, Лимиты, Прогнозы, Мультивалютность).
ТОМ 5: Уведомления (Матрица 27 пушей, WorkManager, Дайджесты).
ТОМ 6: UI/UX (52+ экрана, Privacy Matrix, Empty States, Экспорт).
ТОМ 7: Синхронизация, Импорт (Batch, OCR), Роутинг, Тестирование.
🚀 Регламент работы с AI
Один шаг = один коммит. Не пытаться сгенерировать весь проект за один промпт.
Сначала архитектура/псевдокод, потом реализация.
Сверяться с DECISIONS.md перед каждым архитектурным выбором.
Использовать PROJECT_CONTEXT.md как быструю шпаргалку, чтобы не перечитывать все 7 томов.
При противоречии в ТЗ 6.0 — приоритет у DECISIONS.md; внутри ТЗ — у более позднего Тома (Том 7 > Том 1).
🧭 Статус этапов
Этапы 1–8: завершены (детали — в архиве «Закрыто»).
Этап 9 «P&L + Budget Limits + Monthly Analytics»: ЗАВЕРШЁН. schemaVersion 5: budget_limits + индексы; P&L с фундаментальными фильтрами; плавающие лимиты (inherit + carry_over); матрица алертов; BudgetLimitsScreen + редактирование; имена категорий на карточках лимитов.
Этап 10 «Кэшбэк + Мультивалютность»: ЗАВЕРШЁН ПОЛНОСТЬЮ (микро-коммиты 1–6 + фиксы). schemaVersion 6; 5 правил кэшбэка; авто-курсы ЦБ + исключения; мультивалютный UI; матрица выгоды; статусы; семейные скоупы; создание групп и подключение транзакций; подтверждение удаления; PrivacyFormatter.
Этап 11 «Dashboard (виджеты, кастомизация)»: ЗАВЕРШЁН. schemaVersion 8 (v7: dashboard_widgets + индексы; v8: идемпотентная фикс-миграция); DashboardScreen на роуте `/`; 4 виджета (BalanceSummary, ExpenseFlowChart, ActiveCashbackCategories, LimitCards); кастомизация (чекбоксы + drag-and-drop); SpaceSelector и PrivacyToggle в AppBar; Empty States на Lottie-заглушках; тёмная тема по умолчанию.
Следующий: ЭТАП 12 — Savings Goals (savings_goals, UpdateSavingsGoalProgressUseCase, SavingsGoalsScreen + Архив, SavingsAnalyticsScreen; колонки transactions.savings_goal_id/is_withdrawal УЖЕ в схеме).
🗄 Текущая схема БД
schemaVersion = 8.
v4: transactions.is_large_expense (Bool, default false) + idx_transactions_large_expense; transactions.sync_locked_started_at / sync_locked_duration_ms (монотонные часы, Этап 6); sync_conflicts (поля status НЕТ); sync_logs.
v5 (Этап 9): budget_limits + уникальный индекс (space_id, user_id, category_id, year, month) + idx_budget_limits_category / sync_status / user_space; историческая мина миграции from < 2 (DROP TABLE) УДАЛЕНА.
v6 (Этап 10): exchange_rates (уникальный индекс from_currency + to_currency + date); cashback_matrix (category_id — nullable FK на categories для NET-расчёта, percent_bps, status, lifetime_type, expires_at) + idx_cashback_matrix_account / idx_cashback_matrix_sync_status.
v7 (Этап 11): dashboard_widgets (id PK text, user_id FK users, widget_type text, is_visible bool default true, sort_order int, created_at, updated_at, sync_status default 'pending') + уникальный idx_dashboard_widgets_user_type (user_id, widget_type) + idx_dashboard_widgets_sync_status.
v8 (Этап 11, фикс): миграция from<8 — идемпотентное создание dashboard_widgets + индексов (проверка через sqlite_master). Причина: миграция v7 ошибочно была вложена внутрь if (from < 6) и не выполнялась при апгрейде 6→7; v8 лечит устройства, оставшиеся на v7 без таблицы.
Деньги — ТОЛЬКО IntColumn (копейки). Даты — ТОЛЬКО UTC.
💰 Справка по механикам Этапа 10
Цепочка курса на дату D: 1) ручное исключение ровно на D; 2) официальный кэш (кросс через RUB) D..D-7; 3) ленивая загрузка ЦБ за D (кэширует все валюты дня, дальше офлайн); 4) ручное исключение в окне 7 дней; 5) последний официальный курс любой даты; 6) null → понятная ошибка с подсказкой.
exchange_rates НЕ синхронизируется в Supabase (локальный кэш по дизайну).
Кэшбэк: NET = SUM(expense) − SUM(возвраты той же категории); is_split = true → только transaction_splits; type != transfer; циклы: неделя с ПН 00:00, месяц с 1-го 00:00 локального времени (в БД — UTC).
Мультивалютность: операция в чужой валюте → amount пересчитывается в валюту счёта по цепочке, оригинал хранится в original_amount / original_currency.
Матрица выгоды: строки — категории, колонки — карты (мои или семьи); лучшая карта = макс. процент (при равенстве — больший кэшбэк), ячейка подсвечена.
Статусы: potential («Начислен») / approved («Подтверждён»), переключение тапом до банковской логики (Этапы 17/21).
🖥 Справка по механикам Этапа 11 (Dashboard)
Раскладка: dashboard_widgets; дефолт нового пользователя: balanceSummary, expenseFlowChart, activeCashbackCategories (видимые) + limitCards (скрыт); ensureDefaults при первом открытии Dashboard.
Кастомизация: long-press по виджету → BottomSheet (чекбоксы + drag-and-drop ReorderableListView); сохранение обновляет sort_order/is_visible + sync_status='pending' + updated_at=now UTC.
Синхронизация раскладки (решение владельца): раскладка синхронизируемая, но до появления облачных таблиц (Этап 25) dashboard_widgets НЕ добавлена в SyncTableSpec.defaultSpecs — микро-коммит после Этапа 25 вместе с cashback_matrix.
SpaceSelector: PopupMenuButton в AppBar: пункт «Личное» (space_id=null) + активные memberships; haptic selectionClick.
Privacy: тап по глазу циклит visible→partial→hidden; long-press — шторка с 3 режимами; маскирование ТОЛЬКО через PrivacyFormatter (хардкод ••• запрещён).
Тема: тёмная по умолчанию (ThemeMode.dark в lib/app.dart); AppTheme.lightTheme/darkTheme собраны из токенов AppColors; переключатель темы — Этап 21.
Навигация: Drawer на Dashboard (Транзакции, Счета, Категории, Бюджет, Кэшбэк); HomeScreen снят с роута `/` (файл оставлен, не используется).
Lottie: 30 JSON-заглушек в assets/animations/ (технические плейсхолдеры); замена на дизайнерские — без изменений кода.
Источники данных виджетов: expense flow — SQL date(date,'unixepoch','localtime') GROUP BY day за 7 дней (type='expense', savings_goal_id IS NULL, is_withdrawal=0, audit_status!='ignored', изоляция пространств); баланс — accounts по include_in_personal_balance / space_id+include_in_family_balance; под-суммы P&L — CalculateMonthlyPnlUseCase (spaceId=null); кэшбэк — cashback_matrix status='approved' AND expires_at > now; лимиты — budget_limits текущего месяца + GetEffectiveLimitUseCase.
👥 Семьи (Multi-group) — текущая реализация
spaces + memberships; активная группа — currentSpaceIdProvider (core/providers/security_providers.dart).
Лог транзакций: «Семейные» = ВСЕ транзакции активного пространства (включая мои); чип «Без моих» = без моих.
Нет групп → empty-state с CTA «Создать группу»; группа есть, но семейных операций нет → CTA «Подключить мои транзакции» (UPDATE space_id + sync_status='pending'); тот же вопрос чекбоксом в диалоге создания группы (дефолт ВЫКЛ).
2+ групп → селектор «Группа» над сегментами; подпись сегмента «Семейные» = имя активной группы.
Кэшбэк/матрица: источник «Мои карты / Карты семьи»; семейные счета = accounts с space_id активной группы; локально пусты до запуска синхронизации (Этап 25).
SpaceSelectorScreen — заглушка до Этапов 17/21.
📝 Отклонения от ТЗ (согласованы с владельцем)
Сегмент «Семейные» = все транзакции активного пространства; «только члены семьи» = чип «Без моих» (отклонение от ТЗ 6.3.2.3).
Циклы кэшбэка без flutter_timezone: локальный DateTime → toUtc (результат идентичен, без новой зависимости).
Фильтр суммы в логе транзакций по ABS(amount).
is_large_expense НЕ применяется в лимитах по категориям.
approved — ручное подтверждение до банковской логики (Этапы 17/21).
«Лучшая карта» матрицы = макс. процент (при равенстве — больший кэшбэк) — UI-решение Этапа 10.
Этап 11: 4 виджета вместо 6 — UpcomingRemindersPreview и OpenDebtsPreview отложены на Этапы 13/14 (таблиц debts/reminders ещё нет; вместе с ними — миграция дефолтных строк dashboard_widgets).
Этап 11: BottomNavigation (5 табов, ТЗ 6.3.1) временно заменён Drawer; переход на нижнюю навигацию — на этапах полировки.
Этап 11: раскладка пишется с sync_status='pending', но фактическая облачная синхронизация — после Этапа 25 (облачных таблиц до этого нет).
Этап 11: Lottie-анимации — заглушки (плейсхолдеры) до появления дизайнерских JSON.
✅ Закрыто (архив — НЕ удалять, это история)
Этапы 1–8:
[x] Auth flow end-to-end (регистрация Supabase, онбординг, PIN, биометрия)
[x] Персист флага онбординга (onboarding_completed в SecureStorage + bootstrap в main)
[x] Полные 7 типов счетов в UI создания/редактирования
[x] CRUD категорий: Update/Delete + дочерние категории
[x] Update счёта (Edit по тапу)
[x] Этап 8: Sync Service — SyncService + WorkManager (период 1 час, constraint: сеть) + Supabase UPSERT, retry + exponential backoff, pull-to-refresh
[x] E2E-шифрование payload счетов/категорий/транзакций перед Supabase (AES-256-GCM; ключи enc_key_{space_id} / enc_key_personal в SecureStorage; Supabase url/anon тоже в SecureStorage)
[x] Конфликты: LWW для транзакций (applyRemoteRow + запись в sync_conflicts), pending_resolution для счетов/категорий
[x] Монотонные часы: SystemClock.elapsedRealtime() через MethodChannel budget_assistant/clock; авто-блокировка sync_locked_* для расходов >= large_transaction_threshold при enable_secrecy_mode
[x] «Исключить из учёта (сторно)» ПОЛНОСТЬЮ УДАЛЕНО (AuditStatus.ignored оставлен в enum, в UI не используется)
[x] Крупные траты: long-press «Отметить как крупную трату», иконка 💎, чип-фильтр «Без крупных»
[x] Экран редактирования транзакции: роут /transactions/edit/:id, EditTransactionScreen, long-press «Редактировать»
[x] Фильтр суммы в логе транзакций по модулю ABS(amount)
Этап 9:
[x] budget_limits + уникальный индекс + P&L с фундаментальными фильтрами (без переводов/копилок/изъятий/ignored)
[x] Плавающие лимиты (inherit_limit_from_previous_month + carry_over_unused_limit)
[x] Матрица алертов (global_percent / global_amount / individual)
[x] BudgetLimitsScreen + редактирование + имена категорий на карточках лимитов
Этап 10:
[x] cashback_matrix + exchange_rates (v6) + индексы
[x] CalculateCashbackUseCase: 5 жёстких правил (сплиты, мультивалютность, переводы, NET, циклы)
[x] Авто-курсы ЦБ РФ: ленивый кэш на дату + fallback-цепочка + защита от спама запросов (_failedDates)
[x] Меню курсов-исключений: инфо-плашка, источник (ЦБ/вручную), удаление записи
[x] Мультивалютный UI: валюта счёта, валюта операции, предпросмотр конвертации, справочник kCurrencyCodes (core/constants)
[x] Матрица выгоды «категория × карта» с подсветкой лучшей карты
[x] Статусы potential/approved (ручное переключение)
[x] Источники «Мои карты / Карты семьи» в кэшбэке и матрице
[x] Создание группы (spaces + memberships + admin) + подключение личных транзакций к группе + чекбокс в диалоге создания
[x] Селектор групп при 2+ группах; подпись сегмента «Семейные» = имя группы
[x] Подтверждение удаления категории кэшбэка (диалог)
[x] PrivacyFormatter в кэшбэке (formatAmount, formatPercentBps)
[x] Реактивность матрицы: readsFrom в customSelect watch
[x] Историческая мина миграции from < 2 удалена (при bump до v5)
[x] Семантика «Семейные» реализована и расширена на кэшбэк
Этап 11:
[x] dashboard_widgets (v7) + уникальный индекс (user_id, widget_type) + индекс sync_status
[x] v8 фикс-миграция: идемпотентное создание таблицы для устройств с битой v7
[x] DashboardScreen на роуте `/` (вместо HomeScreen-QA-заглушки)
[x] 4 виджета: BalanceSummary (сегменты Личные/Семья), ExpenseFlowChart (fl_chart, 7 дней), ActiveCashbackCategories (approved + expires_at > now), LimitCards (BudgetLimitCard + effective-лимиты)
[x] Кастомизация: BottomSheet с чекбоксами и drag-and-drop; sort_order + sync_status='pending'
[x] SpaceSelector в AppBar с пунктом «Личное» (haptic selectionClick)
[x] PrivacyToggle: тап-цикл visible→partial→hidden, long-press шторка с 3 режимами
[x] Empty States: EmptyStateWidget (Lottie) для дашборда и каждого виджета; «Ваш дашборд пуст» при всех снятых чекбоксах
[x] Offline-состояния: skeleton shimmer, OfflineErrorCard + Retry, pull-to-refresh
[x] Тёмная тема по умолчанию (ThemeMode.dark, AppTheme из токенов AppColors)
[x] Зависимости lottie + fl_chart; assets/animations/ — 30 JSON-заглушек
[x] Drawer-навигация к разделам Этапов 5–10 (вместо QA-кнопок HomeScreen)
📂 Открыто (долги и примечания)
Перенесено из прежних версий:
[ ] l10n-фундамент: RU как основной (flutter_localizations + .arb), переводить все экраны за один раз — микро-коммит после Этапа 7
[ ] l10n: перевод TransactionsLogLabels в .arb
[ ] initializeDateFormatting() + Intl.defaultLocale = 'ru' в main — временное решение до l10n-микро-коммита
[ ] excludeLargeExpenses: применён в P&L (Этап 9); Dashboard — SQL-параметр в getExpenseFlow готов, но НЕ подключён (нет UI-фильтра на дашборде); Monthly/Reports — при создании экрана отчётов; в лимитах НЕ применяется
[ ] Ручное «Засекретить (Подарок)»: меняет только is_hidden_by_calendar; привязка к holidays и sync_locked — Этап 14/15
[ ] Drag-and-drop сортировка счетов в UI (UseCase UpdateAccountSortOrder готов) — Этап 21
[ ] Форма создания ипотеки (account_type='mortgage') — Этап 21
[ ] Авто-создание системных счетов (is_system) — Этап 21
[ ] enable_biometric_login не персистится в app_settings — Этап 21
[ ] space_selector: заглушка вместо реального списка пространств — Этап 17/21 (переключение групп живёт в логе транзакций и кэшбэке)
[ ] onlyDebts-фильтр в логе транзакций — включится на Этапе 13 (таблица debts)
[ ] workmanager 0.7.0 применяет KGP — warning о будущем Flutter; мониторить релизы плагина
Добавлено после Этапов 9–11:
[ ] Supabase: таблицы в облаке НЕ созданы (ошибки PGRST205 в логе — норма до Этапа 25: SQL-миграции + RLS)
[ ] cashback_matrix не добавлена в SyncTableSpec.defaultSpecs — микро-коммит сразу после Этапа 25
[ ] dashboard_widgets не добавлена в SyncTableSpec.defaultSpecs — микро-коммит сразу после Этапа 25 (вместе с cashback_matrix)
[ ] exchange_rates не синхронизируется (по дизайну, локальный кэш)
[ ] Счета участников семьи и их кэшбэк в матрице — появятся после запуска синхронизации (Этап 25)
[ ] approved — ручное подтверждение; авто-подтверждение от банка — Этапы 17/21
[ ] Свитч use_historical_exchange_rate не реализован (поведение = всегда исторические курсы, ТОМ 4 §4.2)
[ ] Источники privacy-режимов (app_settings.default_balance_visibility, shake, face-down, timeout) — Этапы 21/23
[ ] Виджеты UpcomingRemindersPreview и OpenDebtsPreview на Dashboard — Этапы 13/14 (+ миграция дефолтных строк dashboard_widgets)
[ ] Lottie: заменить заглушки assets/animations/*.json на дизайнерские анимации (без изменений кода)
[ ] BottomNavigation 5 табов (ТЗ 6.3.1) — переход с Drawer на этапах полировки
Примечания:
Эмулятор dev-среды: internal storage 10 GB, после wipe данные стабильны; полный flutter run безопасен, основной workflow — hot reload/restart.
Два терминала: №1 — flutter run (r — hot reload, R — hot restart, q — стоп); №2 — скрипты правок, flutter analyze, git.