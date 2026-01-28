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

        // Escalado más controlado para evitar deformaciones
        final scale = (width / 420).clamp(0.65, 1.05);

        final baseFontSize = theme.textTheme.displayMedium?.fontSize ?? 48;

        final textStyle = theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.8 * scale,
          fontSize: baseFontSize * scale,
          color: theme.colorScheme.primary,
        );

        final horizontalPadding = 22 * scale;
        final verticalPadding = 14 * scale;
        final borderRadius = 18 * scale;

        return Center(
          child: FittedBox( // <-- esto evita overflow en tamaños extremos
            fit: BoxFit.scaleDown,
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
                    blurRadius: 10 * scale,
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
          ),
        );
      },
    );
  }
}
