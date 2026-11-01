import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../state.dart';

class PersonBalance {
  const PersonBalance(this.person, this.balance);
  final Person person;

  /// Positive: they owe me. Negative: I owe them.
  final int balance;
}

final peopleBalancesProvider = StreamProvider<List<PersonBalance>>((ref) {
  final db = ref.watch(dbProvider);
  return db.customSelect('''
    SELECT p.id AS id,
      COALESCE((SELECT SUM(share) FROM splits WHERE person_id = p.id), 0)
      - COALESCE((SELECT SUM(amount) FROM settlements WHERE person_id = p.id), 0) AS bal
    FROM people p
  ''', readsFrom: {db.people, db.splits, db.settlements}).watch().asyncMap((rows) async {
    final people = {for (final p in await db.select(db.people).get()) p.id: p};
    final out = [for (final r in rows) PersonBalance(people[r.read<int>('id')]!, r.read<int>('bal'))];
    out.sort((a, b) => b.balance.abs().compareTo(a.balance.abs()));
    return out;
  });
});

class LedgerEntry {
  const LedgerEntry({required this.isSplit, required this.id, required this.at, required this.amount, required this.note, this.txId, this.txNote});
  final bool isSplit;
  final int id;
  final DateTime at;

  /// Change to what they owe me: positive = they owe me more.
  final int amount;
  final String note;
  final int? txId;
  final String? txNote;
}

final ledgerProvider = StreamProvider.family<List<LedgerEntry>, int>((ref, personId) {
  final db = ref.watch(dbProvider);
  return db.customSelect('''
    SELECT 1 AS is_split, s.id AS id, s.occurred_at AS at, s.share AS amount, s.note AS note, s.transaction_id AS tx, t.note AS tx_note
      FROM splits s LEFT JOIN transactions t ON t.id = s.transaction_id WHERE s.person_id = ?1
    UNION ALL
    SELECT 0, st.id, st.occurred_at, -st.amount, st.note, st.transaction_id, NULL
      FROM settlements st WHERE st.person_id = ?1
    ORDER BY at DESC
  ''', variables: [Variable.withInt(personId)], readsFrom: {db.splits, db.settlements, db.transactions}).watch().map((rows) => [
        for (final r in rows)
          LedgerEntry(
            isSplit: r.read<int>('is_split') == 1,
            id: r.read<int>('id'),
            at: r.read<DateTime>('at'),
            amount: r.read<int>('amount'),
            note: r.read<String>('note'),
            txId: r.read<int?>('tx'),
            txNote: r.read<String?>('tx_note'),
          ),
      ]);
});

/// Splits attached to one transaction, with the person.
final txSplitsProvider = StreamProvider.family<List<(SplitRow, Person)>, int>((ref, txId) {
  final db = ref.watch(dbProvider);
  final q = db.select(db.splits).join([innerJoin(db.people, db.people.id.equalsExp(db.splits.personId))])
    ..where(db.splits.transactionId.equals(txId));
  return q.watch().map((rs) => [for (final r in rs) (r.readTable(db.splits), r.readTable(db.people))]);
});

/// Category split parts of a transaction (empty = not split).
final txPartsProvider = StreamProvider.family<List<TxPart>, int>((ref, txId) {
  final db = ref.watch(dbProvider);
  return (db.select(db.txParts)..where((p) => p.transactionId.equals(txId))..orderBy([(p) => OrderingTerm.desc(p.amount)])).watch();
});
