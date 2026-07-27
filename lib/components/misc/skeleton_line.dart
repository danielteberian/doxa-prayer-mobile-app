import 'package:flutter/material.dart';

import 'skeleton_box.dart';

/// A single pulsing line standing in for a line of text.
///
/// [widthFactor] shortens the line relative to the available width so a run of
/// lines reads as prose rather than a solid block.
class SkeletonLine extends StatelessWidget {
  const SkeletonLine({super.key, this.widthFactor = 1.0, this.height = 12.0});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Text lines grow with the user's font scale, so the placeholder does too —
    // otherwise the skeleton under-reports the height of the content it stands
    // in for and the page jumps when the real text arrives.
    final scaled = MediaQuery.textScalerOf(context).scale(height);
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: SkeletonBox(height: scaled),
      ),
    );
  }
}
