import 'package:flutter/material.dart';

import '../utils/constants.dart';

/// Draws [AppConstants.watermarkText] tiled and rotated across whatever it
/// wraps. This is painted as part of the widget tree (not added after the
/// fact), so anything that captures this widget — including a screenshot or
/// an exported share image — captures the watermark baked in, with no layer
/// to crop out or paint over cleanly.
class DemoWatermark extends StatelessWidget {
  const DemoWatermark({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: _WatermarkPainter()),
          ),
        ),
      ],
    );
  }
}

class _WatermarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: AppConstants.watermarkText,
        style: TextStyle(
          color: Colors.black.withValues(alpha: 0.10),
          fontWeight: FontWeight.w800,
          fontSize: 14,
          letterSpacing: 0.8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    // Rotate around the center, then tile generously beyond the visible
    // bounds so corners are covered once the rotation is applied.
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.5);
    canvas.translate(-size.width / 2, -size.height / 2);

    final stepX = textPainter.width + 36;
    final stepY = textPainter.height + 36;
    for (double y = -size.height; y < size.height * 2; y += stepY) {
      for (double x = -size.width; x < size.width * 2; x += stepX) {
        textPainter.paint(canvas, Offset(x, y));
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) => false;
}
