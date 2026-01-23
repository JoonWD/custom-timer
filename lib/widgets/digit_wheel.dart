import 'package:flutter/material.dart';
import 'dart:ui';

class DigitWheel extends StatefulWidget {
  final String digit;
  final TextStyle textStyle;

  const DigitWheel({super.key, required this.digit, required this.textStyle});

  @override
  State<DigitWheel> createState() => _DigitWheelState();
}

class _DigitWheelState extends State<DigitWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _incoming;
  late Animation<Offset> _outgoing;

  late String _oldDigit;

  @override
  void initState() {
    super.initState();
    _oldDigit = widget.digit;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    _configureAnimations(isIncrement: true);
  }

  @override
  void didUpdateWidget(covariant DigitWheel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.digit != widget.digit) {
      final oldVal = int.tryParse(oldWidget.digit) ?? 0;
      final newVal = int.tryParse(widget.digit) ?? 0;

      final isIncrement = newVal > oldVal || (oldVal == 9 && newVal == 0);

      _oldDigit = oldWidget.digit;
      _configureAnimations(isIncrement: isIncrement);

      _controller.forward(from: 0);
    }
  }

  void _configureAnimations({required bool isIncrement}) {
    final inBegin = Offset(0, isIncrement ? 0.9 : -0.9);
    final outEnd = Offset(0, isIncrement ? -0.6 : 0.6);

    _incoming = Tween<Offset>(
      begin: inBegin,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _outgoing = Tween<Offset>(
      begin: Offset.zero,
      end: outEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 27,
      height: 70,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final animating = _controller.isAnimating;
            final blur = animating ? (1.2 * (1 - _controller.value)) : 0.0;

            return Stack(
              alignment: Alignment.center,
              children: [
                if (animating)
                  SlideTransition(
                    position: _outgoing,
                    child: Opacity(
                      opacity: 1 - _controller.value,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaX: blur,
                          sigmaY: blur,
                        ),
                        child: Text(_oldDigit, style: widget.textStyle),
                      ),
                    ),
                  ),

                animating
                    ? SlideTransition(
                        position: _incoming,
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(
                            sigmaX: blur,
                            sigmaY: blur,
                          ),
                          child: Text(widget.digit, style: widget.textStyle),
                        ),
                      )
                    : Text(widget.digit, style: widget.textStyle),
              ],
            );
          },
        ),
      ),
    );
  }
}
