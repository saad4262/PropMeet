import 'package:flutter/material.dart';
import 'package:propmeet/shared/constants/app_colors.dart';

class PulseAnimation extends StatefulWidget {
  final Widget child;
  const PulseAnimation({super.key, required this.child});

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // multiple expanding circles
          ...List.generate(3, (index) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.4, end: 1.6).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: Interval(index * 0.2, 1, curve: Curves.easeOut),
                ),
              ),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade600.withOpacity(0.2),
                ),
              ),
            );
          }),
          widget.child,
        ],
      ),
    );
  }
}
