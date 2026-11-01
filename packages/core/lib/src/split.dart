enum SplitMode { equal, percent, exact }

/// What each other person owes for an expense of [total] (positive Rial).
///
/// [inputs] has one entry per person: ignored for [SplitMode.equal], a
/// percentage (0..100) for [SplitMode.percent], an amount for [SplitMode.exact].
/// "Equal" splits between the people and you, so the remainder of the
/// integer division stays with you. Returns null when the inputs would make
/// others owe more than [total].
List<int>? splitShares(int total, SplitMode mode, List<int> inputs) {
  if (total <= 0 || inputs.isEmpty) return null;
  final List<int> shares = switch (mode) {
    SplitMode.equal => List.filled(inputs.length, total ~/ (inputs.length + 1)),
    SplitMode.percent => [for (final p in inputs) total * p ~/ 100],
    SplitMode.exact => List.of(inputs),
  };
  if (shares.any((s) => s < 0) || shares.fold(0, (a, b) => a + b) > total) return null;
  return shares;
}
