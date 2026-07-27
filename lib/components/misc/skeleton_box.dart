import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A pulsing placeholder block, shown in the space content will occupy while
/// it is still loading from the server.
///
/// Prefer this over a spinner for content whose shape is known in advance: the
/// layout settles once, when the request starts, instead of jumping when the
/// response lands.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({super.key, this.width, this.height, this.radius = 4});

  /// Null stretches to the incoming constraint, so a skeleton can take the
  /// full width of its parent without the parent knowing a pixel value.
  final double? width;
  final double? height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Honour the platform's "reduce motion" setting: the placeholder still
    // occupies the space, it just holds a steady tone instead of pulsing.
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0.5;
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Color.lerp(
                  AppColors.mutedSurface,
                  AppColors.outline,
                  Curves.easeInOut.transform(_controller.value),
                ),
                borderRadius: BorderRadius.circular(widget.radius),
              ),
            );
          },
        ),
      ),
    );
  }
}
