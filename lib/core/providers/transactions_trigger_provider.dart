import 'package:flutter_riverpod/flutter_riverpod.dart';
/// Триггер изменения транзакций: bump() после создания/изменения транзакции,
/// чтобы виджеты дашборда (движение расходов) обновлялись реактивно.
class TransactionsTriggerNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void bump() => state = state + 1;
}
final transactionsTriggerProvider =
    NotifierProvider<TransactionsTriggerNotifier, int>(
        TransactionsTriggerNotifier.new);