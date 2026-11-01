// Runtime icon lookup by design; release builds use --no-tree-shake-icons.
// ignore_for_file: non_const_argument_for_const_parameter

import 'package:flutter/widgets.dart';

import 'phosphor_codepoints.g.dart';

const phosphorWeights = ['regular', 'fill', 'bold', 'light', 'thin'];

/// Resolves a stored icon spec `"<phosphor-name>:<weight>"` to [IconData].
///
/// Not mirrored in RTL: category icons are pictures, not directions.
IconData appIcon(String spec) {
  final i = spec.indexOf(':');
  final name = i < 0 ? spec : spec.substring(0, i);
  // Duotone glyphs need a second layer we do not draw; show them as regular.
  final w = i < 0 ? 'regular' : spec.substring(i + 1);
  final weight = w == 'duotone' ? 'regular' : w;
  final family = 'Phosphor${weight[0].toUpperCase()}${weight.substring(1)}';
  return IconData(
    phosphorCodepoints[name] ?? phosphorCodepoints['question']!,
    fontFamily: family,
    fontPackage: 'phosphor_flutter',
  );
}
