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
  late final AnimationController _controller;
  late final Animation<double> _scale;

  Timer? _repeatTimer;
  Duration _currentInterval = const Duration(milliseconds: 300);

  bool _disposed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scale = Tween(
      begin: 1.0,
      end: 0.88,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _disposed = true;
    _repeatTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _animateTap() {
    if (_controller.isAnimating || _disposed) return;

    _controller.forward().then((_) {
      if (mounted) _controller.reverse();
    });
  }

  void _handleTap() {
    _animateTap();
    HapticFeedback.lightImpact();
    widget.onPressed();
  }

  void _startAutoRepeat() {
    if (_disposed) return;

    _currentInterval = const Duration(milliseconds: 300);
    _repeatTimer?.cancel();

    _repeatTimer = Timer.periodic(_currentInterval, (timer) {
      if (_disposed) {
        timer.cancel();
        return;
      }

      widget.onPressed();
      HapticFeedback.lightImpact();
      _animateTap();

      if (_currentInterval.inMilliseconds > 80) {
        _currentInterval = Duration(
          milliseconds: (_currentInterval.inMilliseconds * 0.88).round(),
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _handleTap,
            onLongPressStart: (_) => _startAutoRepeat(),
            onLongPressEnd: (_) => _stopAutoRepeat(),
            onLongPressCancel: _stopAutoRepeat,
            child: Center(
              child: Icon(widget.icon, size: widget.size, color: widget.color),
            ),
          ),
        ),
      ),
    );
  }
}
