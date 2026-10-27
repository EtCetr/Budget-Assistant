import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/models/notification_type.dart';
import '../../domain/usecases/generate_notification_usecase.dart';
import '../../domain/usecases/handle_notification_action_usecase.dart';

final generateNotificationUseCaseProvider =
    Provider<GenerateNotificationUseCase>(
  (ref) => GenerateNotificationUseCase(ref.watch(appDatabaseProvider)),
);

final handleNotificationActionUseCaseProvider =
    Provider<HandleNotificationActionUseCase>(
  (ref) => HandleNotificationActionUseCase(ref.watch(appDatabaseProvider)),
);

final notificationsStreamProvider = StreamProvider<List<Notification>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.notifications)
        ..where((n) => n.userId.equals(userId))
        ..orderBy([(n) => OrderingTerm.desc(n.createdAt)]))
      .watch();
});

final unreadCountProvider = StreamProvider<int>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final db = ref.watch(appDatabaseProvider);
  final count = db.notifications.id.count();
  return (db.selectOnly(db.notifications)
        ..addColumns([count])
        ..where(db.notifications.userId.equals(userId) &
            db.notifications.isRead.equals(false)))
      .watchSingle()
      .map((row) => row.read(count) ?? 0);
});

class NotificationsFilter {
  const NotificationsFilter({this.showOnlyUnread = false, this.typeFilter});
  final bool showOnlyUnread;
  final NotificationType? typeFilter;
}

class NotificationsFilterNotifier extends Notifier<NotificationsFilter> {
  @override
  NotificationsFilter build() => const NotificationsFilter();
  void set(NotificationsFilter f) => state = f;
}

final notificationsFilterProvider =
    NotifierProvider<NotificationsFilterNotifier, NotificationsFilter>(
        NotificationsFilterNotifier.new);