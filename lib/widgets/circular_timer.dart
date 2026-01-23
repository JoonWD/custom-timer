import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CircularTimer extends StatefulWidget {
  final Duration current;
  final Duration total;
  final bool isRunning;
  final bool isFinished;

  const CircularTimer({
    super.key,
    required this.current,
    required this.total,
    required this.isRunning,
    required this.isFinished,
  });

  @override
  State<CircularTimer> createState() => _CircularTimerState();
}

class _CircularTimerState extends State<CircularTimer>
    with TickerProviderStateMixin {
  // ===== Ticker visual suave =====
  late Ticker _ticker;
  late Duration _lastReported;
  late DateTime _lastTickTime;

  double _visualProgress = 1.0;

  // ===== Animación collapse =====
  late AnimationController _collapseController;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  late Animation<double> _shake;

  @override
  void initState() {
    super.initState();

    // --- Collapse animation ---
    _collapseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _collapseController, curve: Curves.easeOut),
    );

    _opacity = Tween<double>(begin: 1.0, end: 0.4).animate(
      CurvedAnimation(parent: _collapseController, curve: Curves.easeOut),
    );

    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -6), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -6, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: -4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4, end: 4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 4, end: 0), weight: 1),
    ]).animate(_collapseController);

    // --- Visual ticker ---
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

    // --- Actualizar progreso cuando cambia el tiempo ---
    if (widget.current != oldWidget.current) {
      _lastReported = widget.current;
      _lastTickTime = DateTime.now();
    }

    // --- Control ticker ---
    if (widget.isRunning && !_ticker.isActive) {
      _lastTickTime = DateTime.now();
      _ticker.start();
    }

    if (!widget.isRunning && _ticker.isActive) {
      _ticker.stop();
    }

    // --- Detectar transición a finished ---
    if (!oldWidget.isFinished && widget.isFinished) {
      _collapseController.forward();
      setState(() {
        _visualProgress = 0;
      });
    }

    // --- Si vuelve de finished → reset animación ---
    if (oldWidget.isFinished && !widget.isFinished) {
      _collapseController.reset();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _collapseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _collapseController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shake.value, 0),
          child: Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _opacity.value,
              child: child,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 260,
        height: 260,
        child: CustomPaint(
          painter: _CirclePainter(
            progress: _visualProgress,
            color: color,
            isFinished: widget.isFinished,
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
  final bool isFinished;

  _CirclePainter({
    required this.progress,
    required this.color,
    required this.isFinished,
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

    final eased = Curves.easeOut.transform(progress.clamp(0.0, 1.0));

    // Glow solo si no está terminado
    if (!isFinished && eased > 0.02) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * eased,
        false,
        glowPaint,
      );
    }

    // Progreso
    if (eased > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * eased,
        false,
        progressPaint,
      );
    }

    // Huella visual cuando termina
    if (isFinished) {
      final ghostPaint = Paint()
        ..color = color.withOpacity(0.12)
        ..strokeWidth = 12
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(center, radius, ghostPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isFinished != isFinished;
  }
}
