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