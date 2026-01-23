import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final Widget? child;
  final Color foregroundColor;
  final bool isCircle;

  const AnimatedActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.child,
    required this.foregroundColor,
    this.isCircle = false,
  }): assert(icon != null || child != null, 'Debe haber icon o child');

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //No vemos todas las animaciones. solo pausa pero sin await
  void _handlePress() {
    HapticFeedback.mediumImpact();
    widget.onPressed();

    _controller.forward().then((_) {
      if (mounted) _controller.reverse();
    });
  }

  //Vemos todas las animaciones pero crea muchos awaits

  /*   Future<void> _handlePress() async {
    await _controller.forward();
    await _controller.reverse();
    await HapticFeedback.mediumImpact();
    widget.onPressed();
  } */

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.isCircle
          ? OutlinedButton(
              onPressed: _handlePress,
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.foregroundColor,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(22),
              ),
              child: Icon(widget.icon),
            )
          : OutlinedButton(
              onPressed: _handlePress,
              style: OutlinedButton.styleFrom(
                foregroundColor: widget.foregroundColor,
              ),
              child: Icon(widget.icon),
            ),
    );
  }
}
