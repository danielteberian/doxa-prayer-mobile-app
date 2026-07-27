import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../misc/skeleton_box.dart';
import '../misc/skeleton_line.dart';
import '../misc/skeleton_paragraph.dart';
import 'elevated_card.dart';

/// Loading placeholder for the hero card on the people-group details screen:
/// name, portrait, country line and description.
class PeopleGroupHeroCardSkeleton extends StatelessWidget {
  const PeopleGroupHeroCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const ElevatedAppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSpacing.lg,
        children: [
          FractionallySizedBox(
            widthFactor: 0.55,
            child: SkeletonLine(height: 20),
          ),
          SkeletonBox(width: 240, height: 240, radius: 16),
          FractionallySizedBox(
            widthFactor: 0.4,
            child: SkeletonLine(height: 16),
          ),
          SkeletonParagraph(lines: 3),
        ],
      ),
    );
  }
}
