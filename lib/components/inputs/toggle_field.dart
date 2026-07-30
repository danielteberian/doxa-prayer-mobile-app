import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';
import '../misc/hyphenated_text.dart';

class ToggleField extends StatelessWidget {
  const ToggleField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(child: _build(context));
  }

  Widget _build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyphenatedText(label, style: AppTypography.bodyLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    HyphenatedText(subtitle!, style: AppTypography.caption),
                  ],
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}
