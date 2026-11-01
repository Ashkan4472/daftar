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

/// Splits [total] (positive Rial) across categories. Unlike [splitShares] nothing
/// stays with "me": the parts must add up to [total]. [inputs] as in [splitShares];
/// for [SplitMode.equal] the remainder goes to the first part. Null when invalid.
List<int>? splitParts(int total, SplitMode mode, List<int> inputs) {
  if (total <= 0 || inputs.length < 2) return null;
  final List<int> parts = switch (mode) {
    SplitMode.equal => [for (var i = 0; i < inputs.length; i++) total ~/ inputs.length + (i == 0 ? total % inputs.length : 0)],
    SplitMode.percent => inputs.fold(0, (a, b) => a + b) == 100 ? [for (final p in inputs) total * p ~/ 100] : const [],
    SplitMode.exact => List.of(inputs),
  };
  if (parts.isEmpty || parts.any((p) => p <= 0)) return null;
  if (mode == SplitMode.percent) parts[0] += total - parts.fold(0, (a, b) => a + b); // rounding remainder
  return parts.fold(0, (a, b) => a + b) == total ? parts : null;
}
