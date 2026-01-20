import 'package:flutter/material.dart';

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
        ? Icons.add
        : Icons.remove;

    final tooltip = mode == AdjusterMode.increment
        ? 'Increment $label'
        : 'Decrement $label';

    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
          iconSize: 30,
          splashRadius: 22,
          color: theme.colorScheme.primary,
          tooltip: tooltip,
        ),
      ],
    );
  }
}
