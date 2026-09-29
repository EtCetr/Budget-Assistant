import 'secrecy_candidate.dart';

/// Передача кандидатов в подарки на ImportSecretsScreen (15.5)
/// вместе с ID созданных транзакций (по rowIndex строки).
class ImportSecrecyHandoff {
  const ImportSecrecyHandoff({
    required this.candidates,
    required this.transactionIdByRowIndex,
  });
  final List<SecrecyCandidate> candidates;
  final Map<int, String> transactionIdByRowIndex;
}