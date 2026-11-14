// Этап 24 (D24-2): отчёт покрытия из coverage/lcov.info без сторонних пакетов.
//
// Запуск:
//   flutter test --coverage
//   dart run tool/coverage_report.dart --min=80 --scope=lib/features/year_budget/domain
//
// additionally: инвентаризация ВСЕХ файлов домена по фичам.
// Файл, который ни один тест не загрузил, в lcov не попадает — поэтому
// процент по lcov нельзя считать покрытием всего домена. Список непокрытых
// файлов пишется в coverage/untested_domain.txt.
import 'dart:io';

class _FileStat {
  _FileStat(this.path);

  final String path;
  int found = 0;
  int hit = 0;

  double get percent => found == 0 ? 0 : hit * 100 / found;
}

String _norm(String path) => path.replaceAll('\\', '/').replaceFirst('./', '');

bool _generated(String path) =>
    path.endsWith('.g.dart') || path.endsWith('.freezed.dart');

String _featureOf(String path) {
  final m = RegExp(r'lib/features/([^/]+)/domain/').firstMatch(path);
  return m == null ? 'core' : m.group(1)!;
}

void main(List<String> args) {
  try {
    var filePath = 'coverage/lcov.info';
    var min = 80.0;
    var listUntested = false;
    final scopes = <String>[];

    for (final arg in args) {
      if (arg.startsWith('--file=')) {
        filePath = arg.substring('--file='.length);
      } else if (arg.startsWith('--min=')) {
        min = double.tryParse(arg.substring('--min='.length)) ?? 80.0;
      } else if (arg.startsWith('--scope=')) {
        scopes.add(_norm(arg.substring('--scope='.length)));
      } else if (arg == '--list-untested') {
        listUntested = true;
      }
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      stdout.writeln('Нет файла $filePath.');
      stdout.writeln('Сначала запусти: flutter test --coverage');
      exitCode = 2;
      return;
    }

    final stats = <String, _FileStat>{};
    _FileStat? current;
    for (final raw in file.readAsLinesSync()) {
      final line = raw.trim();
      if (line.startsWith('SF:')) {
        final path = _norm(line.substring(3));
        current = _generated(path)
            ? null
            : stats.putIfAbsent(path, () => _FileStat(path));
      } else if (line.startsWith('DA:') && current != null) {
        final parts = line.substring(3).split(',');
        if (parts.length < 2) continue;
        final hits = int.tryParse(parts[1]) ?? 0;
        current.found++;
        if (hits > 0) current.hit++;
      } else if (line == 'end_of_record') {
        current = null;
      }
    }

    bool inScope(String path) => scopes.isEmpty
        ? path.contains('/domain/')
        : scopes.any(path.startsWith);

    final scoped = stats.values
        .where((s) => s.found > 0 && inScope(s.path))
        .toList()
      ..sort((a, b) => a.percent.compareTo(b.percent));

    var found = 0;
    var hit = 0;
    for (final s in scoped) {
      found += s.found;
      hit += s.hit;
    }
    final total = found == 0 ? 0.0 : hit * 100 / found;

    stdout.writeln('=== Покрытие выбранного scope: '
        '${scopes.isEmpty ? 'весь domain (по lcov)' : scopes.join(', ')} ===');
    for (final s in scoped) {
      final p = '${s.percent.toStringAsFixed(1)}%'.padLeft(7);
      stdout.writeln('$p  ${s.path}  (${s.hit}/${s.found})');
    }
    if (scoped.isEmpty) stdout.writeln('Нет данных по выбранному scope.');
    stdout.writeln('');
    stdout.writeln(
      'ИТОГО scope: ${total.toStringAsFixed(1)}% ($hit/$found), '
      'порог ${min.toStringAsFixed(0)}%',
    );

    // --- Инвентаризация домена на диске ---
    final domainFiles = <String>[];
    final libDir = Directory('lib');
    if (libDir.existsSync()) {
      for (final e in libDir.listSync(recursive: true)) {
        if (e is! File) continue;
        final p = _norm(e.path);
        if (!p.endsWith('.dart') || _generated(p)) continue;
        if (!p.contains('/domain/')) continue;
        domainFiles.add(p);
      }
    }
    domainFiles.sort();

    final byFeature = <String, List<String>>{};
    for (final p in domainFiles) {
      byFeature.putIfAbsent(_featureOf(p), () => <String>[]).add(p);
    }

    final untested = <String>[];
    stdout.writeln('');
    stdout.writeln('=== Домен по фичам: файлов с тестами / всего ===');
    final features = byFeature.keys.toList()..sort();
    for (final f in features) {
      final files = byFeature[f]!;
      var tested = 0;
      var lf = 0;
      var lh = 0;
      for (final p in files) {
        final s = stats[p];
        if (s != null && s.found > 0) {
          tested++;
          lf += s.found;
          lh += s.hit;
        } else {
          untested.add(p);
        }
      }
      final pct = files.isEmpty ? 0.0 : tested * 100 / files.length;
      stdout.writeln(
        '${pct.toStringAsFixed(0).padLeft(4)}%  $f: '
        '$tested/${files.length} файлов, строки $lh/$lf',
      );
    }

    final testedTotal = domainFiles.length - untested.length;
    final filesPct = domainFiles.isEmpty
        ? 0.0
        : testedTotal * 100 / domainFiles.length;
    stdout.writeln('');
    stdout.writeln(
      'ДОМЕН ВСЕГО: $testedTotal/${domainFiles.length} файлов '
      '(${filesPct.toStringAsFixed(1)}%) затронуты тестами',
    );
    stdout.writeln(
      'Примечание: абстрактные репозитории и enum-файлы могут не иметь '
      'исполняемых строк и попадают в список непокрытых.',
    );

    try {
      final out = File('coverage/untested_domain.txt');
      out.parent.createSync(recursive: true);
      out.writeAsStringSync(untested.join('\n'));
      stdout.writeln(
        'Список непокрытых файлов: coverage/untested_domain.txt '
        '(${untested.length})',
      );
    } catch (e) {
      stdout.writeln('Не удалось записать список непокрытых: $e');
    }

    if (listUntested) {
      for (final p in untested) {
        stdout.writeln('  $p');
      }
    }

    if (found == 0) {
      stdout.writeln('РЕЗУЛЬТАТ: НЕТ ДАННЫХ');
      exitCode = 2;
      return;
    }
    if (total + 0.05 < min) {
      stdout.writeln('РЕЗУЛЬТАТ: НИЖЕ ПОРОГА');
      exitCode = 1;
      return;
    }
    stdout.writeln('РЕЗУЛЬТАТ: OK');
    exitCode = 0;
  } catch (e, st) {
    stderr.writeln('coverage_report failed: $e');
    stderr.writeln(st);
    exitCode = 2;
  }
}