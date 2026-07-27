import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../misc/skeleton_box.dart';
import '../misc/skeleton_line.dart';
import 'elevated_card.dart';

/// Loading placeholder mirroring [PeopleGroupListCard]: a square image block,
/// the group name, and the profile / select controls.
class PeopleGroupListCardSkeleton extends StatelessWidget {
  const PeopleGroupListCardSkeleton({super.key});

  /// Matches the button min-height in [AppTheme] closely enough that the card
  /// does not resize when the real controls replace it.
  static const double _buttonHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    return ElevatedAppCard(
      padding: AppSpacing.xl,
      child: Column(
        spacing: AppSpacing.sm,
        children: [
          Row(
            spacing: AppSpacing.md,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SkeletonBox(width: 96, height: 96, radius: 16),
              const Expanded(child: SkeletonLine(widthFactor: 0.7)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(width: 72, height: _buttonHeight, radius: 28),
              SkeletonBox(width: 110, height: _buttonHeight, radius: 28),
            ],
          ),
        ],
      ),
    );
  }
}
