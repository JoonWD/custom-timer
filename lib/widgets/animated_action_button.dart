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
  }) : assert(icon != null || child != null, 'Debe haber icon o child');

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  bool _busy = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );

    _scale = Tween(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_busy) return;
    _busy = true;

    _controller.forward().then((_) {
      if (!mounted) return;
      _controller.reverse();
    });

    HapticFeedback.mediumImpact();
    widget.onPressed();

    Future.delayed(const Duration(milliseconds: 160), () {
      _busy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final shape = widget.isCircle
        ? const CircleBorder()
        : RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));

    return ScaleTransition(
      scale: _scale,
      child: Material(
        color: Colors.transparent,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: _handleTap,
          child: Padding(
            padding: widget.isCircle
                ? const EdgeInsets.all(22)
                : const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: widget.child ??
                Icon(
                  widget.icon,
                  color: widget.foregroundColor,
                ),
          ),
        ),
      ),
    );
  }
}
