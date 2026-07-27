import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'skeleton_box.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    this.url,
    this.aspectRatio = 16 / 9,
    this.radius = 16,
    this.fit = BoxFit.cover,
    this.size = 96.0,
    this.semanticLabel,
  });

  final String? url;
  final double aspectRatio;
  final double radius;
  final BoxFit fit;
  final double size;

  /// Describes the photo for screen readers. When null the image is treated as
  /// decorative and excluded from the semantics tree.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url == null || url!.isEmpty
          ? _placeholder()
          : SizedBox(
              width: size,
              height: size,
              child: Image.network(
                url!,
                fit: fit,
                semanticLabel: semanticLabel,
                excludeFromSemantics: semanticLabel == null,
                // These images come off the network uncached, so without a
                // placeholder the layout holds an empty gap until the bytes
                // arrive. A pulsing block fills the exact final footprint.
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return SkeletonBox(width: size, height: size, radius: radius);
                },
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              ),
            ),
    );
  }

  /// Shown when there is no image to load, and when loading fails — both leave
  /// the same hole in the layout, so they get the same filler.
  Widget _placeholder() {
    return Container(
      width: size,
      height: size,
      color: AppColors.mutedSurface,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: 48,
        color: AppColors.onSurface.withValues(alpha: 0.4),
      ),
    );
  }
}
