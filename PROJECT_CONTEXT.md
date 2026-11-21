КОНТЕКСТ ПРОЕКТА: Budget Assistant v6.0
Навигатор по проекту. Обновлено: Этап 13 завершён (Debts + Split Transactions).

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
[x] 12.5.1 Чекбокс «Зачислить текущий баланс счёта в цель» (Вариант Б): вкл. по умолчанию, поле суммы + кнопка «Весь баланс», пусто = 100%.
[x] 12.6 Архив: BottomSheet «История цели» (fl_chart график + транзакции) + кнопка «📜 История» на карточке архива.
[x] 12.7 SavingsAnalyticsScreen: период-селектор, Summary Grid 2×2, график накопления + прогноз, сортируемая таблица целей, валютный баннер, day-details по тапу, иконка 📊 в AppBar целей; точки графика только в дни поступлений.
[x] 12.8 Экспорт аналитики: XLSX (OOXML через archive) + CSV (UTF-8 BOM) + PNG (RepaintBoundary); диалог «Сохранить в память» (MediaStore Downloads/BudgetAssistant) / «Поделиться» (Share Sheet); блок в hidden. PDF исключён (отклонение).
[x] 12.9 — ОТМЕНЁН решением владельца: Lottie и assets/animations удалены; empty states = статичные Material-иконки.
[x] 12.10 Финал: обновление PROJECT_CONTEXT.md + DECISIONS.md + коммит этапа.
[x] 12.6 Архив: BottomSheet «История цели» (fl_chart график + список транзакций) + кнопка «📜 История» на карточке архива.
[x] 12.7 SavingsAnalyticsScreen (/savings-analytics): период-селектор, Summary Grid 2×2, график накопления + прогноз, иконка 📊 в AppBar целей. ТАБЛИЦА ЦЕЛЕЙ И ВАЛЮТНЫЙ БАННЕР — не реализованы, см. «Открыто».
[x] 12.8 Экспорт аналитики: XLSX (OOXML через archive, 2 листа) + CSV (UTF-8 BOM) + PNG (RepaintBoundary); диалог «Сохранить в память» (MediaStore Downloads) / «Поделиться» (Share Sheet); блок в hidden.
[x] 12.9 — ОТМЕНЁН решением владельца: Lottie-анимации и assets/animations удалены; empty states = статичные иконки.
[x] 12.10 Финал: обновление PROJECT_CONTEXT.md + DECISIONS.md + коммит этапа.
[x] 12.5.1 Чекбокс «Зачислить текущий баланс счёта в цель» (Вариант Б): вкл. по умолчанию, поле суммы + кнопка «Весь баланс», пусто = 100%; правки draft/usecase/валидации.
[x] 12.6 Архив: BottomSheet «История цели» (fl_chart график накопления + список транзакций) + кнопка «📜 История» на карточке архива.
[x] 12.7 SavingsAnalyticsScreen (/savings-analytics): период-селектор, Summary Grid 2×2, график накопления + прогноз, сортируемая таблица целей, валютный баннер, иконка 📊 в AppBar SavingsGoalsScreen.
  Не сделано:
  [ ] 12.6 Архив: BottomSheet «История цели» (fl_chart график накопления + список транзакций) + кнопка «📜 История» на карточке архива.
  [ ] 12.7 SavingsAnalyticsScreen (/savings-analytics): период-селектор, Summary Grid 2×2, график накопления + прогноз, сортируемая таблица целей, валютный баннер, иконка 📊 в AppBar SavingsGoalsScreen.
  [ ] 12.8 Экспорт аналитики: XLSX + CSV + PNG + PDF (зависимости excel/pdf/share_plus; PNG через RepaintBoundary без доп. пакета).
  [ ] 12.9 Lottie: заменить 9 заглушек на рабочие анимации (confetti, celebration, empty_piggy, empty_box, search, pause_savings, broken_chart, empty_wallet, lonely_silhouette).
  [ ] 12.10 Финал: обновление PROJECT_CONTEXT.md + DECISIONS.md + коммит этапа.

🗄 Текущая схема БД
schemaVersion = 12.
v10 (Этап 13): debts (обе стороны nullable — D13-2; amount/currency, description и counterparty_name_dative [E2E], due_date, resolution_status, is_ex_member_debt, created_by) + debt_drafts и split_drafts (локальные, без sync) + индексы (creditor/debtor+status, space, due_date, sync_status).
v11–v12 (Этап 13): консолидированы в один идемпотентный блок from<12: пересоздание debts (creditor_id nullable, auto_resolve из определения таблицы), создание черновиков при отсутствии, пересоздание индексов.
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
Аналитика (12.7): периоды Месяц/Квартал/Год/Всё время (дефолт Год); агрегация в Dart через ConvertCurrencyUseCase (курс на дату транзакции, остатки — на сегодня); hasStaleRates → предупреждение и валютный баннер; таблица сортируется по любой колонке (SortGoalsTableUseCase); тап по точке графика → day-details sheet со списком пополнений за день.
Экспорт (12.8): XLSX 2 листа («Цели», «Пополнения») / CSV с BOM / PNG-снимок карточки графика (RepaintBoundary, pixelRatio 3); сохранение — MediaStore Downloads/BudgetAssistant через MethodChannel budget_assistant/clock (без runtime-разрешений на Android 10+); шеринг — системный Share Sheet; в hidden экспорт заблокирован на уровне UI.
Реактивность дашборда (фикс 12.8): transactionsTriggerProvider (Notifier<int>) — bump() после CRUD транзакций и пополнений/изъятий целей; dashboardExpenseFlowProvider подписан на триггер и пересчитывается сразу, включая холодный старт (spaceId == null → без space-фильтра).
Аналитика (12.7): периоды Месяц/Квартал/Год/Всё время (дефолт Год); агрегация в Dart через ConvertCurrencyUseCase (курс на дату транзакции); hasStaleRates → предупреждение «Курс устарел».
Экспорт (12.8): формат → файл во temp → диалог «Сохранить в память» (MediaStore: Downloads/BudgetAssistant, без разрешений на Android 10+) / «Поделиться» (Share Sheet); в hidden экспорт заблокирован на уровне UI.
Реактивность дашборда (фикс 12.8): transactionsTriggerProvider (Notifier<int>) — bump() после CRUD транзакций и пополнений/изъятий целей; dashboardExpenseFlowProvider пересчитывается без захода в лог транзакций.

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
MissingPluginException saveToDownloads: нативный handler добавлен в MainActivity.kt + полная пересборка (flutter clean/run) — правки Kotlin не подхватываются hot restart.
MediaStore: EXTERNAL_CONTENT_URI вместо CONTENT_URI (ошибка компиляции Kotlin).
Экспорт: диалог выбора назначения показывается ДО закрытия шита (fix unmounted context); действия — через захваченные messenger/usecase.
accumulation_chart: RepaintBoundary вокруг ВСЕЙ карточки (PNG работает и в empty-состоянии); точки линии — только в дни поступлений; тап по точке открывает day-details.
Удаление Lottie: regex-замена Lottie.asset учитывает вызов без завершающей запятой; пакет lottie и папка assets/animations удалены, pubspec очищен.
getExpenseFlow: spaceId == null → без space-фильтра (виджет «Движение расходов» был пуст на холодном старте).
getExpenseFlow: spaceId == null → без space-фильтра (ранее «AND space_id IS NULL» обесцвечивал виджет на холодном старте).
Экспорт: диалог выбора назначения показывается ДО закрытия шита (fix unmounted context); действия — через захваченные messenger/usecase.
MediaStore: EXTERNAL_CONTENT_URI (не CONTENT_URI) — исправление ошибки компиляции Kotlin.
accumulation_chart: RepaintBoundary вокруг ВСЕГО контейнера графика — PNG-экспорт работает и в empty-состоянии.
Удаление Lottie: regex-замена Lottie.asset учитывает вызов без завершающей запятой; папка assets/animations и пакет lottie удалены.
Чекбокс зачисления баланса (12.5.1): Variant B — чекбокс вкл. по умолчанию + поле суммы + кнопка «Весь баланс»; пусто = 100% баланса; стартовое зачисление без транзакции (current_amount стартует с суммы), баланс счёта не списывается.
12.7: мультивалютная агрегация аналитики — в Dart через ConvertCurrencyUseCase (не SQL-JOIN); экспорт и Year-in-Review-ссылка — в 12.8/Этап 19.

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
12.9 отменён владельцем: Lottie-анимации и assets/animations удалены; empty states — статичные Material-иконки; конфетти достижения — Icons.emoji_events_outlined + HapticFeedback.
12.8: PDF-экспорт исключён (package:pdf конфликтует по archive; кириллице нужен TTF-ассет) — долг.
12.8: «Сохранить в память» — MediaStore Downloads через MethodChannel (file_saver/SAF не открывал пикер на устройстве).
12.8: шеринг — Share.shareXFiles (deprecated API с локальным ignore): SharePlus.instance.share не открывал лист на устройстве.
12.7: точки графика накопления — только в дни поступлений (владелец).
12.9 отменён владельцем: Lottie-анимации и assets/animations удалены; empty states — статичные Material-иконки; конфетти достижения — Icons.emoji_events_outlined + HapticFeedback.
12.8: PDF-экспорт исключён (package:pdf конфликтует по archive; кириллице нужен TTF-ассет).
12.8: «Сохранить в память» — MediaStore Downloads через MethodChannel budget_assistant/clock (file_saver/SAF не открывал пикер на устройстве).
12.7: сортируемая таблица целей и валютный баннер SavingsAnalyticsScreen НЕ реализованы — перенесены в «Открыто».
- Ввод сумм с группировкой разрядов (MoneyTextInputFormatter) во всех формах приложения.

✅ Закрыто (архив — НЕ удалять, это история)
Этапы 1–11: (прежний список без изменений.)
Этап 12 (частично):
[x] 12.1 Data: savings_goals/savings_goal_drafts (v9), Freezed-сущности, DAO, репозиторий.
[x] 12.2 Domain: 19 UseCases + порт прогресса + провайдеры.
[x] 12.3 Интеграция: прогресс через порт, getTransactionsByGoalId, фикс теста.
[x] 12.4 Экран целей: вкладки, сводка, фильтры, карточки, листы, конфетти, empty states.
[x] 12.5 Форма создания/редактирования цели.
[x] 12.5.1 Чекбокс зачисления баланса счёта в цель (Вариант Б).
[x] 12.6 Архив: sheet истории цели + кнопка «📜 История».
[x] 12.7 SavingsAnalyticsScreen полностью (таблица, баннер, day-details, точки) + иконка 📊.
[x] 12.8 Экспорт XLSX/CSV/PNG + диалог сохранить/поделиться (PDF — долг).
[x] 12.9 — отменён: Lottie и анимации удалены решением владельца.
[x] 12.10 Финальные документы + коммит этапа.
[x] 12.6 Архив: sheet истории цели + кнопка «📜 История».
[x] 12.7 SavingsAnalyticsScreen + иконка 📊 (таблица/баннер — долг).
[x] 12.8 Экспорт XLSX/CSV/PNG + диалог сохранить/поделиться.
[x] 12.9 — отменён: Lottie и анимации удалены решением владельца.
[x] 12.10 Финальные документы + коммит этапа.
[x] 12.5.1 Чекбокс зачисления баланса счёта в цель (Вариант Б).
[x] 12.6 Архив: BottomSheet «История цели» + кнопка «📜 История».
[x] 12.7 SavingsAnalyticsScreen + иконка 📊 в AppBar целей.

📂 Открыто (долги и примечания)
(прежние открытые пункты без изменений: l10n, excludeLargeExpenses UI, засекретить подарок, drag-and-drop счетов, ипотека, системные счета, biometric_login, space_selector, onlyDebts, workmanager KGP, PGRST205 до Этапа 25, cashback_matrix/dashboard_widgets не в defaultSpecs, exchange_rates не синхронизируется, семейные счета в матрице после Этапа 25, approved авто, use_historical_exchange_rate, источники privacy-режимов, виджеты 13/14, BottomNavigation.)
Добавлено:
[ ] SavingsAnalyticsScreen: сортируемая таблица целей + валютный баннер (ТЗ 6.3.18) — долг Этапа 12.
[ ] PDF-экспорт аналитики — исключён (отклонение); вернуть после выбора TTF для кириллицы.
[ ] Создание семейного (shared) счёта в UI — Этапы 17/21.

Примечания:
Эмулятор dev-среды: internal storage 10 GB, после wipe данные стабильны; полный flutter run безопасен, основной workflow — hot reload/restart.
Два терминала: №1 — flutter run (r/R/q); №2 — скрипты правок, flutter analyze, git.

🎯 Справка по механикам Этапа 13 (Debts + Split)
Долги: таблица debts (v10); обе стороны nullable — внешний контрагент = NULL-сторона + counterparty_name_dative [E2E] (D13-2); направление — Debt.directionFor(userId); семейные долги space_id = currentSpaceId, внешние — NULL.
Дательный падеж: DeclineNameUseCase — собственный правил-бейсд склонятель (вариант «а», без пакетов); при неудаче success=false → ручной ввод; для семьи склоняет display_name при рендере.
CloseDebtUseCase: компенсирующие транзакции без ретро-пересчёта; Сценарий А (тот же месяц) — категория исходной траты, Сценарий Б — SYSTEM_DEBT_REPAYMENT (getOrCreate с детерминированным id); компенсации пишутся с spaceId = NULL (D13-3).
auto_resolve: колонка + DebtsDao.resolveAutoLinked готовы, триггер НЕ подключён (D13-6) — точка подключения Этапы 15/25.
Split: SplitTransactionScreen (/transactions/split/:id): позиции = transaction_splits, Σ = сумме транзакции точно (копейки), минимум 2 позиции; при сохранении исходная получает is_split = TRUE (исключение из P&L; учёт только сплитов — фильтры аналитики в Этапе 19). Защита от спама: offer_receipt_split_count / auto_offer_receipt_split (≥3 отказов → авто-выкл).
Черновики: debt_drafts / split_drafts — автосейв 5 сек, восстановление если младше 24 ч, удаление после сохранения, cleanup старше 7 дней.
Фильтр лога «Только долги»: EXISTS-подзапрос по debts (original_transaction_id ИЛИ split_id через transaction_splits) — CustomExpression с type-safe именами колонок.
Вход: Drawer «Долги» → /debts; роуты /debts/create (?id / ?transaction_id / ?split_id), /transactions/split/:id. Виджет debts_section для ProfileScreen создан, встраивается в Этапе 21.
Ex-member: MarkDebtsAsExMemberUseCase (флаг is_ex_member_debt, статусы не меняются); отдельная секция + sheet (погашен=resolved, списать=forgiven только кредитор — D13-4, напомнить=Share Sheet — D13-5).

✅ Этап 13 — ЗАКРЫТ:
[x] 13.1 Data: debts/debt_drafts/split_drafts (v10→v12 консолидировано), Freezed-сущности, DAO, репозитории, onlyDebts EXISTS-фильтр.
[x] 13.2 Domain: 14 usecases долгов (включая DeclineNameUseCase) + провайдеры.
[x] 13.3 CloseDebtUseCase (Сценарии А/Б) + split-usecases + spam-счётчики + порты (SystemCategoryPort, SplitOfferSettingsPort).
[x] 13.4 DebtsScreen: табы, сводка, фильтры, секции (активные/просрочено/ex-member/закрытые), long-press, empty states, privacy.
[x] 13.5 CreateDebtScreen: секции формы, множественный выбор с равным делением, склонение + warning, черновики, prefill-режимы, live-превью.
[x] 13.6 SplitTransactionScreen: source-карточка, ReorderableListView позиций, остаток, сводка, action bar, sheet категорий, черновики.
[x] 13.7 Интеграции: пункт Drawer, long-press «Разделить по категориям» / «Создать долг», навигационные фиксы (pop вместо go), роуты.

🔧 Журнал фиксов Этапа 13
Миграции v10–v12 вставлялись prepend-ом → ALTER выполнялся раньше CREATE при апгрейде с v9: консолидировано в один идемпотентный блок from<12. Правило на будущее: новые миграции только аппендом в конец onUpgrade.
PowerShell-интерполяция в двойных кавычках съела ${transaction.id} при вставке пунктов меню → push без id (GoException) и пустой transaction_id; интерполяция восстановлена, меню Column→ListView(shrinkWrap) (overflow после добавления пунктов).
CreateDebtScreen: context.go('/debts') сбрасывал стек (нет кнопки назад) → canPop ? pop : go(home); пустые query-параметры приравнены к отсутствию (_nullIfEmpty).
Riverpod: CircularDependencyError автосейва черновика — нотификатор читал провайдер, зависящий от формы; черновик строится из state.
Drift: в WHERE-выражениях нет exists()/selectOne() → CustomExpression с EXISTS; syncStatus debts — textEnum<SyncStatus> (Value(SyncStatus.pending), не строки).
Freezed: copyWith не принимает nullable для non-null полей (позиции сплита) → пересоздание конструктором; SplitPositionDraft.id стал required.
Flutter: DropdownButtonFormField в Row требует ограничения ширины (SizedBox); ConsumerState.build без параметра WidgetRef; AsyncValue.valueOrNull → .value (Riverpod 3).

📂 Открыто (долги Этапа 13, перенесены):
[ ] Локальные пуши долгов (6.3.13.15 п.6: за 3 дня / в день срока / при просрочке) — после LocalNotificationService (Этап 14/18).
[ ] Триггер auto_resolve — Этап 15/25 (D13-6).
[ ] 6.3.48 SplitReceiptScreen / 6.3.49 ProductNamingDialog — Этап 16 (вместе с таблицами receipts).
[ ] Встраивание debts_section в ProfileScreen — Этап 21.
[ ] Аналитика: фильтр is_split = FALSE и учёт только transaction_splits — Этап 19 (CalculateYearlyAnalyticsUseCase).
[ ] «Посмотреть транзакцию / split» из long-press долга — вместе с деталями долга (вне роадмапа, решение владельца).

Этап 14 «Reminders (RRULE) + Calendar»: ЗАВЕРШЁН.
[x] 14.1 Data: reminders, holidays, recurring_transactions, forecast_cache, reminder_drafts (schemaVersion 13), индексы ТОМ 2 §22, сиды 14 праздников РФ, +5 колонок app_settings.
[x] 14.2 Domain напоминаний: RRULE UseCases, ScheduleRemindersUseCase (строго 3 PendingIntent), сервис локальных пушей (канал reminders, экшены Выполнено/Отложить, background-complete), POST_NOTIFICATIONS + SCHEDULE_EXACT_ALARM в манифесте, coreLibraryDesugaring в build.gradle.kts.
[x] 14.3 UI напоминаний: RemindersScreen (табы/фильтры/swipe+undo/long-press/FAB), ReminderDetailsScreen, CreateReminderScreen (RRULE-билдер, черновики 5 сек), роуты, пункт Drawer.
[x] 14.4 Календарная группа: HolidaysManagementScreen (пресеты read-only + CRUD личных), CalendarScreen (table_calendar, заливка дней, маркеры, легенда топ-5, bar-chart доходов/расходов, превью 14 дней, панель сводки дня, формат месяц/2 недели), DayStatisticsScreen (P&L-сводка, «бесплатный день» + streak, stacked-bar категорий, секретные заглушки 🎁), DateForecastScreen (будущие даты, дефицит-блок, кэш forecast_cache + compute-пересчёт), RecurringPaymentsDetectionScreen (группы, confidence, sticky-бар, undo, dismiss_count≥3 → auto-detect OFF), Floating Indicator на календаре, роуты /calendar*.
[x] 14.5 Детекция регулярных платежей: detect в compute-изоляте, upsert-идемпотентность (user_id, merchant_normalized, amount_bucket), CreateReminderFromRecurringUseCase.
[x] 14.6 Интеграции: CreateTransactionScreen читает reminder_id/date (предзаполнение amount/date/category/account/comment), авто-завершение напоминания после сохранения; DECISIONS/PROJECT_CONTEXT обновлены.
Долги Этапа 14 (см. DECISIONS.md): WorkManager-рескейдул пушей и доходы в forecast_cache (Этап 18), триггер детекта из импорта (Этап 15), is_secret напоминаний (не реализуем).

Этап 15 «Batch-импорт (CSV/XLSX/PDF)»: ЗАВЕРШЁН.
[x] 15.1 Data: parser_configs + import_drafts (schemaVersion 14), Freezed DTO, DAO, репозиторий, сиды банков, индексы.
[x] 15.2 Парсеры: CSV (dart:convert, windows-1251, кавычки), XLSX (archive/OOXML), PDF (pdfx + ML Kit OCR, regex из config_json); UseCases детекции: дубликаты (Levenshtein < 3, разделение Дубль/Hold), переводы (Межбанк ±3 дн / СБП ±5 мин), автокатегоризация (3 уровня), финализация, секретность, календарь.
[x] 15.3 ImportOnboardingScreen: wizard 4 шага (банк → файл → структура → счёт), автосейв черновика 5 сек + восстановление < 24 ч, автоопределение колонок (confidence ≥ 0.8), роут /import/review.
[x] 15.4 PostImportReviewScreen: 4 таба Smart Detection, Selected Summary, валидация, FinalizeImport (skip/replace/both, merge/keep, confirm/skip), secrecy-handoff → /import/secrets, баланс-дельта.
[x] 15.5 ImportSecretsScreen: календарь периодов секретности, кандидаты с AI-confidence, премаппинг «Подарки», ApplySecrecyMode (is_hidden_by_calendar + hidden_until_date).
[x] 15.6 Интеграция: WorkManager-очистка import_drafts (1 раз/сутки + ленивая), авто-триггер DetectRecurringPaymentsUseCase из импорта (долг Этапа 14 закрыт), DECISIONS/PROJECT_CONTEXT обновлены.
Долги Этапа 15: самообучение category_rules при массовом применении AI (6.3.26.12); камера/облако в FilePicker; ML Kit Status Banner не нужен (bundled).
## Этап 15 — статус (2026-10)

- PDF-импорт: текстовый движок Syncfusion (слова с координатами), парсеры 6 форматов (Яндекс Сейв, Т-Банк, Сбер, ВТБ, Ozon, Альфа XLSX), OCR-фолбэк для сканов.
- HOLD-строки импортируются с audit_status='pending'; детект дубликатов и регулярных — без изменений.
- Трансферы v2: пометка isTransfer при импорте (телефоны/ФИО/маркеры из профиля), без объединений; табы «Переводы»/«Категории» с переключением.
- Профиль минимум (аккаунт, пространства, телефоны/ФИО, семьи) — вход через Drawer; полный — Этап 21.

## Обновления (Этап 15 финал + навигация/профиль)
- PDF-импорт: Syncfusion (текстовый слой, слова с координатами) + pdfx/ML Kit OCR fallback для сканов; ключ не нужен (28.x).
- Инвестиции исключены; инвест-счёт = обычный счёт (investment_broker); Т-Инвестиции не импортируются.
- Переводы v2: isTransfer-пометка при импорте (телефоны/ФИО профиля ИЛИ маркеры), type='transfer', без UI «объединить».
- Профиль /profile (минимум) + пункт Drawer: email, пространства, телефоны/ФИО для детекции переводов, семьи, выход; полный — Этап 21.
- Навигация: AppDrawer на всех экранах; убраны «домик» и кросс-ссылки; после импорта → /transactions; мастер импорта сбрасывается после успеха.
- Фильтры лога транзакций: autoDispose (сброс при уходе с экрана).
- Auth: Google (Supabase OAuth) + подтверждение email по настройке Supabase «Confirm email».
## Этап 16 — DONE
- Экраны: ScanReceiptScreen (QR mobile_scanner / OCR ML Kit / галерея), ReceiptPreviewScreen (превью+privacy, метаданные, матчинг A-Г, позиции, ProductNamingDialog), SplitReceiptScreen (ТЗ 6.3.48).
- БД v16: receipts, receipt_items, product_aliases, receipt_drafts + индексы (ТОМ 2 §22).
- Роуты: /receipts/scan, /receipts/:id/preview, /receipts/:id/split. Вход в сканер — long-press по транзакции («Прикрепить чек»).
- Спам-защита: offer_product_naming_count / offer_receipt_split_count (>=3 -> автооффер выкл).
- Открытые долги: список чеков (будущий этап); загрузка фото чека в Supabase Storage (этап 25, sync_images_to_cloud); product_analytics_cache (этап 20); персист инфо-баннера сплита; вычистка осиротевших черновиков.

### Этап 17 (текущий) — Admin Dashboard + Members Management
Реализовано: AdminDashboardScreen (/admin), MembersManagementScreen (/admin/members), InviteSheet с QR-кодом, InactiveAdminCheckWorker, AcceptInvitation flow (HKDF + AES-256-GCM), 13 UseCases для админ-контура, 2 новые таблицы invitations и dmin_audit_log (schema v17).
Долги перенесены на Этап 21 (PIN при передаче роли, member_colors) и Этап 25 (Email-инвайты через Supabase Edge Functions, cross-device приём инвайта).
### Этап 17 — DONE (приёмка + fix-коммиты)
Коммиты: 0be2c04 (база), bb08dae (диспетчер/heartbeat), далее fix-коммиты: privacy-rewrite, dissolve+switcher+key-repair, impl/providers rewrite, invite-role-reset+alert-semantics, docs/polish (текущий).
Готово: /admin (guard, space info, сетка 2x2, алерты, журнал в AppBar), /admin/members (фильтры, поиск, карточки, меню, transfer-диалог), InviteSheet (QR/ссылка/Email-disabled, таймер 24ч, роль в токене), AcceptInvitation (HKDF+AES-GCM, TODO Этап 25), invitations+admin_audit_log (schema v17), heartbeat+аварийное повышение (WorkManager), privacy-matrix на всех админ-экранах, удаление соло-группы (dissolved).
Долги: Этап 18 — AuditLogScreen, SpaceSettingsScreen, MembersActivityScreen, push-уведомления админ-действий; Этап 21 — PIN при передаче роли (D17-6), member_colors (D17-3), унификация currentSpaceIdProvider (D17-14); Этап 25 — Email-инвайты, cross-device приём инвайта, синк invitations/admin_audit_log, маппинг action_type.

---

## Этап 18 завершён (18.1–18.7), 29.10.2026

### Что сделано
- **18.1** Миграция БД v2: таблица audit_log; spaces.icon_emoji/icon_color/monthly_budget_limit/dissolved_at/dissolved_by; budget_limits.status; app_settings.notification_settings_json и digest_config.
- **18.2** Журнал аудита `/admin/audit-log`: фильтры по типу действия и периоду, имена актёров из users.
- **18.3** Статистика активности `/admin/activity`: периоды, сводка с прогресс-баром, стек-бар 30 дней (fl_chart), топ-3 с медалями, карточки участников со статусами 🟢🟡 и кнопкой напоминания.
- **18.4** Настройки пространства `/admin/space-settings`: identity (12 эмодзи × 12 цветов), статистика 2×2, месячный лимит, XLSX-экспорт 5 листов (OOXML вручную), расформирование (2 диалога + PIN + кодовое слово).
- **18.5** Центр уведомлений `/notifications`: фильтры-чипы (сброс повторным тапом — Правило 20), карточки 27 типов, 4 канала Android, приватность на локскрине.
- **18.6** Воркер пушей (WorkManager: каждые 6 ч + при старте): 20+ триггеров из локальной БД (лимиты, долги, цели, напоминания, прогноз дефицита, админ-heartbeat, конфликты синка), дедупликация, дайджесты день/неделя/месяца с условной генерацией.
- **18.7** Настройки уведомлений `/settings/notifications` (глобальные тумблеры + 27 типов, alwaysOn без тумблера) и дайджестов `/settings/digest` (вкл + время); deep-link по тапу на пуш; action-кнопки: «Подтвердить» у подарка скрывает покупку, у напоминания — завершает его.

### Точки входа
- Профиль → карточка «Уведомления».
- Боковое меню → «Уведомления» (иконка-колокольчик; у «Напоминаний» — будильник).
- Админ-дашборд → «⚙️ Настройки пространства» и тап по блоку «Активность».

### Онбординг (изменён в фикс-паке 18.5+)
- Шаг «Создание счёта» убран (счета создаются позже из экрана «Счета»).
- Новый шаг «Данные для детекции переводов»: ФИО + телефоны карт, пропускаем, хранится локально (transfer_profile), редактируется в Профиле.

### Техдолг и TODO
- **TODO(19)**: пуш `year_review_ready` — после появления таблицы yearly_aggregates (файл notification_triggers_usecase.dart, комментарий в конце evaluate).
- **ГОТОВО (18.8)**: тёплый deep-link — мгновенный переход через DeepLinkBus; холодный старт — fallback SecureStorage.
- **TODO(25)**: пуши-события импорта (duplicate_receipt, duplicate_detected, transfer_detected, hold_confirmed) — вшить в конвейер импорта; там же серверные таблицы Supabase (ошибка PGRST205: на сервере только 4 таблицы).
- Мёртвый файл бокового меню shared/widgets/app_drawer.dart удалён; живое меню — dashboard/presentation/widgets/app_drawer.dart.
Этап 19 «Year in Review»: ЗАВЕРШЁН (2026-11-01)
[x] 19.1 Data: таблица yearly_aggregates (schemaVersion 19), Freezed DTO YearInReviewData / YearlyAggregate / YearInReviewYearInfo, DAO, репозиторий.
[x] 19.2 Domain: RecalculateYearlyAggregatesUseCase (isolate, конвертация валют по курсу на дату), CalculateYearInReviewUseCase (кэш или пересчёт на лету), MarkYearInReviewAsViewedUseCase, CheckYearInReviewAvailabilityUseCase, ShareYearInReviewSlideUseCase (PNG + FLAG_SECURE + PIN + аудит), GetAvailableYearsUseCase.
[x] 19.3 WorkManager: YearlyAggregatesWorker (пересчёт 1-го числа + 27 декабря, личная + все активные пространства), пуш year_review_ready (TODO(19) из Этапа 18 закрыт).
[x] 19.4 UI: YearInReviewScreen (12 слайдов, автоплей 7 сек, тапы влево/вправо, пауза long-press, privacy-матрица, селектор пространства на Welcome), YearInReviewSelectScreen (список годов со статусом «Готово / Посчитается при открытии»), прогресс-бар с динамическим числом сегментов.
[x] 19.5 Шеринг: PNG текущего слайда через RepaintBoundary (pixelRatio 3) → временный файл → Share Sheet; временное снятие FLAG_SECURE на 5 сек (нативный таймер); PIN при require_pin_for_sensitive && enable_pin_code; аудит-лог для семейной статистики.
[x] 19.6 Интеграция: роуты /year-in-review и /year-in-review/:year, карточка «Статистика года» в Профиле, авто-оверлей после 27 декабря (app.dart), маршрут пуша.
Точки входа: Профиль → «Статистика года» → выбор года → сторис; пуш после 27 декабря → сразу сторис текущего года; авто-оверлей после 27 декабря, если статистика не просмотрена.
Техдолг Этапа 19:
[ ] TODO(25): синхронизация yearly_aggregates (E2E payload), индикаторы sync_status в Top Bar.
[ ] Этап 21: тумблер require_pin_for_sensitive в SecuritySettingsScreen.
[ ] Проверка на реальном устройстве: WorkManager-пересчёт, FLAG_SECURE, Share Sheet.
Хотфиксы Этапа 19: ЗАВЕРШЕНЫ (2026-11-03)
[x] Семейный годовой отчёт включает личные операции участника (D19-13).
[x] Приватность: два режима visible/hidden во всех шторках и переключателях (D19-14).
[x] Удаление транзакции пунктом long-press меню с подтверждением (D19-15).
[x] Статистика: закрытие без диалога в Профиль, автоперелистывание 7 сек, белая полоска-прогресс (D19-16).
[x] Триггер дефицита по реальным колонкам forecast_cache (D19-17).
[x] Шеринг слайда: принудительная перерисовка кадра перед снимком (D19-18).
[x] Кэш итогов пересчитывается при устаревании; список лет и статистика обновляются после импорта без рестарта (D19-19).
Точки входа без изменений: Профиль → «Статистика года» → выбор года → сторис.
Этап 20 «Product Analytics + Loyalty Cards»: ЗАВЕРШЁН (2026-11-05)
[x] 20.1 Data: loyalty_cards / loyalty_card_drafts / product_analytics_cache (schemaVersion 20), app_settings.popular_stores_json [LOCAL], индексы ТОМ 2 §22, Freezed-сущности, DAO, репозитории, провайдеры.
[x] 20.2 Domain лояльности: 16 UseCases (CRUD с проверкой «только создатель», валидация EAN-13 checksum, автодетект типа кода, локальные sort_order/preferred_orientation, черновики 5 сек) + провайдеры.
[x] 20.3 LoyaltyCardsScreen (/loyalty-cards): scope-селектор, поиск debounce 300 мс, single-select чипы со сбросом (Правило 20), сводка, сетка 2 колонки с режимом сортировки, long-press меню (5 действий), 4 empty states, privacy-матрица.
[x] 20.4 AddLoyaltyCardScreen (/loyalty-cards/add): mobile_scanner + фонарик, лента популярных магазинов, редакторы типа/категории/цвета/эмодзи/видимости, черновик с восстановлением < 24 ч, live-превью карты.
[x] 20.5 LoyaltyCardDisplayScreen (/loyalty-cards/display/:id): WakeLock, яркость 1.0, immersive, временное снятие FLAG_SECURE (страховка 10 мин + restore в dispose/paused), auto-hide оверлеев 3 сек, ориентация per-card, генерация ean13/code128/pdf417/qr/manual с fallback на номер.
[x] 20.6 Аналитика товаров (домен/данные): пересчёт product_analytics_cache (атомарный batch), топ товаров (тренд = линейная регрессия), топ категорий, динамика цен (>= 3 месяцев), детализация товара (мин/макс/средняя/волатильность/магазины), провайдеры периодов/скоупа/отчётов.
[x] 20.6b ProductAnalyticsScreen (/product-analytics): 4 периода, Multi-group скоуп, 3 таба отчётов, сводка, stale-баннер с пересчётом, пагинация «Показать ещё (N из M)», sheet детализации, экспорт CSV (BOM, ';') и PNG (RepaintBoundary + share_plus), deep-link ?product_hash=.
[x] 20.7 Интеграция: карточка «Аналитика товаров» в Профиле, пункт Drawer, TODO(25) в коде, DECISIONS D20-1…D20-14, обновление контекста.
Точки входа Этапа 20: Drawer и Профиль → «Скидочные карты» и «Аналитика товаров»; FAB/empty states → добавление карты; тап по карте → полноэкранный показ; deep-links: /loyalty-cards/add?id=…, /product-analytics?product_hash=….
Техдолг Этапа 20 (всё TODO(25)): триггеры пересчёта кэша (confirm чека, Batch-импорт, WorkManager раз в сутки); cross-filter транзакций по product_hash; слайд YIR «Топ товаров»; синхронизация loyalty_cards и product_analytics_cache (E2E payload); zip-экспорт 3 PNG-отчётов и сохранение в Downloads.
Этап 20 «Product Analytics + Loyalty Cards»: ЗАВЕРШЁН (2026-11-05)
[x] 20.1 Data: loyalty_cards / loyalty_card_drafts / product_analytics_cache (schemaVersion 20), app_settings.popular_stores_json [LOCAL], индексы ТОМ 2 §22, Freezed-сущности, DAO, репозитории, провайдеры.
[x] 20.2 Domain лояльности: 16 UseCases (CRUD «только создатель», валидация EAN-13 checksum, автодетект типа кода, локальные sort_order/preferred_orientation, черновики 5 сек) + провайдеры.
[x] 20.3 LoyaltyCardsScreen (/loyalty-cards): scope-селектор, поиск debounce 300 мс, single-select чипы со сбросом (Правило 20), сводка, сетка 2 колонки с режимом сортировки, long-press меню (5 действий), 4 empty states, privacy-матрица.
[x] 20.4 AddLoyaltyCardScreen (/loyalty-cards/add): mobile_scanner + фонарик, лента популярных магазинов, редакторы типа/категории/цвета/эмодзи/видимости, черновик с восстановлением < 24 ч, live-превью карты.
[x] 20.5 LoyaltyCardDisplayScreen (/loyalty-cards/display/:id): WakeLock, яркость 1.0, immersive, временное снятие FLAG_SECURE (страховка 10 мин + restore в dispose/paused), auto-hide оверлеев 3 сек, ориентация per-card, генерация ean13/code128/pdf417/qr/manual с fallback на номер.
[x] 20.6 Аналитика товаров (домен/данные): пересчёт product_analytics_cache (атомарный batch), топ товаров (тренд = линейная регрессия), топ категорий, динамика цен (>= 3 месяцев), детализация товара, провайдеры периодов/скоупа/отчётов.
[x] 20.6b ProductAnalyticsScreen (/product-analytics): 4 периода, Multi-group скоуп, 3 таба отчётов, сводка, stale-баннер с пересчётом, пагинация «Показать ещё (N из M)», sheet детализации, экспорт CSV (BOM, ';') и PNG (RepaintBoundary + share_plus), deep-link ?product_hash=.
[x] 20.7 Интеграция: карточка «Аналитика товаров» в Профиле, пункт Drawer, закрыт TODO(20.7) (categoryId из алиасов), TODO(25) в коде, DECISIONS D20-1…D20-15, обновление контекста.
Точки входа Этапа 20: Drawer и Профиль → «Скидочные карты» и «Аналитика товаров»; FAB/empty states → добавление карты; тап по карте → полноэкранный показ; deep-links: /loyalty-cards/add?id=…, /product-analytics?product_hash=….
Техдолг Этапа 20 (всё TODO(25)): триггеры пересчёта кэша (confirm чека, Batch-импорт, WorkManager раз в сутки); cross-filter транзакций по product_hash; слайд YIR «Топ товаров»; синхронизация loyalty_cards и product_analytics_cache (E2E payload); zip-экспорт 3 PNG-отчётов и сохранение в Downloads.
Этап 21 «Security Settings + Profile + Spaces Management»: ЗАВЕРШЁН (2026-11-10)
[x] 21.1 Миграция v21: member_colors (unique user+space), app_settings +5 полей безопасности/цветов, users.avatar_path; SpaceModel catch-up.
[x] 21.1b Резолвер цветов семьи (core/providers/member_color_providers) + TODO(21) закрыт в loyalty_tile.
[x] 21.2 Датчики: ShakeDetector / FaceDownDetector / UserActivityObserver (sensors_plus), старт из app.dart по настройкам.
[x] 21.3 SecuritySettingsScreen (/settings/security?section=): баннер уровня защиты, онбординг-баннер, 5 секций, PIN/биометрия флоу, якоря.
[x] 21.4 SettingsScreen хаб (/settings): 8 секций, shared-виджеты, ClearLocalCacheUseCase.
[x] 21.5 SpacesManagementScreen (/settings/spaces): сводка, карточки, LeaveSpaceUseCase (4 сценария), create/join.
[x] 21.6 SpaceArchiveScreen (/spaces/:id/archive): баннер, stats 2×2, 4 таба read-only.
[x] 21.7 FamilyColorsSettingsScreen (/settings/family/colors): палитра 12 + кастом hex + reset, member_colors override.
[x] 21.8 ProfileScreen полный (/profile): header+аватар, EditProfileSheet (склонение), stats 2×2, пространства, статистика, DebtsSection, опасная зона.
[x] 21.9 Экспорт всех данных XLSX (3 листа) + PIN; экспорт ключей (.enc AES-GCM); очистка данных; PIN при передаче роли (D17-6 закрыт).
[x] 21.10a Ночной режим (v22 + блок пушей), ProductAliasesSettingsScreen, ExchangeRatesScreen, url_launcher, энфорсмент цветов семьи.
[x] 21.10b Автофильтр секретных (?filter=secret), документы этапа, аудит TODO.
Точки входа: Drawer «Безопасность»/«Настройки»; Профиль ⚙ → /settings; Settings → все подразделы.
Техдолг Этапа 21 (всё TODO(25)): глобальное отключение FLAG_SECURE по тумблеру; балансы на lock screen; Supabase RPC delete_user_account; синк avatar_path и member_colors (E2E); night_mode в расписании дайджестов.

Этап 21 «Security Settings + Profile + Spaces Management» (UX-рефакторинг 2026-11-11):
[x] UX-рефакторинг: профиль=семья/пространства/админ/цвета, настройки=конфиг, drawer в безопасности, одна кнопка редактирования, пуши группы в уведомлениях.
Точки входа: Drawer «Безопасность» (теперь с Drawer) → /settings/security; Профиль ⚙ → /settings; Профиль → «Мои пространства» (карточки + админ-панель + цвета участников + создать/присоединиться); Настройки → 7 секций (безопасность/уведомления/импорт/чеки/валюта/экспорт/о приложении).

Этап 22 «Accessibility (WCAG AA)»: ЗАВЕРШЁН (2026-11-12)

[x] 22.1 Core: lib/core/accessibility/ (AnimationUtils + HapticService с учётом reduce motion, MinimumTouchTarget 48×48, FocusableButton с клавиатурной навигацией, ArrowNavigableList, SemanticsX extensions); ограничение textScaler до 2.0 в app.dart; Semantics для TransactionRow, EmptyStateWidget, AppDrawer.
[x] 22.2 Контраст: ContrastChecker (WCAG 2.1 формула), обновлён AppColors (+colorHiddenMask #64748B, +light-токены для светлой темы), автотест всех цветовых пар (33 теста).
[x] 22.3 Semantics карточек: SavingsGoalCard, DebtCard, ReminderCard, LoyaltyCardTile, AccountCard, BudgetLimitCard, CategoryListItem, CashbackEntryCard — все с описательными label для TalkBack.
[x] 22.4 Навигация + альтернативы жестам: FAB (tooltip + Semantics), FilterChip-группы транзакций/долгов/напоминаний (состояние «выбран/не выбран»), перемещение карт вверх/вниз через меню (альтернатива drag-and-drop), пункт «Выполнено» в меню напоминаний (альтернатива свайпу).
[x] 22.5 Тесты: test/accessibility/ (contrast_test, touch_target_test, semantics_test, talkback_flow_test, keyboard_navigation_test) — все зелёные.

Точки входа: все экраны приложения (семантика встроена на уровне виджетов). Проверка: Настройки Android → TalkBack / Размер шрифта 2.0.

Техдолг Этапа 22 (всё TODO(25) или на усмотрение владельца):
[ ] Полная интеграция с экраном лояльности для «Переместить вверх/вниз» (меню готово, экран не передаёт onMoveUp/onMoveDown).
[ ] Semantics для графиков fl_chart (Dashboard ExpenseFlowChart, SavingsAnalytics) — ТЗ 6.10.4 рекомендует агрегированные описания.
[ ] Skip Links (WCAG 2.4.1) — кнопка «Пропустить до контента» для TalkBack.
[ ] Live Regions для Snackbar/ошибок форм (WCAG 4.1.3).
[ ] Autofill hints для TextField форм (1.3.5) — не блокирует, но улучшает.


Этап 23 «Performance + Error Handling»: ЗАВЕРШЁН (2026-11-12)
[x] 23.1 Ошибки: GlobalErrorHandler расширен (PlatformDispatcher.onError + слушатель изолята), фоновые задачи WorkManager в защищённой зоне (runGuardedBackground).
[x] 23.2 Retry: RetryPolicy с экспоненциальным бэкоффом и джиттером — в фоновом синке; pull-to-refresh без повторов.
[x] 23.3 Offline-состояния: AsyncValueWrapper (4 состояния: скелетон/ошибка+Retry/пусто/данные), FullScreenError без Lottie, Semantics на OfflineErrorCard/PendingSyncIndicator/SkeletonShimmer, фабрики скелетонов text/title/field/avatar.
[x] 23.4 Производительность: PerfMonitor (замер операций, порог 300мс, встроен в SyncService), IsolateRunner (compute + тайминг + лог), LeakGuard (debug-детекция утечек), DriftQueryExplainer (EXPLAIN QUERY PLAN 10 горячих запросов, -dart-define PERF_EXPLAIN=true).
[x] 23.5 Тесты: 5 unit-тестов RetryPolicy.
Точки входа: новых экранов нет (инфраструктурный этап).
Техдолг Этапа 23:
[ ] Sentry/Crashlytics — опционально, по решению владельца (сейчас только логирование).
[ ] Миграция существующих экранов на AsyncValueWrapper — постепенно, при будущих правках экранов.
[ ] Интеграция LeakGuard/IsolateRunner в существующие State/UseCases — точечно, при будущих правках.
[x] 23.6 Фикс AsyncValueWrapper: убран неиспользуемый retryTarget (ProviderListenable), оставлен только onRetry (VoidCallback) для совместимости с flutter_riverpod без добавления транзитивных зависимостей.
Этап 23.5 «Годовой отчёт (Excel-модель владельца)»: В РАБОТЕ (2026-11-13)
План: 23.5.1 Data/Domain (GROUP BY категория×месяц, Freezed-модели, UseCases, провайдеры); 23.5.2 YearBudgetScreen (вкладки Лимиты/Траты/Движение+Структуры, селекторы года и скоупа, итоги, средняя, %); 23.5.3 MonthStatsScreen (Выделено/Нераспределено редактируемые, Сумма/Лимит/Осталось с правкой лимитов, списки расходов/доходов месяца, автоподстановка из прошлого месяца); 23.5.4 XLSX-экспорт (динамическая копия); 23.5.5 Интеграция (Drawer, карточка Профиля, роуты, empty states, a11y).
Этап 23.7 «Скоуп операций: куда писать»: следующий после 23.5
План: 23.7.1 Миграция v23 + copy_group_id; 23.7.2 чипы скоупа в форме и импорте (лично авто, семьи явно); 23.7.3 связанные копии (правка/удаление по группе); 23.7.4 long-press «Пространство»; 23.7.5 чекбокс «Подключить мои личные транзакции» (разовый, дубли, диалоги); 23.7.6 документы + коммит.
Точки входа (план): Drawer «Годовой отчёт»; карточка в Профиле; тап по колонке месяца в матрице.
Техдолг и TODO Этапов 23.5/23.7 (оставлено на следующие изменения):
[ ] TODO(25): синк monthly_budgets, transactions.copy_group_id, memberships.share_personal_tx (E2E payload, таблицы Supabase).
[ ] TODO(24): unit-тесты математики матриц (средняя, профицит, крупные покупки) и групп копий.
[ ] Долг: агрегат-режим «Все пространства» в логе транзакций — сейчас не делаем.
[ ] Долг: унификация семейного скоупа «Статистики года» (D19-13) и годового отчёта (D23.5-6) — решение владельца позже.
[ ] Долг: пояснения категорий (лист «настройки» Excel владельца) — тултипы в будущем.
[ ] Долг: PNG-экспорт матриц исключён (достаточно XLSX).
Roadmap.docx не редактируется (правило 22-3, бинарный); статус этапов ведётся здесь.
Этап 23.5 «Годовой отчёт (Excel-модель владельца)»: РЕАЛИЗОВАН (2026-11-13, ожидает приёмки)
[x] 23.5.1 Data: таблица monthly_budgets (v23), YearBudgetDao (матрицы трат/доходов/лимитов/месяца/годы), YearBudgetRepositoryImpl.
[x] 23.5.2 Domain: Freezed-модели, CalculateYearBudgetUseCase, CalculateMonthStatsUseCase, SaveMonthBudgetUseCase, ExportYearBudgetXlsxUseCase + OOXML-writer.
[x] 23.5.3 UI: YearBudgetScreen (чипы скоупа, выбор года, 4 вкладки, матрицы с синхронным скроллом, график fl_chart, итоги), MonthStatsScreen (Выделено/Нераспределено, категории Сумма/Лимит/Осталось с правкой, списки операций, баннер переноса из прошлого месяца).
[x] 23.5.4 Интеграция: роуты /year-budget и /month-stats, пункт Drawer «Годовой отчёт», privacy visible/hidden, экспорт заблокирован в hidden.
Точки входа: Drawer → «Годовой отчёт»; тап по месяцу в матрице/движении → «Месячная статистика».
Техдолг Этапа 23.5:
[ ] Карточка «Годовой отчёт» в Профиле — микро-скрипт после сбора profile_screen.dart (правило 1).
[ ] «Сохранить в память» (MediaStore) для XLSX отчёта — после верификации MainActivity.kt (TODO(23.7)).
[ ] Полностью автоматический carry-forward (сейчас — кнопка-баннер) — по желанию владельца.
[ ] Синк monthly_budgets (E2E payload, таблица Supabase) — TODO(25).
[ ] Unit-тесты математики матриц (средняя, профицит, крупные) — Этап 24.
Нумерация (2026-11-13, уточнение владельца): 23.5 — Годовой отчёт (Excel-модель); 23.6 — «Скоуп операций: куда писать» (чипы в форме и импорте, связанные копии, long-press «Пространство», дубли галки подключения личных); 23.7 — AsyncValueWrapper (проверка D23-6 по коду, регресс-тест, миграция оставшихся экранов на обёртку). Прежние записи «23.7 = скоуп операций» читать как 23.6.
Этап 23.6a «Скоуп операций: ядро»: РЕАЛИЗОВАН (2026-11-13, ожидает приёмки)
[x] Миграция v24: transactions.copy_group_id + индекс.
[x] AddTransactionCopiesUseCase / SetTransactionSpacesUseCase + провайдеры + TransactionGroupScopes (freezed).
[x] Форма создания: чипы «Куда записать» (Личное locked, семьи по отметке, «Выбрать все»), копии после сохранения.
[x] Long-press «Пространство»: шит состава группы копий.
[x] Update/DeleteTransactionUseCase: propagation на копии группы (включая сплиты).
Этап 23.6b (следующий): чипы скоупа в импорте; дубли галки «Подключить мои личные транзакции» (карточка пространства для всех ролей + настройки пространства + вступление), флаг per-member (миграция v25); «Сохранить в память» для XLSX годового отчёта (MethodChannel budget_assistant/clock saveToDownloads, сигнатура верифицирована по SpaceSettingsScreen).
Этап 23.6b-2 (2026-11-13): графики файла владельца добавлены (столбцы Доходы-расходы / Профицит / Сумма трат; круговые Структура доходов / Структура расходов / Средние лимиты; круговая структура расходов месяца). Верхний уровень отчёта = вкладки «Анализ 1» (Лимиты/Траты/Итоги) и «Анализ 2» (движение+графики+структуры) — соответствие листам файла. В месячной статистике: боковое меню и круговая диаграмма. Форма создания: все семейные пространства отмечены по умолчанию (личное всегда). Баннер переноса уточнён: лимиты категорий + «Выделено».
Осталось в 23.6c: чипы скоупа в импорте; дубли галки «Подключить мои личные транзакции» (карточка пространства + настройки + вступление, флаг per-member, миграция v25); карточка «Годовой отчёт» в Профиле.
Этап 23.6c «Скоупы импорта + подключение личных»: РЕАЛИЗОВАН (2026-11-13, ожидает приёмки)
[x] Миграция v25: personal_share_flags + UNIQUE(user_id, space_id).
[x] SetPersonalShareUseCase (разовое присоединение, счёт личных операций, флаг) + провайдеры + PersonalShareTile (диалоги включения/выключения).
[x] Чекбокс доступен всем ролям: карточка пространства («Мои пространства»), настройки пространства, экран вступления, создание группы.
[x] Импорт: чипы «Куда записать» (базовый скоуп заблокирован, остальные по умолчанию отмечены), связанные копии после финализации; AddTransactionCopiesUseCase расширен includePersonal.
[x] Профиль: карточка «Годовой отчёт».
Техдолг: синк personal_share_flags и copy_group_id — TODO(25); unit-тесты копий и матриц — Этап 24.
Следующий этап: 23.7 — AsyncValueWrapper (проверка D23-6 по коду, регресс-тест, миграция оставшихся экранов).
Этап 23.7 «AsyncValueWrapper»: 23.7a РЕАЛИЗОВАН (2026-11-13)
[x] Верификация D23-6 по коду: onRetry (VoidCallback), retryTarget отсутствует.
[x] Регресс-тесты test/widgets/async_value_wrapper_test.dart (10 кейсов).
[x] Идемпотентный фикс year в _analysis2 годового отчёта.
[ ] 23.7b: миграция экранов на AsyncValueWrapper (spaces_management, space_settings, profile, post_import_review) — после свежего сбора контекста.
Техдолг: остальные экраны переводятся постепенно при будущих правках (долг Этапа 23).
Этап 23.7b «Миграция экранов на AsyncValueWrapper»: РЕАЛИЗОВАН (2026-11-13)
[x] SpacesManagementScreen: полная обёртка (пусто → кнопки «Создать» / «Присоединиться»), галка подключения личных сохранена.
[x] SpaceSettingsScreen: обёртка для проверки доступа и загрузки данных; membersCount поднят в _content.
[x] ProfileScreen: единые виджеты состояний (скелетон, OfflineErrorCard с «Повторить», EmptyStateWidget).
Техдолг: полный перенос ProfileScreen на обёртку (выделить тело в ConsumerWidget); вложенные секции stats — точечно при будущих правках.
Этап 23.7 закрыт: 23.7a (верификация D23-6 + 10 регресс-тестов) + 23.7b (миграция экранов).
════════════════════════════════════════════════════════════════
СВОДКА ЭТАПОВ 23.5–23.7 (финальная документация, 2026-11-13)
Блок консолидирует и уточняет прежние частичные записи по этим этапам.
Нумерация: 23.5 — Годовой отчёт; 23.6 (a/b/c) — скоуп операций; 23.7 (a/b) — AsyncValueWrapper.
Roadmap.docx не редактируется (правило 22-3); статус этапов ведётся здесь.
════════════════════════════════════════════════════════════════

Этап 23.5 «Годовой отчёт (Excel-модель владельца)»: ЗАВЕРШЁН
[x] 23.5.1 Data: таблица monthly_budgets (миграция v23, UNIQUE user+space+year+month), YearBudgetDao (матрицы трат/доходов категория×месяц, лимиты месяца, категории скоупа + allCategories, доступные годы, операции месяца со сплит-позициями), YearBudgetRepositoryImpl.
[x] 23.5.2 Domain: Freezed-модели (YearBudgetData, YearCategoryRow, YearCashflowMonth, MonthStatsData, MonthCategoryRow, MonthTxRow, MonthStatsKey, CategoryInfo, YearCatMonthSum); CalculateYearBudgetUseCase, CalculateMonthStatsUseCase, SaveMonthBudgetUseCase (saveAllocated / saveLimit / carryOver), ExportYearBudgetXlsxUseCase + YearBudgetXlsxWriter (OOXML через archive).
[x] 23.5.3 UI: YearBudgetScreen — чипы скоупа («Лично» + имена групп), выбор года, вкладки «Анализ 1» (Лимиты / Траты / Итоги) и «Анализ 2» (движение + графики + структуры); MatrixTable с закреплённой колонкой категорий и синхронным горизонтальным скроллом; тап по шапке месяца открывает месячную статистику.
[x] 23.5.4 Графики владельца: столбцы «Доходы-расходы», «Профицит», «Сумма трат»; круговые «Структура доходов», «Структура расходов», «Средние лимиты»; в месячной статистике — круговая структуры расходов месяца.
[x] 23.5.5 MonthStatsScreen: Выделено (редактируется) / Нераспределено (вычисляется), категории Сумма / Лимит / Осталось с правкой лимита по тапу, списки расходов и доходов месяца, баннер переноса значений из прошлого месяца, стрелки ← →, боковое меню.
[x] 23.5.6 Экспорт XLSX: листы «Анализ 1», «Анализ 2» + листы месяцев ТОЛЬКО с данными; диалог «Сохранить» (MediaStore Downloads/BudgetAssistant) / «Поделиться» (Share Sheet); в hidden экспорт заблокирован.
[x] 23.5.7 Интеграция: роуты /year-budget и /month-stats, пункты Drawer «Годовой отчёт» и «Месячная статистика», карточка «Годовой отчёт» в Профиле, privacy visible/hidden.

Этап 23.6 «Скоуп операций: куда писать» (a/b/c): ЗАВЕРШЁН
[x] 23.6a Миграция v24: transactions.copy_group_id + idx_transactions_copy_group.
[x] 23.6a AddTransactionCopiesUseCase / SetTransactionSpacesUseCase + провайдеры + TransactionGroupScopes (freezed) + шит «Пространство».
[x] 23.6a Форма создания: чипы «Куда записать» (Личное всегда, семьи по умолчанию отмечены, «Выбрать все»), связанные копии после сохранения.
[x] 23.6a Long-press операции → «Пространство»: добавить / переместить / убрать копию; пустой состав запрещён.
[x] 23.6a Update/DeleteTransactionUseCase: propagation на все копии группы (включая сплиты).
[x] 23.6b Фиксы: строки матриц из объединения категорий (пустые ячейки при ненулевой сумме), вход в месячную статистику, графики владельца, вкладки Анализ 1/2, авто-отметка семей, снят дубль колонки copyGroupId, объявлен year в _analysis2.
[x] 23.6c Миграция v25: personal_share_flags + UNIQUE(user_id, space_id) в beforeOpen.
[x] 23.6c SetPersonalShareUseCase (countPersonal / isEnabled / разовое присоединение / performAttach) + провайдеры + PersonalShareTile с диалогами включения и выключения.
[x] 23.6c Чекбокс «Подключить мои личные транзакции» доступен всем ролям: карточка пространства в «Мои пространства», настройки пространства, экран вступления, создание группы.
[x] 23.6c Импорт: чипы «Куда записать» (базовый скоуп заблокирован), связанные копии после финализации; AddTransactionCopiesUseCase расширен includePersonal.

Этап 23.7 «AsyncValueWrapper» (a/b): ЗАВЕРШЁН
[x] 23.7a Верификация D23-6 по коду: onRetry (VoidCallback), retryTarget отсутствует.
[x] 23.7a Регресс-тесты test/widgets/async_value_wrapper_test.dart — 10 кейсов (4 состояния, кастомный loadingBuilder, Retry-колбэк, onRetry=null, действие empty, isEmpty=null). Все зелёные.
[x] 23.7b SpacesManagementScreen: полная обёртка (пусто → кнопки «Создать пространство» / «Присоединиться по приглашению»); галка подключения личных сохранена.
[x] 23.7b SpaceSettingsScreen: обёртка для проверки доступа и загрузки данных; membersCount поднят в _content.
[x] 23.7b ProfileScreen: единые виджеты состояний (скелетон, OfflineErrorCard с «Повторить», EmptyStateWidget).

Точки входа
- Боковое меню → «Годовой отчёт» (/year-budget) и «Месячная статистика» (/month-stats).
- Профиль → карточка «Годовой отчёт».
- Годовой отчёт → тап по названию месяца в шапке матрицы / строке движения / иконка календаря → месячная статистика.
- Месячная статистика → стрелки ← → (переключение месяцев), тап по категории (правка лимита), карандаш у «Выделено», баннер «Подставить».
- Форма создания операции → блок «Куда записать»; long-press операции → «Пространство».
- Импорт → экран проверки → блок «Куда записать».
- «Мои пространства» / настройки пространства / вступление по приглашению / создание группы → чекбокс «Подключить мои личные транзакции».

Схема БД после этапов
schemaVersion = 25.
v23: monthly_budgets (+ UNIQUE user_id, space_id, year, month; индекс lookup).
v24: transactions.copy_group_id (+ idx_transactions_copy_group).
v25: personal_share_flags (+ UNIQUE(user_id, space_id) в beforeOpen).
Деньги — ТОЛЬКО IntColumn (копейки). Даты — ТОЛЬКО UTC; группировка по локальному месяцу через datetime(date,'unixepoch','localtime').

Журнал фиксов 23.5–23.7 (анти-регрессия)
- SQL-литералы с одинарными кавычками внутри одинарных Dart-строк ломали парсер и кодогенерацию → SQL пишем в двойных кавычках.
- Regex с Singleline и жадным .* съел хвост файла экспорта (пропали _analysis1/_analysis2/_monthSheet) → только ленивые .*? с явным терминатором.
- Guard идемпотентности искал строку по всему файлу и ложно срабатывал (year в _analysis2) → проверять внутри целевого метода.
- Дубль колонки copyGroupId после повторного запуска патча → патчи колонок идемпотентны по маркеру.
- Неверный путь импорта product_analytics_strings в Drawer → presentation/labels.
- Share.shareXFiles устарел и ждал XFile → SharePlus.instance.share(ShareParams(files: [XFile(path)])).
- BudgetLimitsCompanion.insert: createdAt/updatedAt передаются сырыми DateTime, не Value.
- select()/update()/delete() в репозитории — только через _db.; в DAO — напрямую из mixin.
- Имена сгенерированных data-классов не угадываем: DAO возвращает record'ы.

Техдолг и TODO этапов 23.5–23.7
[ ] TODO(25): синхронизация monthly_budgets, personal_share_flags, transactions.copy_group_id (E2E payload + таблицы Supabase).
[ ] TODO(24): unit-тесты математики матриц (средняя, профицит, крупные покупки, сплиты), групп копий и carryOver.
[x] Сторно/возврат (markAsRefund) пропагируется на все копии группы; новые компенсации связываются отдельным copy_group_id.
[ ] Полный перенос ProfileScreen на AsyncValueWrapper (выделить тело в отдельный ConsumerWidget).
[ ] Вложенные секции stats остаются на .when — точечная миграция при будущих правках.
[ ] Агрегат-режим «Все пространства» в журнале транзакций — не реализован.
[ ] Унификация семейного скоупа «Статистики года» (D19-13) и годового отчёта (D23.5-6) — решение владельца позже.
[ ] Пояснения категорий (лист «настройки» Excel владельца) — тултипы в будущем.
[ ] PNG-экспорт матриц исключён (достаточно XLSX).
[ ] Полностью автоматический carry-forward лимитов (сейчас — кнопка-баннер).
[ ] Semantics для новых графиков fl_chart (долг Этапа 22).
Следующий этап по роадмапу: 24 «Testing (Unit + Widget + Integration)».
РЕЕСТР ДОЛГОВ 23.5-23.7 (актуальный на 2026-11-13, заменяет прежние списки долгов)
Формат: TODO(N) - закрывается в этапе N; BACKLOG - нужно решение владельца; НЕ ДЕЛАЕМ - зафиксированное решение.
Источник правды по долгам - этот реестр. Маркеры TODO(N) в коде дублируют записи реестра.

TODO(23.8) - ЗАКРЫТ (2026-11-13, Этап 23.8)
[x] Сторно/возврат (markAsRefund) пропагируется на все копии группы; новые компенсации связываются отдельным copy_group_id.
Маркеры TODO(23.8) сняты из update/delete usecases.

TODO(24) - тесты
[ ] Unit: математика матриц - средняя (деление на месяцы с данными), профицит, крупные покупки без задвоения, сплиты, 'Без категории' и чужой скоуп.
[ ] Unit: месячная статистика - Сумма/Лимит/Осталось, Нераспределено, состав категорий.
[ ] Unit: carryOver (лимиты категорий + Выделено), saveLimit для семьи (одна строка на группу).
[ ] Unit: группы копий - создание/перемещение/удаление, запрет пустого состава, обнуление copy_group_id, propagation правки и удаления, сплиты копий, includePersonal.
Маркеры: calculate_year_budget_usecase.dart, calculate_month_stats_usecase.dart, year_budget_repository_impl.dart, add_transaction_copies_usecase.dart, set_transaction_spaces_usecase.dart, update_transaction_usecase.dart, delete_transaction_usecase.dart.

TODO(25) - синк и доступность перед релизом
[ ] Синк monthly_budgets, personal_share_flags, transactions.copy_group_id (E2E payload + таблицы Supabase).
[ ] Semantics для новых графиков fl_chart (долг Этапа 22).
Маркеры: year_budget_repository_impl.dart, set_personal_share_usecase.dart, add_transaction_copies_usecase.dart, cashflow_chart.dart, structure_pie.dart.

BACKLOG - нужно решение владельца, этап не назначен
[ ] Агрегат-режим 'Все пространства' в журнале транзакций.
[ ] Унификация семейного скоупа 'Статистики года' (D19-13) и годового отчёта (D23.5-6).
[ ] Пояснения категорий (лист 'настройки' Excel владельца) - тултипы.
[ ] Полностью автоматический carry-forward лимитов (сейчас - кнопка-баннер).
[ ] Полный перенос ProfileScreen на AsyncValueWrapper (выделить тело в ConsumerWidget).
[ ] Вложенные секции stats на .when -> обёртка.

НЕ ДЕЛАЕМ (решение, не долг)
- PNG-экспорт матриц: достаточно XLSX (D23.5-12).

Этап 23.8 «Сторно на копии группы»: ЗАВЕРШЁН (2026-11-13)
[x] MarkAsRefundUseCase: сторно исходной операции + сторно каждой копии группы (тот же метод репозитория).
[x] Новые компенсации связываются отдельным copy_group_id (детерминированный diff id доходов до/после).
[x] Ошибка пропагации логируется и не отменяет основное сторно.
[x] Long-press меню: после сторно bump transactionsTriggerProvider (дашборд/годовой отчёт обновляются).
[x] Маркеры TODO(23.8) сняты из update/delete usecases; реестр долгов обновлён.
Техдолг: unit-тесты пропагации сторно и связывания компенсаций — TODO(24) в mark_as_refund_usecase.dart.
Следующий этап по роадмапу: 24 «Testing (Unit + Widget + Integration)».

════════════════════════════════════════════════════════════════
ЭТАП 24 «Testing (Unit + Widget + Integration)»: БАЗОВЫЙ КОНТУР ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что сделано
[x] 24a Инфраструктура: test/helpers/test_db.dart (Drift NativeDatabase.memory + фикстуры TestSeed: копейки, UTC, порядок FK), sqlite_probe.dart (авто-skip тестов БД без нативного SQLite), fake_year_budget_repository.dart.
[x] 24a Unit: годовые матрицы (18), месячная статистика (18), SaveMonthBudgetUseCase (7, mocktail), экспорт XLSX (4).
[x] 24b Drift in-memory: YearBudgetDao (10) и YearBudgetRepositoryImpl (10) — сплиты, крупные, фильтры P&L, «Без категории», скоупы, локальный месяц, carryOver, saveLimit семьи, «Выделено».
[x] 24c Группы копий (12) + propagation правки/удаления (8); PrivacyFormatter — вся матрица 6.6 в режимах visible/hidden (20); EmptyStateWidget (6); offline-состояния (10).
[x] 24d Сторно на копии группы (4); SQL-фильтры журнала транзакций (18); Integration-B «создать → pending → синк → pull-to-refresh» (5).
[x] 24-F Фикс: idx_monthly_budgets_unique + idx_monthly_budgets_lookup создаются в beforeOpen (на чистой установке их не было) + дедубль перед созданием + 3 регресс-теста.
[x] 24-F Маркеры TODO(24) сняты: 8 файлов lib + 4 комментария в тестах. Реестр долгов обновлён.
[x] tool/coverage_report.dart — отчёт покрытия по lcov + инвентаризация файлов домена по фичам.

Итог прогона: все тесты зелёные (228 + 3 новых регресс-теста), flutter analyze без замечаний.
Покрытие строк: year_budget/domain 298/298 (100%), transactions/domain 327/402 (81%).
Домен всего: 21 из 311 файлов затронуты тестами (6.8%). Гейт Roadmap «Coverage >= 80% для domain layer» НЕ достигнут — см. TODO(24.1–24.5).

Integration: выбран вариант B (решение владельца) — хостовый сквозной тест test/integration/offline_sync_flow_test.dart (настоящие UseCases + репозитории + Drift в памяти, сеть — заглушка). Пакеты integration_test и patrol НЕ добавлялись. Прогон на эмуляторе с WorkManager — ручной смоук Этапа 25.

Как запускать тесты на Windows
1. В корне проекта должен лежать официальный sqlite3.dll (sqlite.org → sqlite-dll-win-x64-*.zip). Системный winsqlite3.dll НЕ подходит: не поддерживает модификатор 'unixepoch', матрицы молча возвращают пусто.
2. flutter test --coverage
3. dart run tool/coverage_report.dart --min=80 --scope=lib/features/year_budget/domain
Список файлов домена без тестов пишется в coverage/untested_domain.txt. sqlite3.dll и coverage/ в .gitignore.

РЕЕСТР ДОЛГОВ ЭТАПА 24 (заменяет прежний список TODO(24))
TODO(24) — ЗАКРЫТ
[x] Unit: математика матриц — средняя, профицит, крупные без задвоения, сплиты, «Без категории», чужой скоуп.
[x] Unit: месячная статистика — Сумма/Лимит/Осталось, Нераспределено, состав категорий.
[x] Unit: carryOver (лимиты + Выделено), saveLimit для семьи.
[x] Unit: группы копий — создание/перемещение/удаление, пустой состав, обнуление copy_group_id, propagation правки/удаления/сторно, сплиты, includePersonal.

TODO(24.1–24.5) — кампания покрытия домена (гейт >= 80%)
[ ] TODO(24.1) Деньги: budget (P&L, эффективный лимит, алерты), accounts (Net Worth, CRUD), конвертация валют.
[ ] TODO(24.2) Кэшбэк (5 жёстких правил), категории, дашборд.
[ ] TODO(24.3) Цели, долги (Сценарии А/Б), напоминания (RRULE), календарь и прогноз.
[ ] TODO(24.4) Импорт (дубли, переводы, парсеры), чеки (хэш, матчинг, аналитика товаров).
[ ] TODO(24.5) Лояльность, админка/инвайты, пространства, настройки, security, year_in_review.
Маркеры в коде не ставятся: долг измеримый, источник правды — отчёт tool/coverage_report.dart (coverage/untested_domain.txt).

TODO(25) — без изменений (12 маркеров в коде: синк monthly_budgets/personal_share_flags/copy_group_id, пуши импорта, триггеры кэша аналитики, Semantics графиков, FLAG_SECURE, RPC удаления аккаунта).
BACKLOG и «НЕ ДЕЛАЕМ» — без изменений.

════════════════════════════════════════════════════════════════
ЭТАП 24 — ХОТФИКСЫ ПОСЛЕ СМОУКА (шаги 24.0.1 / 24.0.2), 2026-11-14
════════════════════════════════════════════════════════════════
Что исправлено
[x] 24.0.1 ANR «приложение не отвечает»: SQLite в фоновом изоляте; подписка DeepLinkBus в initState вместо build; стартовые задачи один раз; WorkManager и воркеры регистрируются после runApp; лимиты года — 1 запрос вместо 12, прошлый бюджетный месяц — 2 вместо 48 (D24-10, D24-11).
[x] 24.0.1 Синк: отсутствующая таблица Supabase определяется как RemoteSchemaMissingException, синк выходит сразу без повторов (было 9538 мс на пустом месте) (D24-12).
[x] 24.0.2 Дубли копий: журнал «Все» показывает одну строку на группу; «Личное» = группы с личной копией; сводка дня и «Движение расходов» на дашборде, P&L и расход категории считают группу один раз; статистика «Лично» = мой вклад (D24-9).
[x] 24.0.2 Бейдж: «Личное» только у личных операций, у общих — пусто (D24-9a).
[x] Ассерт ListTile в настройках пространства: плитки обёрнуты в собственный Material, волна нажатия видна (D24-13).

Итог: 254 теста зелёные, flutter analyze без замечаний.
Смоук на эмуляторе пройден: ANR исчез, дашборд показывает 15 ₽ вместо 30, красных логов нет.

Новые тесты хотфиксов
- test/features/dashboard/data/dashboard_expense_flow_test.dart — «Движение расходов», окно 30 дней, дедубль групп.
- test/features/budget/data/budget_pnl_dedup_test.dart — P&L и расход категории без задвоения.
- test/features/sync/sync_schema_missing_test.dart — выход без повторов при отсутствующей схеме; обычные сетевые ошибки по-прежнему ретраятся.
- test/features/transactions/data/transaction_group_visibility_test.dart — видимость групп в журнале и сводка дня.
- test/core/database/dao/year_budget_dao_test.dart — переписан под «мой вклад» + 6 тестов дедубля.

Известное ограничение (не баг приложения)
В Supabase не развёрнуты таблицы (PGRST205: public.accounts, public.transactions). Синк корректно пропускается, локальные данные остаются pending. Схема создаётся на Этапе 25.

Реестр долгов
TODO(24) — закрыт. TODO(24.1–24.5) — кампания покрытия домена, без изменений.
Покрытие: источник правды — tool/coverage_report.dart (coverage/untested_domain.txt).
Следующий шаг: 24.1 «Деньги» — budget (P&L, эффективный лимит, алерты), accounts (Net Worth, CRUD), конвертация валют.

════════════════════════════════════════════════════════════════
ЭТАП 24.1a «ДЕНЬГИ»: ЛИМИТЫ, P&L, АЛЕРТЫ, ВАЛЮТЫ, ФОРМАТИРОВАНИЕ — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (71 новый тест)
[x] GetEffectiveLimitUseCase (10): заданный лимит, наследование прошлого месяца, выключенное наследование, перенос остатка, перерасход не переносится, наследование+перенос вместе, январь смотрит на декабрь, нулевой лимит без деления на ноль, отрицательный остаток, ошибка репозитория.
[x] CalculateMonthlyPnlUseCase (4): доходы/расходы/норма сбережений, нулевой доход, проброс аргументов включая «без крупных трат», ошибка.
[x] Upsert/DeleteBudgetLimitUseCase (5): новый лимит с pending и UTC, повторное сохранение по id, семейный скоуп, удаление, ошибка.
[x] CheckBudgetAlertsUseCase (7, Drift in-memory): global_percent достигнут/не достигнут, global_amount, individual с relatedEntityId, дедубль глобального и индивидуального за 24 часа, неизвестный режим.
[x] ConvertCurrencyUseCase (6): та же валюта без запроса курса, конвертация, округление половины вверх, дробный курс, отсутствие курса -> null, ошибка пробрасывается.
[x] ExchangeRateRepositoryImpl (11, Drift in-memory): все 5 приоритетов цепочки, кросс через RUB, окно 7 дней, устаревший курс, ленивая загрузка ЦБ с кэшем, кэш неудачных дат, upsert/delete.
[x] Money (28): MoneyInputParser, MoneyFormatter, MoneyTextInputFormatter, ReceiptMoneyUtils.

Исправленный дефект
CheckBudgetAlertsUseCase: глобальные алерты не дедуплицировались (NULL vs пустая строка) — D24-14.

Итог: 325 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_budget_limits_repository.dart — заглушка репозитория лимитов.
Следующий шаг: 24.1b «Счета» — Net Worth, CRUD счетов, сортировка, ипотека в чистом капитале.

════════════════════════════════════════════════════════════════
ЭТАП 24.1b «СЧЕТА»: NET WORTH, CRUD, СОРТИРОВКА, ИПОТЕКА — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (41 новый тест)
[x] CalculateNetWorthUseCase (11): пустой список, сумма обычных счетов, капитал по ипотеке (стоимость минус остаток), ипотека без записи mortgages, кредит вычитается, кредитка с минусом, архивные/системные считаются (текущее поведение), чужие счета исключены, ошибка репозитория; Mortgage.calculateNetWorthContribution — положительный и отрицательный капитал.
[x] CreateAccountUseCase (6): ensureLocalUser ДО вставки (FK), pending + UTC + непустой id, значения по умолчанию, семейный счёт и кредитные поля, копейки без изменений, ошибка без записи.
[x] UpdateAccountUseCase (8): пустое имя и имя из пробелов, неизвестный тип, все допустимые типы, обрезка пробелов, проброс полей, исключение -> DatabaseFailure, готовая ошибка репозитория пробрасывается.
[x] Delete/SortOrder (8): удаление, каскад ипотеки, ошибка, сортировка одного счёта, сброс в null, пакетная сортировка 0..n-1, пустой список, ошибка.
[x] AccountRepositoryImpl (8, Drift in-memory): вставка/чтение, идемпотентный ensureLocalUser, правка -> pending, сортировка в watchAccountsByUserId, каскадное удаление ипотеки, чтение ипотеки, системный счёт по флагу, Account <-> AccountModel round-trip.

Итог: 366 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_account_repository.dart + фабрики makeAccount / makeMortgage.

РЕЕСТР ДОЛГОВ — НОВОЕ
TODO(24.1c) — расхождения по счетам, требуют решения владельца (код не менялся, тесты закрепили факт):
[ ] Net Worth не включает виртуальные копилки: savings_goals.current_amount без linked_account_id (ТОМ 4 §5.2 требует).
[ ] Net Worth не исключает isArchived и isSystem счета.
[ ] CreateAccountUseCase без валидации названия и типа (в UpdateAccountUseCase валидация есть).
[ ] AccountRepositoryImpl.getOrCreateSystemAccount пишет userId = '' -> нарушение FK. Метод не используется: виртуальные цели пополняются с выбранного счёта (D12-3). Кандидат на удаление.

Следующий шаг: 24.2 «Кэшбэк» — 5 жёстких правил матрицы, категории, дашборд.

════════════════════════════════════════════════════════════════
ЭТАП 24.2a «КЭШБЭК»: 5 ПРАВИЛ, ЦИКЛЫ, МАТРИЦА ВЫГОДЫ — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (42 новых теста)
[x] CalculateCashbackUseCase (15): пустой список и ненайденный счёт; Правило 1 — сплит-чек считается только по позициям нужной категории, сплит без позиций не даёт базы; Правило 2 — конвертация в валюту карты по курсу на дату, отсутствие курса пропускает транзакцию, совпадение валют не вызывает конвертер; Правило 4 — NET = траты минус возвраты той же категории, база не уходит в минус, возврат другой категории не влияет; Правило 5 — границы цикла передаются в репозиторий, недельная и месячная записи считаются раздельно; транзакция и запись без категории; ошибка пробрасывается.
[x] GetCashbackCycleBoundsUseCase (10): неделя обнуляется в ПОНЕДЕЛЬНИК 00:00 (среда, понедельник, воскресенье, переход через месяц, длина ровно 7 дней); месяц — 1-го числа 00:00 (середина, декабрь -> январь, 1-е число); неизвестный тип = месячный; границы в UTC.
[x] CalculateCashbackMatrixUseCase (7): пустой список счетов, одна карта, лучшая карта по проценту, тай-брейк по фактическому кэшбэку при равных процентах, пустая ячейка у карты без категории, сортировка строк по убыванию, группировка категории без id по названию.
[x] UpdateCashbackEntryStatusUseCase (4): approved, potential, неизвестный статус отклоняется без записи, ошибка репозитория.
[x] CashbackRepositoryImpl (6, Drift in-memory): Правило 3 — переводы, ignored, копилки, изъятия и записи вне цикла исключены; доходы попадают в выборку для NET; сплиты по идентификаторам; мои счета без системных и архивных; смена статуса -> pending; валюта счёта.

Итог: 408 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_cashback_repository.dart, test/helpers/fake_exchange_rate_repository.dart.

Известное допущение (как в коде)
Суммы сплит-позиций считаются уже в валюте счёта — конвертация к ним не применяется. Мультивалютные сплиты пока не поддерживаются.

РЕЕСТР ДОЛГОВ — НОВОЕ
TODO(24.2c) — [ ] DeleteCategoryUseCase не проверяет Result репозитория: при Failure возвращает Success, UI показывает «удалено». Найдено при чтении кода, тест закрепляет текущее поведение.

Следующий шаг: 24.2b «Категории» — CRUD, валидация, автокатегоризация по правилам.

════════════════════════════════════════════════════════════════
ЭТАП 24.2b «КАТЕГОРИИ»: CRUD, ВАЛИДАЦИЯ, АВТОКАТЕГОРИЗАЦИЯ — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (34 новых теста)
[x] CreateCategoryUseCase (7): пустое имя и имя из пробелов, неизвестный тип, три допустимых типа, pending + UTC + обрезка имени, закрепление для кэшбэка и оформление, ошибка репозитория.
[x] UpdateCategoryUseCase (6): пустое имя, неизвестный тип, запрет родителя «сам себе», обрезка и проброс полей, исключение -> DatabaseFailure, готовая ошибка пробрасывается.
[x] DeleteCategoryUseCase (3): делегирование, исключение -> DatabaseFailure, текущее поведение с игнорированием Failure.
[x] AutoCategorizeTransactionUseCase.execute (8): пустой мерчант без запроса правил, отсутствие правил, подстрока без учёта регистра, несовпадение банка, банк ANY, первое совпавшее правило, проброс банка и скоупа, ошибка.
[x] AutoCategorizeTransactionUseCase.createRule (5): пустой триггер, пустая целевая категория, pending + UTC + обрезка триггера, bankName без обрезки (текущее поведение), ошибка.
[x] CategoryRule.matches (3) и признаки типа категории (2).

Итог: 442 теста зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_category_repository.dart + фабрики makeCategory / makeRule.

РЕЕСТР ДОЛГОВ — TODO(24.2c) дополнен
[ ] DeleteCategoryUseCase не проверяет Result репозитория: при Failure возвращает Success, UI показывает «удалено».
[ ] AutoCategorizeTransactionUseCase.createRule не обрезает bankName: пробелы ломают точное сравнение в CategoryRule.matches, правило никогда не срабатывает.

Следующий шаг: 24.2c «Дашборд» (раскладка виджетов), затем 24.3 «Цели, долги, напоминания».

════════════════════════════════════════════════════════════════
ЭТАПЫ 24.2c «ДАШБОРД» и 24.3a «ЦЕЛИ: ЖИЗНЕННЫЙ ЦИКЛ И МАТЕМАТИКА» — ЗАВЕРШЕНЫ (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (51 новый тест)
[x] DashboardLayoutRepositoryImpl (7, Drift in-memory): 4 виджета по умолчанию («Лимиты» скрыт), порядок 0..3, идемпотентность ensureDefaults, сохранение уже настроенной раскладки, saveLayout меняет видимость/порядок и ставит pending, повторное сохранение без дублей, UseCase делегирует и пробрасывает ошибку.
[x] DashboardDataRepository.getActiveCashback (4, Drift in-memory): только approved, истёкшие исключены, чужие счета не попадают, сортировка по ближайшей дате окончания.
[x] DashboardWidgetType (1): человекочитаемые названия всех виджетов.
[x] Жизненный цикл цели (19): создание (UTC, pending, стартовое зачисление, отрицательное обнуляется, проброс скоупа/счёта/дедлайна), правка (прогресс не меняется, null снимает дедлайн и привязку), прогресс (пополнение, первое достижение true, повторное false, изъятие сверх остатка отклоняется, несуществующая цель), завершение/архив/восстановление/привязка, ошибки репозитория.
[x] Математика целей (20): признаки цели (виртуальная/активная/достигнута/процент с потолком 100), план накопления (нулевая цель, без дедлайна, с дедлайном, дедлайн в прошлом), сводка (пусто, одна валюта без конвертации, другая валюта по курсу, нет курса -> hasStaleRates), статистика архива, сортировка таблицы по 5 полям + отсутствие мутации исходного списка.

Итог: 493 теста зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_savings_goals_repository.dart + фабрика makeGoal.

Наблюдение (проверю тестом в 24.3b)
CalculateSavingsGoalsSummaryUseCase: флаг hasStaleRates ставится только при неудачной конвертации целевой суммы; для накопленной суммы ветка else отсутствует. На практике обе конвертации идут с одной валютой и датой, поэтому расхождение не проявляется, но код асимметричен.

Следующий шаг: 24.3b «Цели: формы, пополнение/изъятие/история, аналитика и прогноз».

════════════════════════════════════════════════════════════════
ЭТАП 24.3b «ЦЕЛИ: ФОРМЫ И ПОТОКИ» — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (32 новых теста)
[x] ValidateSavingsGoalFormUseCase (18): пустое название и пробелы, граница 50 символов, целевая сумма не указана/ноль, дедлайн в прошлом и сегодня у новой цели, дедлайн в будущем, прошлый дедлайн при редактировании, привязанная цель без счёта, нулевое зачисление, зачисление больше баланса, пустая сумма = 100% баланса, зачисление ровно на баланс, виртуальная цель и выключенное зачисление не проверяются.
[x] BuildSavingsGoalDraftUseCase (2): проброс всех полей и updatedAt в UTC, значения по умолчанию.
[x] ContributeToSavingsGoalUseCase (4): нулевая сумма отклоняется без транзакции, создаётся расход с savings_goal_id и space_id без признака изъятия, свой комментарий, ошибка создания -> Error.
[x] WithdrawFromSavingsGoalUseCase (4): нулевая сумма, сумма больше накопленного отклоняется без транзакции, создаётся доход с is_withdrawal (исключён из P&L), изъятие ровно всей суммы допустимо.
[x] GetGoalHistoryUseCase (4): пустая история, кумулятивный график по порядку, изъятия остаются в списке но не в графике, ошибка репозитория.

Итог: 524 теста зелёные, flutter analyze без замечаний.
Следующий шаг: 24.3b часть 2 — аналитика, прогноз и график накопления целей.

════════════════════════════════════════════════════════════════
ЭТАП 24.3c «ЦЕЛИ: АНАЛИТИКА, ПРОГНОЗ, ГРАФИК» — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (31 новый тест)
[x] CalculateSavingsAnalyticsUseCase (11): пустые данные, только активные цели в суммах, пополнения периода и дельта к прошлому, отсутствие прошлого периода, изъятия и ignored, счёт не найден, нет курса, валютная цель, цели созданные в периоде, дельта целевой суммы, ошибка конвертации.
[x] CalculateSavingsForecastUseCase (10): горизонт не после старта, меньше 7 дней, ровно 7 дней (среднее = сумма / 30), изъятия и ignored, окно 30 дней, будущие пополнения, счёт не найден, нет курса, валютные пополнения, среднее меньше копейки.
[x] BuildAccumulationChartUseCase (10): нет пополнений, хронологический порядок точек, несколько пополнений в день, изъятия и ignored, вне периода, счёт не найден, нет курса, целевая линия только по активным целям, валютные пополнения, достройка прогноза при 7 днях.

Исправленный дефект
Ключи дней строились без ведущих нулей и сортировались как строки: точки графика шли 1 → 10 → 2. Исправлено (D24-25).

Итог: 555 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/savings_analytics_fixtures.dart (мок конвертации + фабрики цели, счёта, пополнения).

Цели накопления покрыты полностью: 24.3a (жизненный цикл и математика) + 24.3b (формы и потоки) + 24.3c (аналитика, прогноз, график).

Наблюдение (не исправлено)
CalculateSavingsGoalsSummaryUseCase ставит hasStaleRates только при неудачной конвертации ЦЕЛЕВОЙ суммы; для накопленной ветка else отсутствует. На практике обе конвертации идут с одной валютой и датой, поэтому расхождение не проявляется.

РЕЕСТР ДОЛГОВ — НОВОЕ
TODO(24.6) — [ ] асимметрия hasStaleRates в CalculateSavingsGoalsSummaryUseCase (добавить else для накопленной суммы).

Следующий шаг: 24.4 «Долги» — CloseDebtUseCase (Сценарии А/Б), батч-создание, склонение имени, статистика, группировка, ex-member.

════════════════════════════════════════════════════════════════
ЭТАП 24.4 «ДОЛГИ» — ЗАВЕРШЁН (2026-11-14)
════════════════════════════════════════════════════════════════
Что покрыто (64 новых теста)
[x] DebtX (9): directionFor (должник/кредитор/чужой), isExternal по NULL-стороне, isOverdueAt (прошлое/закрытый/без срока), isActive.
[x] DeclineNameUseCase + FormatDebtTitleUseCase (10): женские на -ия, мужские на согласный, фамилии на -ова, отчества на -ич, несклоняемые, пустая строка, регистр; заголовок для внешнего контрагента и члена семьи.
[x] ValidateDebtFormUseCase + BuildDebtDraftUseCase (10): пустой контрагент, длинное имя, нулевая сумма, сумма меньше числа членов, длинное описание, срок в прошлом (новый/редактирование), валидный черновик; обрезка полей и UTC.
[x] Статистика, просрочка, группировка (5): payable/receivable/overdue, чужие долги игнорируются, 4 списка вкладок.
[x] CreateDebtsBatchUseCase (8): один член, деление поровну с остатком первому, внешний контрагент (NULL-сторона + дательный), исключение создателя, три ArgumentError, pending + UTC.
[x] CloseDebtUseCase (8): Сценарий А (категория исходной траты), Сценарий Б (системная категория), долг не найден/закрыт/актёр не сторона, внешний долг без компенсации кредитору, закрытие после компенсаций, autoResolveLinked.
[x] Жизненный цикл (7): resolve/extend/delete/update только создателем, ex-member помечает активные долги.
[x] DebtsRepositoryImpl (7, Drift in-memory): watchForUser, getById, resolve -> pending, markExMember только активные, resolveAutoLinked по флагу, черновики save/get/delete, TTL 24 часа.

Итог: 619 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_debts_repository.dart (+ makeDebt/makeDraft), fake_system_category_port.dart, fake_transactions_repository_for_debts.dart.

РЕЕСТР ДОЛГОВ — УТОЧНЕНИЕ НУМЕРАЦИИ
Долг асимметрии hasStaleRates в CalculateSavingsGoalsSummaryUseCase перенесён с TODO(24.6) на TODO(24.8): номер больше не совпадает с именем батча. Закрывается в финальном шаге этапа.
Прочие долги без изменений: TODO(24.1c) — 4 расхождения по счетам; TODO(24.2c) — DeleteCategoryUseCase игнорирует Failure и createRule не обрезает bankName; TODO(25) — 12 маркеров в коде.

ПЛАН ОСТАВШИХСЯ БАТЧЕЙ ЭТАПА 24
24.5 — Напоминания (RRULE), Календарь, Регулярные платежи.
24.6 — Импорт (дубли, переводы, парсеры) и Чеки (хэш, матчинг, аналитика товаров).
24.7 — Лояльность, админка/инвайты, пространства, настройки, security, уведомления, Year in Review, профиль, онбординг, auth.
24.8 — Финал: гейт >=80% по домену, закрытие TODO(24.1c/24.2c/24.8), снятие маркеров, документы, коммит этапа.

Следующий шаг: 24.5a «Напоминания» — RRULE, 3 следующих вхождения, черновики, валидация формы.

════════════════════════════════════════════════════════════════
ЭТАП 24.5a «НАПОМИНАНИЯ: RRULE, ЖИЗНЕННЫЙ ЦИКЛ, ЧЕРНОВИКИ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (78 новых тестов)
[x] BuildRRuleUseCase (9): daily/weekly/monthly/yearly, INTERVAL, BYDAY с фильтрацией недопустимых дней, BYMONTHDAY/BYMONTH, UNTIL в UTC-штамп, игнор BYDAY не для weekly.
[x] FormatRRuleUseCase (7): однократно, ежедневно/еженедельно/ежемесячно/ежегодно с интервалами, дни недели на русском, UNTIL-срок, неизвестный FREQ.
[x] GetNextOccurrencesUseCase (11): однократное и в прошлом, строго 3 вхождения, count, отсечение прошедших, weekly по понедельникам, UNTIL-ограничение, битый RRULE -> fallback, КОНТРАКТ «строку BuildRRule читает GetNextOccurrences» (daily и weekly).
[x] ValidateReminderFormUseCase + BuildReminderDraftUseCase (15): название (пусто/пробелы/100/101), описание 500, дата (нет/прошлая/будущая/редактирование), сумма, ответственный только для семьи, сброс пространства и ответственного в личной области, обрезка полей, проброс сумм и связей.
[x] Жизненный цикл (20): создание с pending и UTC, связь с регулярным платежом, планирование (ровно 3 вхождения у ежедневного, отмена прошедшего однократного, все активные, ошибка планировщика), правка с перепланированием, удаление с отменой пушей, завершение и отмена завершения, откладывание (счётчик, история дополняется, битая история, отсутствующее напоминание).
[x] Черновики и история (16): автосейв не роняет форму при ошибке, восстановление свежего/пустого/битого, очистка; парсинг snooze_history (null/пусто/валидный/битый/не массив/без полей), формат записи «Отложено 10.07 на 3 дн.»; контекст дня (пусто, исключение себя и завершённых, ошибка источника).

Исправленные дефекты (найдены тестами)
1. RRULE без префикса не парсился пакетом rrule: повторяющиеся напоминания молча становились однократными (D24-30).
2. Для будущих напоминаний планировщик получал 1 срабатывание вместо 3 из-за afterUtc раньше старта (D24-31).
Проверка на телефоне: создать напоминание с повтором «Каждый день» — пуши должны приходить и в следующие дни.

Итог: 697 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_reminders_repository.dart (+ makeReminder/makeReminderDraft), test/helpers/fake_reminders_scheduler.dart.

Следующий шаг: 24.5b «Календарь и регулярные платежи» — праздники, сводка дня, прогноз, детекция регулярных платежей.

════════════════════════════════════════════════════════════════
ЭТАП 24.5b «КАЛЕНДАРЬ И РЕГУЛЯРНЫЕ ПЛАТЕЖИ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (34 новых теста)
[x] Праздники (10): matchesDay ежегодного и одноразового; создание личного (не пресет, включён, pending); обновление с pending; пресеты read-only в update/delete/toggle; отсутствующий праздник не роняет UseCase.
[x] Кэш прогноза (3, compute): агрегация по категориям + total-строка; нет расходов -> total с нулём (fix 14.4e); пересчёт атомарно заменяет старый кэш месяца.
[x] Streak «бесплатных дней» (3, Drift in-memory): потолок 120; трата сегодня и 3 дня назад -> 2; траты сегодня и вчера -> 0.
[x] Правила регулярных платежей (9): нормализация мерчанта, бакет суммы (округление до сотен рублей), уверенность (6+ = high), группы по паттернам с сортировкой, идемпотентный upsert подтверждения, напоминание из регулярки (RRULE, зажим дня 1..28, время из timeOfDay).
[x] Автодетект (5, Drift in-memory): 3 месяца -> кандидат medium, 6 месяцев -> high, меньше 3 месяцев -> нет кандидатов, подтверждённый active не трогается, разные мерчанты -> отдельные кандидаты.
[x] Защита от спама (4, Drift in-memory): пустой результат, инкремент счётчика отказов, третье отклонение выключает автодетект, undo восстанавливает кандидатов и откатывает счётчик.

Итог: 731 тест зелёный, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_holidays_repository.dart (+ makeHoliday), fake_forecast_cache_repository.dart, fake_recurring_repository.dart (+ makeRecurring).

ЭТАП 24.5 ЗАКРЫТ ЦЕЛИКОМ: 24.5a (напоминания, RRULE, черновики) + 24.5b (календарь, регулярные платежи).

BACKLOG — новое наблюдение (нужна проверка, не баг подтверждённый)
[ ] HolidayX.matchesDay сравнивает месяц/день поля UTC-даты с локальным днём календаря. Если форма праздника когда-нибудь начнёт сохранять локальную дату как есть, ежегодный матч может сдвинуться на день. Проверить holiday_form_sheet при следующих правках календаря.

Следующий шаг: 24.6a «Импорт» — детект дубликатов, детект переводов, парсеры, финализация.

════════════════════════════════════════════════════════════════
ЭТАП 24.6a «ИМПОРТ: ПАРСЕРЫ И ЭВРИСТИКИ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (56 новых тестов)
[x] MarkTransfersUseCase + TransferProfile (16): маркеры банка, телефоны по последним 10 цифрам, короткий номер не участвует, ФИО (2 из 3 токенов / одно слово / нет совпадений), семейный тумблер вкл-выкл для телефонов и ФИО, сохранение остальных полей строки, JSON round-trip профиля.
[x] AutoDetectColumnsUseCase (9): пустой файл, skipRows по заголовкам банка, другой порядок колонок, ISO-дата и её формат, отсутствие колонки суммы, меньше 3 колонок, только положительные суммы, уверенность = минимальная доля, потолок skipRows = 6.
[x] PreviewImportDataUseCase + BuildSecrecyCalendarUseCase (10): пустая матрица, буквенные заголовки, лимит строк, 27-я колонка AA, ширина по длинной строке; календарь секретности (дни месяца, день праздника, период строго между границей и праздником, hasCandidates, февраль).
[x] CsvParser (9): отсутствующий файл, пропуск заголовка и знак суммы, разделитель внутри кавычек, удвоенные кавычки, сумма с ₽ и неразрывным пробелом, запятая-разряды с точкой-дробной, windows-1251, пропуск битой строки при сохранении totalRows, файл только из заголовков.
[x] BankTextParsers (12): нормализация пробелов и тире, детект 5 банков и неизвестного, Яндекс (описание до даты, категория transfer/income), Т-Банк (две даты со временем, кэшбэк), Ozon (документ + двойная сумма, многострочное назначение), универсальный fallback и отбрасывание служебных строк.

Итог: 787 тестов зелёные, flutter analyze без замечаний.

РЕЕСТР ДОЛГОВ — НОВОЕ
TODO(24.8) дополнен:
[ ] PreviewImportDataUseCase._columnLabel пишет буквы в обратном порядке после 27-й колонки (индекс 27 даёт 'BA' вместо 'AB'). На выписках с <= 27 колонками не проявляется; тест закрепляет корректный случай AA.

BACKLOG — наблюдения (нужно решение владельца)
[ ] Парсинг сумм импорта идёт через double как промежуточное значение (CsvParser, XlsxParser, BankTextParsers); результат — int копейки. Формально DECISIONS запрещает double для денег; рефакторинг на целочисленный разбор затрагивает 3 парсера.
[ ] AutoDetectColumnsUseCase распознаёт сумму только с двумя знаками дробной части ('1500' без копеек не считается колонкой суммы) — на выписках с целыми рублями уверенность падает.
[ ] Текстовые парсеры Сбер и ВТБ пока без тестов (сложные регулярки) — добавить в 24.6b.

Следующий шаг: 24.6b «Импорт на БД» — детект дубликатов и hold, детект переводов, автокатегоризация, финализация, режим секретности, конфиги парсеров.

════════════════════════════════════════════════════════════════
ЭТАП 24.6b «ИМПОРТ НА БД», ЧАСТЬ 1 — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (22 новых теста, все на Drift in-memory)
[x] DetectDuplicatesUseCase (9): точное совпадение суммы/даты/мерчанта (оценка 1.0), hold-операция уходит в подтверждения, другая сумма, дата вне допуска, дата внутри допуска (оценка ниже), мерчант отличается сильно / на один символ (0.85), операция другого счёта, пустой импорт.
[x] DetectTransfersUseCase (6): СБП в окне минут без поиска второго счёта, СБП вне окна, межбанк с доходом на другом счёте в БД, межбанк без второго счёта, разные суммы, разница больше окна дней.
[x] AutoCategorizeUseCase (7): правило пользователя (1.0), история с одной категорией, история ниже порога 0.5, маппинг категории банка (0.6), нет данных, categorizeAll применяет только >= 0.7, строки без подсказок не меняются.

Итог: 809 тестов зелёные, flutter analyze без замечаний.

РЕЕСТР ДОЛГОВ — TODO(24.8) дополнен
[ ] AutoCategorizeUseCase._findByHistory: пустая строка merchant_name в истории считается подстрокой любого мерчанта (contains('') == true) — возможен ложный подсчёт частоты. Добавить пропуск пустых имён.

Следующий шаг: 24.6b часть 2 — финализация импорта, режим секретности, детект подарка.

════════════════════════════════════════════════════════════════
ЭТАП 24.6b ЧАСТЬ 2 «ФИНАЛИЗАЦИЯ И СЕКРЕТНОСТЬ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (24 новых теста, все на Drift in-memory)
[x] FinalizeImportUseCase (10): создание выбранных строк и дельта баланса, невыбранные не создаются, HOLD -> audit_status='pending', isTransfer -> type='transfer', дубль skip / replace (обновление категории, комментария, bank_transaction_id) / both, подтверждение hold -> verified, перевод merge исключает обе строки и уменьшает дельту, пустой выбор.
[x] CheckSecrecyModeUseCase (6): режим выключен -> пусто, низкая уверенность -> кандидат не выбран по умолчанию, покупка в периоде становится кандидатом, вне периода не кандидат, праздник чужого пространства не учитывается, личный праздник учитывается при любом скоупе.
[x] ApplySecrecyModeUseCase (2): скрытие до даты праздника с новой категорией и pending, отсутствие id для строки не ломает результат.
[x] DetectGiftCandidateUseCase (7): «Подарок» и «Gift» дают 0.5, «Подарки» (множественное) веса не даёт, типичный мерчант 0.3, сумма выше двойного среднего чека +0.2, все три критерия = 1.0, обычная покупка без истории = 0.

Итог: 834 теста зелёных (после разделения теста режима секретности), flutter analyze без замечаний.

РЕЕСТР ДОЛГОВ — TODO(24.8) дополнен
[ ] DetectGiftCandidateUseCase ищет подстроку «подарок»: банковская категория «Подарки» во множественном числе не распознаётся. Добавить проверку «подарк» или список форм.

Наблюдение (не долг)
Средний чек в детекторе подарков считается только по транзакциям с заполненным merchant_name; операции без мерчанта в расчёт не входят.

Следующий шаг: 24.6c «Импорт: конфиги банков, сиды, детект банка по файлу, парсеры Сбер/ВТБ, XLSX».

════════════════════════════════════════════════════════════════
ЭТАП 24.6c ЧАСТЬ 1 «КОНФИГИ БАНКОВ, СИДЫ, ПАРСЕРЫ СБЕР/ВТБ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (18 новых тестов)
[x] FetchParserConfigsUseCase (5): список из репозитория, ошибка -> пустой список, пустой запрос -> весь список, обрезка запроса и уход в поиск, ошибка поиска -> пусто.
[x] DefaultParserConfigsSeed (6, Drift in-memory): шесть банков, идемпотентность, пониженная версия поднимается до актуальной, актуальная версия не перезаписывается (usage_count сохраняется), популярные первыми, detectionPatterns — валидный JSON.
[x] BankTextParsers Сбер/ВТБ (6): расход без знака, доход с «+», дата со временем, 6-значный id операции; ВТБ — суммы с RUB, снятие префикса «Оплата товаров и услуг.», описание без префикса, положительная сумма.
[x] Гигиена репозитория: удалены flutter_0*.log, appbar_dump.txt, diskstats.txt; .gitignore дополнен (flutter_*.log, *_dump.txt, diskstats.txt, context_*.txt, test_log.txt).

Итог: 851 тест зелёный, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_import_repository.dart (+ makeParserConfig).

BACKLOG — снято наблюдение
[x] Текстовые парсеры Сбер и ВТБ покрыты тестами (было наблюдение Этапа 24.6a).

Следующий шаг: 24.6c часть 2 — детект банка по файлу и XLSX-парсер.

════════════════════════════════════════════════════════════════
ЭТАП 24.6c ЧАСТЬ 2 «ДЕТЕКТ БАНКА ПО ФАЙЛУ И XLSX-ПАРСЕР» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (16 новых тестов)
[x] DetectBankFromFileUseCase (9): отсутствующий файл, PDF и XLSX пропускаются, CSV с ключами и заголовками (1.0), нет совпадений, совпадение ниже порога 0.3 отсеивается, сортировка нескольких банков по уверенности, битый JSON паттернов, windows-1251 фолбэк.
[x] XlsxParser (7): отсутствующий файл, архив без листа, inlineStr с явным маппингом, sharedStrings по индексу, автоопределение колонок по заголовкам + HOLD-колонка, числовая дата Excel (45292 -> 01.01.2024), снятие префикса «Категория: …».

Итог: 867 тестов зелёные, flutter analyze без замечаний.

ИМПОРТ ПОКРЫТ: 136 тестов (24.6a парсеры и эвристики 56 + 24.6b дубли/переводы/категории 22 + финализация и секретность 24 + 24.6c конфиги/сиды/Сбер/ВТБ 18 + детект банка и XLSX 16).

Ограничение тестирования (не долг)
PdfParser на хосте не тестируется: pdfx (нативный PdfRenderer) и ML Kit требуют устройства. Текстовые парсеры банков, которые он вызывает, покрыты отдельно (BankTextParsers).
ParseImportFileUseCase.call() использует path_provider — покрыт только путь reparse() через оркестратор.

Следующий шаг: 24.6d — оркестратор ImportTransactionsUseCase (сквозной конвейер импорта), закрытие этапа 24.6.

════════════════════════════════════════════════════════════════
ЭТАП 24.6d «ОРКЕСТРАТОР ИМПОРТА» — ЗАВЕРШЁН. ЭТАП 24.6 ЗАКРЫТ ЦЕЛИКОМ (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (10 новых тестов, Drift in-memory + временный CSV)
[x] ImportTransactionsUseCase: сквозной конвейер (строки, банк, имя файла, период, пустой transfers), файл без валидных строк -> null, автокатегоризация включена/выключена, пометка переводов включена/выключена, дубликат существующей операции, hold-операция в подтверждения, детект дублей выключен, семейный скоуп в результате.

Итог: 877 тестов зелёные, flutter analyze без замечаний.

ЭТАП 24.6 «ИМПОРТ» ЗАКРЫТ: 146 тестов
24.6a парсеры и эвристики — 56; 24.6b дубли/переводы/категории — 22; финализация и секретность — 24; 24.6c конфиги/сиды/Сбер/ВТБ — 18; детект банка и XLSX — 16; 24.6d оркестратор — 10.

РЕЕСТР ДОЛГОВ — ПЕРЕИМЕНОВАНИЕ
Долг финальной зачистки переименован: TODO(24.8) -> TODO(24.9). Состав без изменений:
[ ] асимметрия hasStaleRates в CalculateSavingsGoalsSummaryUseCase;
[ ] PreviewImportDataUseCase._columnLabel — обратный порядок букв после 27-й колонки;
[ ] AutoCategorizeUseCase._findByHistory — пустой merchant_name считается подстрокой любого мерчанта;
[ ] DetectGiftCandidateUseCase — «Подарки» во множественном числе не распознаётся.
Прочие долги: TODO(24.1c) — 4 расхождения по счетам; TODO(24.2c) — DeleteCategoryUseCase игнорирует Failure и createRule не обрезает bankName; TODO(25) — 12 маркеров в коде.

ПЛАН ОСТАВШИХСЯ БАТЧЕЙ ЭТАПА 24
24.7 — Чеки: хэш и дедупликация, матчинг позиций, аналитика товаров, черновики.
24.8 — Лояльность, админка/инвайты, пространства, настройки, security, уведомления, Year in Review, профиль, онбординг, auth.
24.9 — Финал: гейт >=80% по домену, закрытие TODO(24.1c / 24.2c / 24.9), снятие маркеров, документы, коммит этапа.

Следующий шаг: 24.7 «Чеки».

════════════════════════════════════════════════════════════════
ЭТАП 24.7a «ЧЕКИ: ЯДРО» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (49 новых тестов)
[x] ProductHashUtil + HashProductNameUseCase (7): детерминизм, регистр, обрезка пробелов, разные имена, длина 64 hex, совпадение утилиты и UseCase, значимость внутренних пробелов (схлопывания нет).
[x] ParseFiscalQrUseCase (12): дата в UTC и сумма в копейках, запятая как разделитель, фискальные признаки fn/fp/i/n в JSON, отсутствие признаков, сохранение raw, нет даты/суммы, битые значения, ISO-фолбэк, URL-декод, параметр без «=».
[x] ParseReceiptTextUseCase (10): магазин/позиции/итог, запятая, разряды через пробел, дефис перед ценой, строка из цифр не магазин, пустой текст, ключевые слова итога в любом регистре, имя из одного символа, последняя строка итога, NBSP (текущее поведение).
[x] ValidateReceiptFormUseCase (10): пустой магазин, дата в будущем/прошлом, нулевой итог, пустое имя позиции, нулевая сумма позиции, расхождение суммы, без позиций расхождение не проверяется, набор ошибок. Проверка через errorCodes (расширение isValid не импортируется).
[x] MatchReceiptToTransactionUseCase (10): сценарии А/Б/В/Г, приоритет verified над hold, границы ±5% и ±48 часов (внутри и снаружи), статус ignored не считается hold.

Итог: 926 тестов зелёные, flutter analyze без замечаний.

РЕЕСТР ДОЛГОВ — TODO(24.9) дополнен
[ ] ParseReceiptTextUseCase._parseKop убирает только обычный пробел: сумма с неразрывным пробелом (OCR) не парсится, позиция теряется молча. Регулярка при этом NBSP допускает.

Следующий шаг: 24.7b «Чеки: отчёты аналитики товаров» — тренд цены, топ товаров, категории, динамика цен.

════════════════════════════════════════════════════════════════
ЭТАП 24.7b «ЧЕКИ: ОТЧЁТЫ АНАЛИТИКИ ТОВАРОВ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (32 новых теста, чистый домен)
[x] CalculatePriceTrendUseCase (8): меньше 3 точек -> stable, рост и падение, неизменная цена, рост в пределах 5% -> stable, все точки в один день, нулевые цены без деления на ноль, порядок точек на входе не важен.
[x] CalculateTopProductsUseCase (10): пустой кэш, группировка по хэшу (покупки/траты/количество), средняя цена = траты / количество, нулевое количество -> 0, имя из карты имён иначе первые 8 символов хэша, сортировка по покупкам с тай-брейком по тратам, firstSeen/lastSeen, сортировка точек по дню, тренд по точкам товара, категория из первой записи где задана.
[x] CalculateTopCategoriesUseCase (7): пустой список, группировка и доля от общих трат, товар без категории -> other, сортировка по тратам, нулевые общие траты -> доля 0, среднее количество на покупку, категория без покупок -> 0.
[x] CalculatePriceDynamicsUseCase (7): меньше 3 месяцев -> товар не в отчёте, рост и падение между первым и последним месяцем, сортировка по модулю изменения, нулевая цена первого месяца -> пропуск, точки привязаны к 1-му числу месяца, подписи месяцев и имя товара.

Итог: 958 тестов зелёные, flutter analyze без замечаний.
Новых дефектов не найдено.

Следующий шаг: 24.7c «Чеки: usecase'ы и репозитории» — алиасы товаров, черновик, confirm, привязка к транзакции, разделение чека, счётчики нейминга, Drift-репозитории.

════════════════════════════════════════════════════════════════
ЭТАП 24.7c «ЧЕКИ: USECASE'Ы» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (40 новых тестов)
[x] CreateDraftReceiptUseCase (7): статус draft + RUB + pending + UTC, пустые скоуп/транзакция -> null, непустые сохраняются, позиции наследуют id чека без нормализации и категории, фискальные данные/OCR/путь к фото, чек без позиций (QR), ошибка репозитория.
[x] ConfirmReceiptUseCase (7): невалидная форма -> отказ без записи, валидный чек -> saveItems + saveReceipt(confirmed, pending), расхождение суммы позиций отклоняется, переданная транзакция используется для привязки, пустая откатывается к транзакции чека, без транзакции привязки нет, ошибка сохранения -> save_failed.
[x] LinkReceiptToTransactionUseCase (2): успех -> true и статус matched, hold-транзакция -> false.
[x] MatchReceiptUseCase (2): кандидаты из БД проходят через чистый матчинг, только hold -> сценарий Г.
[x] RecordNamingDecisionUseCase (2): решение пробрасывается, ошибка репозитория пробрасывается.
[x] ScanReceiptQrUseCase (3): нераспознанный QR -> null без черновика, валидный QR -> чек «QR-чек» без позиций, фискальные признаки в JSON.
[x] FindOrCreateProductAliasUseCase (9): нормализация (trim/lowercase/схлопывание), создание с usageCount 1 + pending + UTC, инкремент найденного, семейный и глобальный алиас, чужое пространство -> новый, личная область передаёт '', повтор без дубля, ошибка -> null.
[x] SplitReceiptUseCase (8): чек не найден / без транзакции -> StateError, MIN_TWO_POSITIONS, NON_POSITIVE_AMOUNT, MISSING_CATEGORY, SUM_MISMATCH, успешное применение, ошибка БД.

Итог: 998 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_receipts_repository.dart (+ makeReceipt/makeReceiptItem), test/helpers/fake_product_aliases_repository.dart (+ makeAlias).

Следующий шаг: 24.7d «Чеки: Drift-репозитории» — CRUD и каскады, кандидаты матчинга, блокировка привязки к hold, алиасы товаров; затем черновики разделения и спам-счётчики.

════════════════════════════════════════════════════════════════
ЭТАП 24.7d «ЧЕКИ: DRIFT-РЕПОЗИТОРИИ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (22 новых теста, Drift in-memory)
[x] ReceiptsRepositoryImpl (15): createReceipt сохраняет чек и позиции одной транзакцией, отсутствующий чек -> null, сортировка по дате убывающе, чтение позиций с копейками, updateReceipt и saveItems атомарно заменяют набор позиций, saveReceipt меняет только метаданные, updateReceiptStatus, deleteReceipt каскадно удаляет позиции, кандидаты матчинга (окно ±48ч и ±5%, только расходы), привязка ставит matched + receipt_id + pending обеим записям, привязка к hold запрещена с откатом, пустой/несуществующий id -> StateError, категории позиций только расход.
[x] ProductAliasesRepositoryImpl (7): создание и поиск по хэшу, семейный алиас в своём пространстве, глобальный (NULL) в любом, чужое пространство -> null, incrementUsageCount, updateAlias, deleteAlias.

Итог: 1020 тестов зелёные, flutter analyze без замечаний.

Следующий шаг: 24.7e «Чеки: черновики разделения, применение сплита, спам-счётчики, аналитический кэш товаров» — закрытие этапа 24.7.
Для него нужен точный контекст: SplitPositionDraft, таблица split_drafts, DAO аналитики товаров и оставшиеся usecase'ы алиасов.

════════════════════════════════════════════════════════════════
ЭТАП 24.7e «ЧЕКИ: СПЛИТ, ЧЕРНОВИКИ, СПАМ-ЗАЩИТА, НАСТРОЙКИ АЛИАСОВ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (26 новых тестов, Drift in-memory)
[x] Черновик разделения (6): round-trip позиций через toJson/fromJson, повторное сохранение заменяет строку, отсутствие -> null, TTL 24 часа, битый JSON -> null, JSON не массив -> null.
[x] Применение разделения (4): is_split + сплиты + удаление черновика одной транзакцией и pending, повторное применение заменяет сплиты без задвоения, только владелец операции (с откатом), несуществующая операция -> StateError.
[x] Спам-защита (7): счётчики стартуют с нуля, один отказ increments и оффер ещё включён, три отказа выключают автопредложение, принятие сбрасывает счётчик — отдельно для именования и разделения, счётчики независимы.
[x] Настройки алиасов (9): область «Я» (space_id IS NULL), «Семья» (текущее пространство), «Семья» без пространства -> пусто, режим «все» с сортировкой по использованию, чужие алиасы не попадают, updateFields + pending, UseCase правки (обрезка имени) и отказ на пустое имя, UseCase удаления.

Итог: 1046 тестов зелёные, flutter analyze без замечаний.
Новых дефектов не найдено — батч прошёл с первого прогона.

Следующий шаг: замер покрытия по домену (flutter test --coverage + разбор lcov по фичам), чтобы точно спланировать остаток этапа 24: чеки (кэш аналитики товаров, детализация товара) и батч 24.8.

════════════════════════════════════════════════════════════════
ЭТАП 24.8a «МАЛЫЕ ФИЧИ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (53 новых теста)
[x] privacy (2): режимов ровно два (visible/hidden), имена стабильны — защита от возврата partial (D19-14).
[x] profile (6): UserDto JSON round-trip и nullable-поля; UpdateProfileUseCase — имя/дательный + pending, avatarPath=null не трогает аватар, clearAvatar обнуляет, updated_at сдвигается вперёд (явная старая база).
[x] onboarding (6): начальный шаг, порядок шагов до completed, идемпотентность completed, setBaseCurrency, completeOnboarding с любого шага, отсутствие шага firstAccount (D18-14).
[x] settings (6): очистка кэша (пусто -> 0, удаляет прогноз и аналитику товаров, не трогает транзакции/счета/категории, идемпотентность), UpdateAppSettingsUseCase (одна и две последовательные правки).
[x] security (19): уровень защиты 0-100 по группам (быстрое скрытие 30, защита данных 20, аутентификация 40, секретность 10), биометрия только при доступности, границы title; стойкость PIN (длина, одинаковые, последовательности, год, популярные, стойкий, пустая строка).
[x] spaces (14): модели UserSpace/SpaceMembershipInfo; CreateSpaceUseCase (пустое имя, обрезка, id, DatabaseFailure); AttachPersonalTransactionsUseCase (счётчик, ошибка); SetPersonalShareUseCase (countPersonal только личные, флаг по умолчанию выкл, включение присоединяет, выключение меняет только флаг, performAttach=false).

Итог: 1099 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_spaces_repository.dart.

БАЗОВЫЙ ЗАМЕР ПОКРЫТИЯ (2026-11-15, до батча 24.8a)
lcov: 2971 / 3457 исполняемых строк = 85.9% — ЗАВЫШЕНО (в отчёт попали только загруженные файлы).
Честная оценка: 15972 физические строки домена, 6830 (42.8%) в нетронутых файлах; исполняемых ~6040, покрыто 2971 => ~49%.
Файлов домена: 311, без покрытия: 146.
11 фич с нулём: admin 1302, notifications 915, year_in_review 749, loyalty_cards 626, spaces 389, settings 209, auth 195, security 189, profile 53, onboarding 47, privacy 1 (физических строк).
Крупнейшие пробелы внутри покрытых фич: receipts 629, transactions 351, savings_goals 227, import 202, year_budget 182, cashback 161.
CORE (lib/core): 636 / 1895 = 33.6% — в гейт не входит (роадмап: домен >= 80%).

ПЛАН ДО ГЕЙТА
24.8a малые фичи — ГОТОВО (privacy, profile, onboarding, settings, security, spaces).
24.8b — auth (4 файла) + LeaveSpaceUseCase (нужна схема memberships).
24.8c — loyalty_cards; 24.8d — notifications; 24.8e — year_in_review; 24.8f — admin.
24.8g — пробелы: receipts, transactions, savings_goals, year_budget, cashback.
24.9 — финал: гейт, закрытие TODO(24.1c / 24.2c / 24.9), документы, коммит этапа.

════════════════════════════════════════════════════════════════
ЭТАП 24.8b «AUTH, PIN, ВЫХОД ИЗ ПРОСТРАНСТВА» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (38 новых тестов)
[x] AuthRepositoryImpl (13): getCurrentUser / signIn / signUp / OTP / Google / signOut — успех и ошибка источника (Failure, наружу не летит); проброс email и пароля позиционными аргументами; authStateChanges проксируется от источника.
[x] DeleteAccountUseCase (3): wipe всех таблиц + storage.deleteAll, идемпотентность повторного вызова, ошибка Keystore пробрасывается.
[x] SetPinCodeUseCase / VerifyPinCodeUseCase (10): длина PIN и несовпадение подтверждения отклоняются ДО обращения к хранилищу; валидный PIN сохраняется; failure и исключение хранилища превращаются в Failure; неверный PIN = success(false), а не Failure.
[x] LeaveSpaceUseCase (12): evaluate — нет активного членства (StateError), обычный участник, админ при другом админе, единственный админ один (dissolveSolo), 2 участника (autoPromote), 3+ (chooseSuccessor без себя), вышедший не считается активным; действия — архив только моих операций группы, автоповышение оставшегося, повышение выбранного преемника, dissolve с dissolvedBy и pending, повторный выход не трогает другие группы.

ИСПРАВЛЕННЫЙ ДЕФЕКТ (D24-65)
LeaveSpaceUseCase._leave передавал Variable-обёртки в customStatement. Выход из пространства и расформирование соло-группы падали всегда. Теперь передаются сырые значения.
Проверка на телефоне: Профиль → Мои пространства → выйти из группы (и расформировать группу, где я один).

Итог: 1137 тестов зелёные, flutter analyze без замечаний.

ОСТАЛОСЬ В ЭТАПЕ 24.8
Нулевые фичи: loyalty_cards (20 файлов), notifications (5), year_in_review (9), admin (8).
Пробелы внутри покрытых: receipts 21 файл, transactions 14, import 11, cashback 8, savings_goals 2, year_budget 2.
Не покрыты в уже тронутых фичах: PinCodeRepositoryImpl (мокался интерфейс), AuthNotifier, ExportAllDataUseCase и ExportEncryptionKeysUseCase (path_provider — только на устройстве).

Следующий шаг: 24.8c «Карты лояльности» — EAN-13 checksum, автодетект типа кода, валидация, CRUD только создателем, сортировка и черновики.

════════════════════════════════════════════════════════════════
ЭТАП 24.8c ЧАСТЬ 1 «КАРТЫ ЛОЯЛЬНОСТИ: ЧИСТЫЙ ДОМЕН» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (43 новых теста)
[x] ValidateLoyaltyCardFormUseCase (24): EAN-13 checksum (валидный 4006381333931, все нули, битая контрольная цифра, не 13 цифр, буквы/пусто); валидация формы по 5 типам кода (ean13 / code128 1-80 латиница+цифры / qr <= 500 / pdf417 <= 1000 / manual 4-32 цифры), название магазина (пусто/пробелы/50/51), цвет бренда #RRGGBB, семейная видимость без пространства и с ним.
[x] AutoDetectBarcodeTypeUseCase + FormatCardNumberForDisplayUseCase (11): порядок правил автодетекта (валидный EAN-13 первым, буквы+цифры -> code128, чистые цифры 4-32 -> manual, 3 цифры и пустая строка -> qr, > 500 символов -> manual, обрезка пробелов); группировка номера по 4 цифры, удаление не-цифр, пустой результат.
[x] BuildLoyaltyCardDraftUseCase (8): новая карта (id, pending, UTC, не избранная, LOCAL-поля null), cardNumber только для manual, семейная и личная видимость, сохранение isShared существующей карты, сохранение id/createdAt/sortOrder/preferredOrientation при редактировании, обрезка названия и данных кода.

Итог: 1180 тестов зелёные, flutter analyze без замечаний.

BACKLOG — новое наблюдение
[ ] AutoDetectBarcodeTypeUseCase: пустая строка и 1-3 цифры определяются как QR (правило manual требует 4-32 цифры). Форма отдельно отклоняет пустые данные, поэтому дефекта в UI нет; семантику автодетекта можно уточнить решением владельца.

Следующий шаг: 24.8c часть 2 — CRUD «только создатель», тумблеры избранного и видимости, локальная сортировка и ориентация, сводка, watch-делегирование, черновики, пресеты магазинов.

════════════════════════════════════════════════════════════════
ЭТАП 24.8c ЧАСТЬ 2 «КАРТЫ ЛОЯЛЬНОСТИ: CRUD, ТУМБЛЕРЫ, ЧЕРНОВИКИ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (46 новых тестов)
[x] CRUD (13): создание с pending, чтение (отсутствующая карта = Success(null), сбой БД = Error), правка и удаление только создателем (notFound / authorization / database), запись не меняется при отказе.
[x] Тумблеры и LOCAL-поля (16): избранное инвертируется и доступно для чужой карты; видимость is_shared только создателем; локальная сортировка (индекс = sort_order, пустой список без обращений к БД); ориентация portrait / landscape / null и отказ на неизвестную без записи.
[x] Сводка, watch, черновики, пресеты (17): stats делегирует userId и spaceId, ошибка пробрасывается; watchCards получает все фильтры одним вызовом (дефолты: все категории, без избранного, без поиска), синхронная ошибка пробрасывается; saveDraft / restoreDraft (null без черновика) / clearDraft с Error при сбое; PopularStore.fromSeedMap (полный сид, неизвестная категория -> other, пустая карта -> безопасные дефолты).

Итог: 1226 тестов зелёные, flutter analyze без замечаний.
Инфраструктура: test/helpers/fake_loyalty_cards_repository.dart (+ makeCard / makeCardDraft).

ЭТАП 24.8c ЗАКРЫТ по домену: 89 тестов (часть 1 — 43, часть 2 — 46).
Осталось по картам: Drift-репозиторий LoyaltyCardsRepositoryImpl + LoyaltyCardsDao (фильтры в SQL, TTL черновика 24 ч, cleanup 7 дней) — в батче пробелов 24.8g.

ПЛАН ОСТАВШИХСЯ БАТЧЕЙ
24.8d — Уведомления (матрица триггеров, дайджесты, ночной режим).
24.8e — Year in Review (агрегаты, слайды, доступность).
24.8f — Админка (инвайты, HKDF, роли, heartbeat, аудит).
24.8g — Пробелы: receipts 21 файл, transactions 14, import 11, cashback 8, savings_goals 2, year_budget 2, loyalty_cards Drift.
24.9 — Финал: гейт >= 80% по домену, закрытие TODO(24.1c / 24.2c / 24.9), документы, коммит этапа.

Следующий шаг: 24.8d «Уведомления».

════════════════════════════════════════════════════════════════
ЭТАП 24.8d ЧАСТЬ 1 «УВЕДОМЛЕНИЯ: ТИПЫ, ГЕНЕРАЦИЯ, ДЕЙСТВИЯ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (31 новый тест)
[x] NotificationType (11): 30 значений = 27 пушей + 3 дайджеста, 4 канала с id/названием/описанием, распределение по каналам (13/6/7/4), alwaysOn ровно 4, critical ровно 2, dbValue == name, channelId из канала, уникальные label, fromDb (валидное / null / мусор / legacy snake_case -> reminderDue), дайджесты в канале напоминаний.
[x] GenerateNotificationUseCase (10, Drift in-memory): создание с типом из enum, дедуп тип+сущность в окне 24ч, другая сущность -> новый пуш, без сущности повтор отсекается, critical игнорирует дедуп, запись старше окна не блокирует, ночной режим покрывающий момент блокирует, вне окна не блокирует, выключенный не блокирует, семейный скоуп сохраняется.
[x] HandleNotificationActionUseCase (10, Drift in-memory): dismiss без бизнес-логики, подтверждение подарка скрывает покупку на 30 дней (camelCase и legacy snake_case), подтверждение напоминания завершает его, entityId «id:суффикс» и «id:snooze» разбираются по id, неизвестный тип только отмечает прочтение, повторное подтверждение идемпотентно, markAsRead, несуществующий id не роняет обработку.

ИСПРАВЛЕННЫЕ ДЕФЕКТЫ
1. D24-73: кнопка «Подтвердить» не выполняла бизнес-логику при типе из БД (camelCase vs snake_case).
2. D24-74: кнопка «Выполнено» в пуше напоминания обновляла строку с id=дата вместо id напоминания.
Проверка на телефоне: пуш «Крупная покупка» -> «Подтвердить» (операция скрывается на 30 дней); пуш напоминания -> «Выполнено» (уходит в историю).

Итог: 1257 тестов зелёные, flutter analyze без замечаний.

Следующий шаг: 24.8d часть 2 — дайджесты (день/неделя/месяц, условная генерация) и матрица триггеров на реальной БД.

════════════════════════════════════════════════════════════════
ЭТАП 24.8d ЧАСТЬ 2 «ДАЙДЖЕСТЫ» — ЗАВЕРШЁН (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (11 новых тестов, Drift in-memory)
[x] GenerateDailyDigestUseCase: выключенный дневной дайджест не генерируется, раньше настроенного часа не генерируется, дневной после часа содержит траты, воскресенье -> недельный, 1-е число -> месячный (id с dbValue), camelCase-уведомления агрегируются и помечаются прочитанными, legacy snake_case тоже агрегируются, прочитанные не попадают, посторонний тип не агрегируется, нет событий и трат -> null, изъятия и ignored не считаются тратами.

ИСПРАВЛЕННЫЙ ДЕФЕКТ (D24-75)
SQL дайджеста фильтровал типы только в snake_case, а GenerateNotificationUseCase пишет camelCase — системные пуши (участники, подписки, цели, долги) никогда не попадали в дайджест, работал лишь блок «потрачено N ₽». Теперь собираются обе формы.
Проверка на телефоне: Профиль -> Уведомления -> Настройки -> Дайджесты; после 19:00 в дайджесте должны появиться строки про участников, подписки, цели и долги.

Итог: 1268 тестов зелёные, flutter analyze без замечаний.

Следующий шаг: 24.8d часть 3 — матрица триггеров пушей (NotificationTriggersUseCase) на реальной БД.

════════════════════════════════════════════════════════════════
ЭТАП 24.8d ЧАСТЬ 3 «МАТРИЦА ТРИГГЕРОВ ПУШЕЙ» — ЗАВЕРШЁН. ЭТАП 24.8d ЗАКРЫТ ЦЕЛИКОМ (2026-11-15)
════════════════════════════════════════════════════════════════
Что покрыто (33 новых теста, Drift in-memory)
[x] NotificationTriggersUseCase (27): глобальный лимит пространства (80%, ниже порога, режим global_amount, лимит не задан); лимит категории (достижение alert_percent, ниже порога); прогноз дефицита (отрицательный total, положительный); напоминания (окно суток с entityId id:дата, завершённое не пушится, три откладывания); подписка alwaysOn; праздник через secrecy_days; крупная покупка; цели (три вехи 50/75/90, дедлайн через 3 дня); активность группы (админ 20 дней, участник присоединился); конфликты синка (неразрешённый alwaysOn, разрешённый не пушится); годовой отчёт (27 декабря, просмотренный, до 27-го, семейный не считается личным); чек-черновик старше суток; 25-е число без импорта; выключенный тип подавляет пуш.
[x] Тумблеры типов (6): цели, непривязанный чек, выписка, годовой отчёт — выключение подавляет пуш; глобальный тумблер напоминаний гасит тип даже при включённом per-type; alwaysOn пушится с выключенным тумблером.

ИСПРАВЛЕННЫЙ ДЕФЕКТ (D24-78)
on(type) вызывался только для трёх типов лимитов — остальные 20+ типов игнорировали настройку пользователя. Теперь проверка у каждого не-alwaysOn типа.
Проверка на телефоне: Настройки -> Уведомления -> выключить «Напоминание» / «Цель: прогресс» / «Чек без категории» -> соответствующие пуши не приходят.

Итог: 1301 тест зелёный, flutter analyze без замечаний.

ЭТАП 24.8d ЗАКРЫТ: 75 тестов (часть 1 типы/генерация/действия — 31, часть 2 дайджесты — 11, часть 3 матрица триггеров — 33).
Не покрыт в матрице: блок долгов (debtCreated / debtClosed / debtForgiven / debtOverdue) — определение таблицы debts не попадало в контекст. Закрывается вместе с батчем пробелов.

ПЛАН ОСТАВШИХСЯ БАТЧЕЙ
24.8e — Year in Review (9 файлов домена, 749 строк).
24.8f — Админка (8 файлов, 1302 строки).
24.8g — Пробелы: receipts 21 файл, transactions 14, import 11, cashback 8, savings_goals 2, year_budget 2, loyalty_cards Drift, блок долгов в триггерах.
24.9 — Финал: гейт >= 80% по домену, закрытие TODO(24.1c / 24.2c / 24.9), документы, коммит этапа.

Следующий шаг: 24.8e «Year in Review».
