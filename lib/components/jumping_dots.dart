import 'dart:math' as math;

import 'package:flutter/material.dart';

class MiniJumpingDots extends StatefulWidget {
  const MiniJumpingDots({
    super.key,
    this.color,
    this.dotCount = 3,
    this.dotSize = 3.0,
    this.dotSpacing = 2.0,
    this.amplitude = 3.0,
    this.duration = const Duration(milliseconds: 900),
  });

  final Color? color;
  final int dotCount;
  final double dotSize;
  final double dotSpacing;
  final double amplitude;
  final Duration duration;

  @override
  State<MiniJumpingDots> createState() => _MiniJumpingDotsState();
}

class _MiniJumpingDotsState extends State<MiniJumpingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color dotColor = widget.color ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black87);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.dotCount * 2 - 1, (index) {
            if (index.isOdd) {
              return SizedBox(width: widget.dotSpacing);
            }
            final int dotIndex = index ~/ 2;
            final double phase = (dotIndex / widget.dotCount);
            final double t = (_controller.value + phase) % 1.0;
            // y = -A * sin(pi * t) で上下に小さくジャンプ
            final double dy = -widget.amplitude * math.sin(math.pi * t);
            // スケールも少しだけ変化
            final double scale = 0.85 + 0.15 * math.sin(math.pi * t).abs();

            return Transform.translate(
              offset: Offset(0, dy),
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}


