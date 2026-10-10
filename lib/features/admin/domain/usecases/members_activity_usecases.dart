import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';

/// Периоды экрана активности (ТЗ 6.3.34.3).
enum ActivityPeriod {
  week(7, 'Неделя', 'неделю'),
  month(30, 'Месяц', 'месяц'),
  quarter(90, 'Квартал', 'квартал'),
  year(365, 'Год', 'год');

  const ActivityPeriod(this.days, this.label, this.labelAcc);
  final int days;
  final String label;
  final String labelAcc;

  int sinceEpoch(DateTime nowUtc) =>
      nowUtc.subtract(Duration(days: days)).millisecondsSinceEpoch ~/ 1000;
}

/// Строка «день x участник» из SQL (GROUP BY в AdminDao).
class DayUserCountRow {
  const DayUserCountRow({
    required this.day,
    required this.userId,
    required this.count,
  });
  final String day; // 'YYYY-MM-DD', локальный день
  final String userId;
  final int count;
}

/// Строка «участник x количество операций» за период.
class UserCountRow {
  const UserCountRow({required this.userId, required this.count});
  final String userId;
  final int count;
}

/// Общая сводка активности (ТЗ 6.3.34.4).
class OverallActivityStats {
  const OverallActivityStats({
    required this.totalTransactions,
    required this.averagePerDay,
    required this.activeMembers,
    required this.totalMembers,
    required this.activePercent,
  });
  final int totalTransactions;
  final double averagePerDay;
  final int activeMembers;
  final int totalMembers;
  final int activePercent;
}

/// Считает сводку из готовых строк SQL (фильтрация — в SQL, математика — здесь).
class CalculateOverallActivityUseCase {
  const CalculateOverallActivityUseCase();
  OverallActivityStats call({
    required List<DayUserCountRow> dayRows,
    required int activeMembers,
    required int totalMembers,
    required int daysInPeriod,
  }) {
    var total = 0;
    for (final r in dayRows) {
      total += r.count;
    }
    final days = daysInPeriod < 1 ? 1 : daysInPeriod;
    final percent =
        totalMembers == 0 ? 0 : (activeMembers * 100 / totalMembers).round();
    return OverallActivityStats(
      totalTransactions: total,
      averagePerDay: total / days,
      activeMembers: activeMembers,
      totalMembers: totalMembers,
      activePercent: percent,
    );
  }
}

/// Один столбик графика (день + сколько операций у каждого участника).
class ChartDayData {
  const ChartDayData({
    required this.day,
    required this.dayOfMonth,
    required this.perUser,
  });
  final String day;
  final int dayOfMonth;
  final Map<String, int> perUser;
  int get total => perUser.values.fold(0, (a, b) => a + b);
}

/// Строит данные графика: всегда последние 30 дней (ТЗ 6.3.34.5 п.4.d).
class BuildActivityChartUseCase {
  const BuildActivityChartUseCase();
  List<ChartDayData> call(List<DayUserCountRow> rows, DateTime nowLocal) {
    final byDay = <String, Map<String, int>>{};
    for (final r in rows) {
      byDay.putIfAbsent(r.day, () => <String, int>{})[r.userId] = r.count;
    }
    final today = DateTime(nowLocal.year, nowLocal.month, nowLocal.day);
    final result = <ChartDayData>[];
    for (var i = 29; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      final key = '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}-'
          '${d.day.toString().padLeft(2, '0')}';
      result.add(ChartDayData(
        day: key,
        dayOfMonth: d.day,
        perUser: byDay[key] ?? const {},
      ));
    }
    return result;
  }
}

/// Участник топа-3 (ТЗ 6.3.34.6).
class TopMember {
  const TopMember({
    required this.userId,
    required this.displayName,
    required this.role,
    required this.count,
    required this.percent,
  });
  final String userId;
  final String displayName;
  final MemberRole role;
  final int count;
  final int percent;
}

class GetTopActiveMembersUseCase {
  const GetTopActiveMembersUseCase();
  List<TopMember> call(List<UserCountRow> counts, List<MemberInfo> members) {
    final byId = {for (final m in members) m.userId: m};
    var total = 0;
    for (final c in counts) {
      total += c.count;
    }
    final sorted = [...counts]..sort((a, b) => b.count.compareTo(a.count));
    final result = <TopMember>[];
    for (final c in sorted.take(3)) {
      final m = byId[c.userId];
      if (m == null || c.count == 0) {
        continue;
      }
      result.add(TopMember(
        userId: c.userId,
        displayName: m.displayName,
        role: m.role,
        count: c.count,
        percent: total == 0 ? 0 : (c.count * 100 / total).round(),
      ));
    }
    return result;
  }
}

/// Статусы активности (ТЗ 6.3.34.7): 🟢 онлайн / 🟢 недавно / 🟡 давно / 🔴 неактивен / ⬜ вышел.
enum ActivityStatus { online, recent, old, inactive, left }

class GetActivityStatusUseCase {
  const GetActivityStatusUseCase();
  ActivityStatus call(MemberInfo m, DateTime nowUtc) {
    if (m.status == MemberStatus.left) {
      return ActivityStatus.left;
    }
    final last = m.lastActiveAt;
    if (last == null) {
      return ActivityStatus.inactive;
    }
    final diff = nowUtc.difference(last);
    if (diff.inMinutes < 5) {
      return ActivityStatus.online;
    }
    if (diff.inDays < 1) {
      return ActivityStatus.recent;
    }
    if (diff.inDays < 14) {
      return ActivityStatus.old;
    }
    return ActivityStatus.inactive;
  }

  /// Текст «последняя синхронизация» для карточки.
  String lastSyncLabel(MemberInfo m, DateTime nowUtc) {
    final last = m.lastActiveAt;
    if (last == null) {
      return 'нет синхронизаций';
    }
    final diff = nowUtc.difference(last);
    if (diff.inMinutes < 1) {
      return 'только что';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} мин назад';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} ч назад';
    }
    return '${diff.inDays} дн назад';
  }
}