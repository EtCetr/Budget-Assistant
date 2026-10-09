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