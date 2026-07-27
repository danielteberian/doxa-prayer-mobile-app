import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../misc/skeleton_line.dart';
import 'elevated_card.dart';

/// Loading placeholder for a titled card of label/value rows, as used by the
/// overview and resources sections of the people-group details screen.
class DetailSectionCardSkeleton extends StatelessWidget {
  const DetailSectionCardSkeleton({super.key, this.rows = 4});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return ElevatedAppCard(
      padding: AppSpacing.xl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          const SkeletonLine(widthFactor: 0.4, height: 16),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < rows; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Row(
                spacing: AppSpacing.sm,
                children: [
                  SizedBox(width: 140, child: SkeletonLine()),
                  Expanded(child: SkeletonLine(widthFactor: 0.7)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
