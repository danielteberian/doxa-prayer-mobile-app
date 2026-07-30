import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../misc/app_icon.dart';
import '../misc/triangle_icon.dart';
import 'nav_bar_title.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  /// Needs a [context] so the bar can be as tall as its wrapped title — see
  /// [NavBarTitle.preferredSizeFor].
  factory TopNavBar({
    Key? key,
    required BuildContext context,
    String? title,
    VoidCallback? onSettings,
    VoidCallback? onBack,
    VoidCallback? onGallery,
    VoidCallback? onDebug,
  }) => TopNavBar._(
    key: key,
    title: title,
    onSettings: onSettings,
    onBack: onBack,
    onGallery: onGallery,
    onDebug: onDebug,
    preferredSize: NavBarTitle.preferredSizeFor(
      context,
      title: title,
      hasLeading: onBack != null,
      actionCount: _actionCount(onSettings: onSettings, onDebug: onDebug),
    ),
  );

  const TopNavBar._({
    super.key,
    required this.title,
    required this.onSettings,
    required this.onBack,
    required this.onGallery,
    required this.onDebug,
    required this.preferredSize,
  });

  final String? title;
  final VoidCallback? onSettings;
  final VoidCallback? onBack;
  final VoidCallback? onGallery;
  final VoidCallback? onDebug;

  @override
  final Size preferredSize;

  /// Kept in step with the [actions] built below.
  static int _actionCount({VoidCallback? onSettings, VoidCallback? onDebug}) =>
      (kDebugMode ? 1 : 0) +
      (kDebugMode && onDebug != null ? 1 : 0) +
      (onSettings != null ? 1 : 0);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      // Must match preferredSize, or the Scaffold and the AppBar disagree on
      // how tall the bar is and the title clips.
      toolbarHeight: preferredSize.height,
      leading: onBack != null
          ? IconButton(
              icon: TriangleIcon(
                color: AppColors.onPrimary,
                direction: Directionality.of(context) == TextDirection.rtl
                    ? TriangleDirection.right
                    : TriangleDirection.left,
                size: 12,
              ),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack,
            )
          : null,
      centerTitle: true,
      title: title != null
          ? NavBarTitle(
              title!,
              color: AppColors.onPrimary,
              width: NavBarTitle.widthFor(
                context,
                hasLeading: onBack != null,
                actionCount: _actionCount(
                  onSettings: onSettings,
                  onDebug: onDebug,
                ),
              ),
            )
          : Image.asset(
              'assets/images/doxa-logo.png',
              height: AppTypography.lg,
              fit: BoxFit.contain,
              semanticLabel: l10n.appName,
            ),
      actions: [
        // Gallery ("Kitchen Sink") and Debug are dev-only tools — hidden in
        // release builds. kDebugMode is a compile-time constant, so the
        // tree-shaker drops these buttons entirely from release builds.
        if (kDebugMode)
          IconButton(
            icon: const Icon(
              Icons.widgets_outlined,
              color: AppColors.onPrimary,
            ),
            tooltip: 'Kitchen Sink',
            onPressed: onGallery,
          ),
        if (kDebugMode && onDebug != null)
          IconButton(
            icon: const Icon(
              Icons.bug_report_outlined,
              color: AppColors.onPrimary,
            ),
            tooltip: 'Debug',
            onPressed: onDebug,
          ),
        if (onSettings != null)
          IconButton(
            icon: const AppIcon(AppIconName.gear, color: AppColors.onPrimary),
            tooltip: l10n.settings,
            onPressed: onSettings,
          ),
      ],
      backgroundColor: AppColors.primary,
    );
  }
}
