import 'package:flutter/material.dart';
import 'digit_wheel.dart';

class TimerDisplay extends StatelessWidget {
  final String time;

  const TimerDisplay({
    super.key,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Escalado progresivo controlado
        final scale = (width / 500).clamp(0.75, 1.2);

        final textStyle = theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 2 * scale,
          fontSize: (theme.textTheme.displayMedium?.fontSize ?? 48) * scale,
          color: theme.colorScheme.primary,
        );

        final horizontalPadding = 24 * scale;
        final verticalPadding = 16 * scale;
        final borderRadius = 20 * scale;

        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.12),
                  blurRadius: 12 * scale,
                  offset: Offset(0, 4 * scale),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: time.split('').map((char) {
                if (char == ':') {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4 * scale),
                    child: Text(':', style: textStyle),
                  );
                }

                return DigitWheel(
                  digit: char,
                  textStyle: textStyle!,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
