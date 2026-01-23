import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuickAdjustButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const QuickAdjustButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  State<QuickAdjustButton> createState() => _QuickAdjustButtonState();
}

class _QuickAdjustButtonState extends State<QuickAdjustButton>
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

    _scale = Tween(begin: 1.0, end: 0.88).animate(
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

//sin error await pero no vemos todas las animaciones

void _tap() {
  _controller.forward().then((_) {
    _controller.reverse();
  });

  HapticFeedback.lightImpact();
  widget.onPressed();
}


  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return ScaleTransition(
      scale: _scale,
      child: Material(
        shape: const CircleBorder(),
        color: color.withOpacity(0.08),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _tap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              widget.label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
