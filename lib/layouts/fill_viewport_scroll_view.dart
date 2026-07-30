import 'package:flutter/material.dart';

/// A scroll view whose content fills the viewport when short and scrolls when
/// tall (e.g. at large accessibility font scales).
///
/// The content is given a minimum height of the viewport and an unbounded
/// maximum, so a [Column] built by [builder] can bottom-pin widgets with
/// `mainAxisAlignment` — the column takes the full viewport height when its
/// children are shorter, and the alignment distributes the slack; when the
/// children are taller it grows and the view scrolls instead of overflowing.
///
/// A two-child column with [MainAxisAlignment.spaceBetween] is the usual shape:
/// content grouped in an inner `Column(mainAxisSize: MainAxisSize.min)`, with
/// the pinned widget last.
///
/// With [padKeyboardInset] (the default), bottom scroll padding equal to the
/// keyboard height is added so content can be scrolled up above an overlaying
/// keyboard (use with `resizeToAvoidBottomInset: false` on the Scaffold).
///
/// One rule on the subtree built by [builder]: **no flex children** (no
/// [Expanded], no [Spacer]). Flex needs a bounded height, and bounding the
/// height here would mean measuring the content — which means intrinsic
/// measurement, which forbids the inner [LayoutBuilder]s that `HyphenatedText`
/// relies on to measure its available width. `mainAxisAlignment` replaces the
/// spacer; [SliverFillRemaining] is not an alternative, it measures intrinsics
/// too.
///
/// [builder] still receives the available `maxWidth` for widgets that prefer to
/// be told rather than measure (e.g. `ButtonBarWrap(maxWidth: maxWidth, ...)`).
class FillViewportScrollView extends StatelessWidget {
  const FillViewportScrollView({
    super.key,
    required this.builder,
    this.padKeyboardInset = true,
  });

  /// Builds the content column. `maxWidth` is the width the content is laid
  /// out in — pass it to any child that needs to measure the available width
  /// (a [LayoutBuilder] would break the intrinsic-height measurement).
  final Widget Function(BuildContext context, double maxWidth) builder;

  /// Whether to add bottom scroll padding equal to the keyboard inset, so the
  /// content can be scrolled above a keyboard that overlays the view.
  final bool padKeyboardInset;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = padKeyboardInset
        ? MediaQuery.viewInsetsOf(context).bottom
        : 0.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: builder(context, constraints.maxWidth),
          ),
        );
      },
    );
  }
}
