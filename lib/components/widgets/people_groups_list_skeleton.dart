import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../cards/people_group_list_card_skeleton.dart';
import '../misc/skeleton_line.dart';

/// Loading placeholder for [PeopleGroupsList]: the results count followed by a
/// screenful of card placeholders, laid out exactly like the real list so the
/// page does not reflow when the groups arrive.
class PeopleGroupsListSkeleton extends StatelessWidget {
  const PeopleGroupsListSkeleton({
    super.key,
    this.bottomPadding = 0,
    this.count = 4,
  });

  final double bottomPadding;

  /// Enough cards to fill a phone viewport; the list is not scrollable while
  /// loading, so extra cards would only be built and never seen.
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      // Nothing here reacts to a scroll, and letting the placeholder bounce
      // implies content the user could reach.
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: bottomPadding),
      itemCount: count + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
      itemBuilder: (context, i) => i == 0
          ? const SkeletonLine(widthFactor: 0.35, height: 10)
          : const PeopleGroupListCardSkeleton(),
    );
  }
}
