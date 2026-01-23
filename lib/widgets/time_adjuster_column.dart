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

    final icon = mode == AdjusterMode.increment
        ? Icons.keyboard_arrow_up
        : Icons.keyboard_arrow_down;

    final tooltip = mode == AdjusterMode.increment
        ? '+ $label'
        : '- $label';

    return Tooltip(
      message: tooltip,
      child: AnimatedIconButton(
        icon: icon,
        color: theme.colorScheme.primary,
        onPressed: onPressed,
      ),
    );
  }
}
