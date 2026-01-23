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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 130),
    );

    _scale = Tween(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

//Vemos todas las animaciones pero con error await
/*   Future<void> _tap() async {
    await _controller.forward();
    await _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onPressed();
  } */

// sin error await pero no vemos todas las animaciones

void _tap() {
  _controller.forward().then((_) {
    _controller.reverse();
  });

  HapticFeedback.lightImpact();
  widget.onPressed();
}


  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Material(
        shape: const CircleBorder(),
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _tap,
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
