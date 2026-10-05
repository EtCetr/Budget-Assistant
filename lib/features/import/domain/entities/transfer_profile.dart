/// Профиль детекции переводов между своими/семейными счетами.
/// Хранится в SecureStorage (JSON), без миграции БД.
class FamilyMember {
  final String name;
  final List<String> phones;
  const FamilyMember({this.name = '', this.phones = const []});

  Map<String, dynamic> toJson() => {'name': name, 'phones': phones};
  static FamilyMember fromJson(Map<String, dynamic> m) => FamilyMember(
        name: (m['name'] as String?) ?? '',
        phones: ((m['phones'] as List?) ?? const []).cast<String>(),
      );
}

class FamilyGroup {
  final String name;
  final List<FamilyMember> members;
  const FamilyGroup({this.name = '', this.members = const []});

  Map<String, dynamic> toJson() =>
      {'name': name, 'members': [for (final m in members) m.toJson()]};
  static FamilyGroup fromJson(Map<String, dynamic> m) => FamilyGroup(
        name: (m['name'] as String?) ?? '',
        members: [
          for (final x in ((m['members'] as List?) ?? const []))
            FamilyMember.fromJson((x as Map).cast<String, dynamic>()),
        ],
      );
}

class TransferProfile {
  final List<String> myPhones;
  final List<String> myNames;
  /// Считать переводы внутри семьи переводами (не расходом).
  /// Семейные телефоны/ФИО участвуют в детекте ТОЛЬКО при true.
  final bool familyAsTransfers;
  final List<FamilyGroup> families;

  const TransferProfile({
    this.myPhones = const [],
    this.myNames = const [],
    this.familyAsTransfers = false,
    this.families = const [],
  });

  List<String> effectivePhones() => [
        ...myPhones,
        if (familyAsTransfers)
          for (final f in families)
            for (final m in f.members)
              ...m.phones,
      ];

  List<String> effectiveNames() => [
        ...myNames,
        if (familyAsTransfers)
          for (final f in families)
            for (final m in f.members)
              if (m.name.trim().isNotEmpty) m.name,
      ];

  Map<String, dynamic> toJson() => {
        'myPhones': myPhones,
        'myNames': myNames,
        'familyAsTransfers': familyAsTransfers,
        'families': [for (final f in families) f.toJson()],
      };

  static TransferProfile fromJson(Map<String, dynamic> m) => TransferProfile(
        myPhones: ((m['myPhones'] as List?) ?? const []).cast<String>(),
        myNames: ((m['myNames'] as List?) ?? const []).cast<String>(),
        familyAsTransfers: (m['familyAsTransfers'] as bool?) ?? false,
        families: [
          for (final x in ((m['families'] as List?) ?? const []))
            FamilyGroup.fromJson((x as Map).cast<String, dynamic>()),
        ],
      );
}