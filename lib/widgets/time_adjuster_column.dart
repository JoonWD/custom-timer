import 'package:flutter/material.dart';
import 'animated_icon_button.dart';

enum AdjusterMode { increment, decrement }

class TimeAdjusterColumn extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final AdjusterMode mode;

  const TimeAdjusterColumn({
    super.key,
    required this.label,
    required this.onPressed,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isIncrement = mode == AdjusterMode.increment;

    final icon = isIncrement
        ? Icons.keyboard_arrow_up
        : Icons.keyboard_arrow_down;

    final semanticLabel = isIncrement
        ? 'Increase $label'
        : 'Decrease $label';

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Tooltip(
        message: semanticLabel,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          child: AnimatedIconButton(
            icon: icon,
            color: theme.colorScheme.primary,
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
