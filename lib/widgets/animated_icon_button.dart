import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final double size;

  const AnimatedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.color,
    this.size = 32,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  Timer? _repeatTimer;
  Duration _currentInterval = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scale = Tween(begin: 1.0, end: 0.86).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // --- Animación segura sin await bug ---
  void _animateTap() {
    if (_controller.isAnimating) return;

    _controller.forward().then((_) {
      if (mounted) _controller.reverse();
    });
  }

  // --- Tap normal ---
  void _handleTap() {
    _animateTap();
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  // --- Long press inicio (estilo iOS) ---
  void _startAutoRepeat() {
    _currentInterval = const Duration(milliseconds: 300);

    _repeatTimer?.cancel();
    _repeatTimer = Timer.periodic(_currentInterval, (timer) {
      widget.onPressed();
      HapticFeedback.lightImpact();
      _animateTap();

      // Aceleración progresiva
      if (_currentInterval.inMilliseconds > 60) {
        _currentInterval = Duration(
          milliseconds: (_currentInterval.inMilliseconds * 0.85).round(),
        );
        timer.cancel();
        _startAutoRepeat();
      }
    });
  }

  void _stopAutoRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _handleTap,
          onLongPressStart: (_) => _startAutoRepeat(),
          onLongPressEnd: (_) => _stopAutoRepeat(),
          onLongPressCancel: _stopAutoRepeat,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              widget.icon,
              size: widget.size,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}