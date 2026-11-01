/// Minimal transaction view for detection algorithms.
class TxLite {
  const TxLite(this.id, this.accountId, this.amount, this.at);
  final int id, accountId;

  /// Signed Rial.
  final int amount;
  final DateTime at;
}

/// Pairs an outgoing and an incoming transaction of the same amount on two
/// different accounts within [window]. Each transaction is used at most once;
/// the closest-in-time match wins. Returns (outId, inId).
List<(int, int)> findTransferPairs(List<TxLite> txs, {Duration window = const Duration(minutes: 10)}) {
  final outs = txs.where((t) => t.amount < 0).toList()..sort((a, b) => a.at.compareTo(b.at));
  final ins = txs.where((t) => t.amount > 0).toList();
  final used = <int>{};
  final pairs = <(int, int)>[];
  for (final o in outs) {
    TxLite? best;
    for (final i in ins) {
      if (used.contains(i.id) || i.accountId == o.accountId || i.amount != -o.amount) continue;
      final d = i.at.difference(o.at).abs();
      if (d > window) continue;
      if (best == null || d < best.at.difference(o.at).abs()) best = i;
    }
    if (best != null) {
      used.add(best.id);
      pairs.add((o.id, best.id));
    }
  }
  return pairs;
}

class RecurringGuess {
  const RecurringGuess({required this.accountId, required this.amount, required this.periodDays, required this.lastAt, required this.count});
  final int accountId;

  /// Median signed amount.
  final int amount;
  final int periodDays;
  final DateTime lastAt;
  final int count;
  DateTime get nextDue => lastAt.add(Duration(days: periodDays));
}

/// Finds monthly repeats: same account and direction, amounts within
/// [tolerance] of each other, at least [minCount] occurrences, each gap
/// between 25 and 35 days.
List<RecurringGuess> detectRecurring(List<TxLite> txs, {double tolerance = 0.05, int minCount = 3}) {
  final sorted = [...txs]..sort((a, b) => a.amount.abs().compareTo(b.amount.abs()));
  final used = <int>{};
  final out = <RecurringGuess>[];
  for (final seed in sorted) {
    if (used.contains(seed.id)) continue;
    final group = sorted
        .where((t) =>
            !used.contains(t.id) &&
            t.accountId == seed.accountId &&
            t.amount.sign == seed.amount.sign &&
            (t.amount.abs() - seed.amount.abs()).abs() <= seed.amount.abs() * tolerance)
        .toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    if (group.length < minCount) continue;
    // Longest run of consecutive monthly gaps ending at the latest.
    var run = [group.last];
    for (var i = group.length - 2; i >= 0; i--) {
      final gap = run.first.at.difference(group[i].at).inDays;
      if (gap >= 25 && gap <= 35) {
        run.insert(0, group[i]);
      } else if (gap < 25) {
        continue; // extra purchase in the same month
      } else {
        break;
      }
    }
    if (run.length < minCount) continue;
    used.addAll(group.map((t) => t.id));
    final amounts = run.map((t) => t.amount).toList()..sort();
    final gaps = [for (var i = 1; i < run.length; i++) run[i].at.difference(run[i - 1].at).inDays]..sort();
    out.add(RecurringGuess(
      accountId: seed.accountId,
      amount: amounts[amounts.length ~/ 2],
      periodDays: gaps[gaps.length ~/ 2],
      lastAt: run.last.at,
      count: run.length,
    ));
  }
  return out;
}
