import '../entities/declined_name.dart';

/// Офлайн-склонение ФИО в дательный падеж (вариант «а»: свой правил-бейсд
/// склонятель, без внешних пакетов). Покрывает типовые русские имена,
/// отчества и фамилии. Любое сомнение → success=false, UI предложит
/// ручной ввод дательного падежа (fallback по ТЗ 6.3.14).
class DeclineNameUseCase {
  DeclinedName call(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return DeclinedName(original: name, dative: name, success: false);
    }
    final words = trimmed.split(RegExp(r'\s+'));
    final out = <String>[];
    for (final w in words) {
      final d = _declineWord(w);
      if (d == null) {
        return DeclinedName(original: name, dative: name, success: false);
      }
      out.add(d);
    }
    return DeclinedName(original: name, dative: out.join(' '), success: true);
  }

  String? _declineWord(String w) {
    final s = w.toLowerCase();
    String? r;
    if (s.endsWith('ский')) {
      r = '${s.substring(0, s.length - 2)}ому';
    } else if (s.endsWith('ская')) {
      r = '${s.substring(0, s.length - 4)}ской';
    } else if (s.endsWith('ова') || s.endsWith('ева')) {
      r = '${s.substring(0, s.length - 1)}ой';
    } else if (_femFirstIna.contains(s)) {
      // Женские имена на -ина (Ирина, Галина...) — не фамилии.
      r = '${s.substring(0, s.length - 1)}е';
    } else if ((s.endsWith('ина') || s.endsWith('ына')) && s.length >= 5) {
      r = '${s.substring(0, s.length - 1)}ой';
    } else if (s.endsWith('вич') || s.endsWith('ич')) {
      r = '$sу';
    } else if (s.endsWith('ия') || s.endsWith('ея')) {
      r = '${s.substring(0, s.length - 2)}ии';
    } else if (s.endsWith('ья')) {
      r = '${s.substring(0, s.length - 2)}ье';
    } else if (s.endsWith('я')) {
      r = '${s.substring(0, s.length - 1)}е';
    } else if (s.endsWith('а')) {
      r = '${s.substring(0, s.length - 1)}е';
    } else if (s.endsWith('й')) {
      r = '${s.substring(0, s.length - 1)}ю';
    } else if (s.endsWith('ь')) {
      if (_maleSoft.contains(s)) {
        r = '${s.substring(0, s.length - 1)}ю';
      } else if (_femaleSoft.contains(s)) {
        r = s; // 3-е склонение: не изменяется
      } else {
        return null;
      }
    } else if (s.endsWith('о') || s.endsWith('е') || s.endsWith('э') ||
        s.endsWith('у') || s.endsWith('и')) {
      r = s; // несклоняемые заимствованные
    } else if (RegExp(r'[бвгджзклмнпрстфхцчшщ]$').hasMatch(s)) {
      r = '$sу'; // мужские на согласный
    } else {
      return null;
    }
    return _restoreCase(w, r);
  }

  String _restoreCase(String original, String declined) {
    if (original.isNotEmpty &&
        declined.isNotEmpty &&
        original[0] == original[0].toUpperCase() &&
        original[0] != original[0].toLowerCase()) {
      return declined[0].toUpperCase() + declined.substring(1);
    }
    return declined;
  }

  static const Set<String> _femFirstIna = {
    'нина', 'зина', 'алина', 'марина', 'ирина', 'галина',
    'полина', 'валентина', 'ангелина', 'карина',
  };
  static const Set<String> _maleSoft = {'игорь'};
  static const Set<String> _femaleSoft = {'любовь'};
}