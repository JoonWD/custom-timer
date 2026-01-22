import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CircularTimer extends StatefulWidget {
  final Duration current;
  final Duration total;
  final bool isRunning;

  const CircularTimer({
    super.key,
    required this.current,
    required this.total,
    required this.isRunning,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late Duration _lastReported;
  late DateTime _lastTickTime;

  double _visualProgress = 1.0;

  @override
  void initState() {
    super.initState();
    _lastReported = widget.current;
    _lastTickTime = DateTime.now();

    _ticker = createTicker((_) {
      if (!widget.isRunning) return;
      if (widget.total.inMilliseconds == 0) return;

      final elapsed =
          DateTime.now().difference(_lastTickTime).inMilliseconds;

      final realRemaining = (_lastReported.inMilliseconds - elapsed)
          .clamp(0, widget.total.inMilliseconds);

      setState(() {
        _visualProgress = realRemaining / widget.total.inMilliseconds;
      });
    });

    if (widget.isRunning) {
      _ticker.start();
    }
  }

  @override
  void didUpdateWidget(covariant CircularTimer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.current != oldWidget.current) {
      _lastReported = widget.current;
      _lastTickTime = DateTime.now();
    }

    if (widget.isRunning && !_ticker.isActive) {
      _lastTickTime = DateTime.now();
      _ticker.start();
    }

    if (!widget.isRunning && _ticker.isActive) {
      _ticker.stop();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: 260,
      height: 260,
      child: CustomPaint(
        painter: _CirclePainter(
          progress: _visualProgress,
          color: color,
        ),
        child: Center(
          child: Text(
            _format(widget.current),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _CirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  _CirclePainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.08)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..strokeWidth = 22
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
      ..style = PaintingStyle.stroke;

    final gradient = SweepGradient(
      startAngle: -pi / 2,
      endAngle: 3 * pi / 2,
      colors: [
        color.withOpacity(0.3),
        color,
        color.withOpacity(0.9),
      ],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Fondo
    canvas.drawCircle(center, radius, backgroundPaint);

    // Glow
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * progress,
        false,
        glowPaint,
      );
    }

    // Progreso principal
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
