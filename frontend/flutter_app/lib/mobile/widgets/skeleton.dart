import 'package:flutter/material.dart';

class Skeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? radius;

  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius,
  });

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _gradientPosition = Tween<double>(begin: -1, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _gradientPosition,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.radius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1, 0),
              end: Alignment(1, 0),
              colors: [Colors.grey.shade300, Colors.grey.shade100, Colors.grey.shade300],
              stops: [
                (_gradientPosition.value - 0.3).clamp(0.0, 1.0),
                _gradientPosition.value.clamp(0.0, 1.0),
                (_gradientPosition.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}