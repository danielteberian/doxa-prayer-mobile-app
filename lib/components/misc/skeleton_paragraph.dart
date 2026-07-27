import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import 'skeleton_line.dart';

/// A block of pulsing lines standing in for a paragraph of body text.
///
/// The last line is short so the block reads as prose that ran out mid-line
/// rather than a solid rectangle.
class SkeletonParagraph extends StatelessWidget {
  const SkeletonParagraph({
    super.key,
    this.lines = 3,
    this.lastLineWidthFactor = 0.6,
  });

  final int lines;
  final double lastLineWidthFactor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.sm,
      children: [
        for (var i = 0; i < lines; i++)
          SkeletonLine(
            widthFactor: i == lines - 1 ? lastLineWidthFactor : 1.0,
          ),
      ],
    );
  }
}
