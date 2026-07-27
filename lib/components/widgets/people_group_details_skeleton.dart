import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../cards/detail_section_card_skeleton.dart';
import '../cards/people_group_hero_card_skeleton.dart';
import '../misc/skeleton_box.dart';

/// Loading placeholder for the people-group details screen: the select button,
/// the hero card, and the stacked detail sections below it.
class PeopleGroupDetailsSkeleton extends StatelessWidget {
  const PeopleGroupDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      // There is nothing below the fold yet, and a placeholder that bounces
      // implies content the user could scroll to.
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.xl,
        children: [
          Center(child: SkeletonBox(width: 200, height: 36, radius: 28)),
          PeopleGroupHeroCardSkeleton(),
          DetailSectionCardSkeleton(rows: 4),
        ],
      ),
    );
  }
}
