import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'action_button.dart';

/// Bottom button group used by the wizard steps.
///
/// Lays the two buttons out side by side (equal width) when both labels fit on
/// one line in half the row, and stacks them full width when a long (e.g.
/// translated or text-scaled) label would otherwise wrap. Once stacked a label
/// may still wrap — at full width there is nothing further to give it.
class ButtonBarWrap extends StatelessWidget {
  const ButtonBarWrap({
    super.key,
    required this.leading,
    required this.trailing,
    this.spacing = AppSpacing.md,
    this.maxWidth,
  });

  /// Left/secondary action (e.g. back, skip).
  final ActionButton leading;

  /// Right/primary action (e.g. save, continue, finish).
  final ActionButton trailing;

  final double spacing;

  /// Available width to lay out within. When null, a [LayoutBuilder] measures
  /// it. Pass an explicit value when this bar lives inside an [IntrinsicHeight]
  /// (e.g. a scrollable wizard step) — [LayoutBuilder] cannot report intrinsic
  /// dimensions and would break the surrounding intrinsic-height measurement.
  final double? maxWidth;

  /// Horizontal chrome (padding + border) a label button occupies on top of
  /// its text. A deliberate over-estimate so we stack just before overflowing
  /// rather than just after.
  static const double _buttonChrome = 56.0;

  double _labelWidth(BuildContext context, String label) {
    final style = Theme.of(context).textTheme.labelLarge;
    final painter = TextPainter(
      text: TextSpan(text: label.toUpperCase(), style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    return painter.width + _buttonChrome;
  }

  Widget _layout(BuildContext context, double maxWidth) {
    // Side by side the two buttons are equal width, so each one only gets half
    // the row. Size the row off the *wider* label rather than the combined
    // width: otherwise a long label (e.g. "CONTINUE" next to a short "BACK")
    // wraps inside its own half while the pair still "fits", when stacking the
    // buttons would have kept both labels on one line.
    final widest = math.max(
      _labelWidth(context, leading.label),
      _labelWidth(context, trailing.label),
    );

    if (widest * 2 + spacing <= maxWidth) {
      return Row(
        children: [
          Expanded(child: leading),
          SizedBox(width: spacing),
          Expanded(child: trailing),
        ],
      );
    }

    // Stacked, full width. Primary action sits on top.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        trailing,
        SizedBox(height: spacing),
        leading,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = maxWidth;
    if (width != null) {
      return _layout(context, width);
    }
    return LayoutBuilder(
      builder: (context, constraints) => _layout(context, constraints.maxWidth),
    );
  }
}
