import 'dart:math' as math;

import 'package:flutter/material.dart';

class BackgroundPatternPainter extends CustomPainter {
  final double rotation;
  final BuildContext context;

  BackgroundPatternPainter({required this.rotation, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final theme = Theme.of(context);
    final paint = Paint()
      ..color = theme.colorScheme.onSurface.withValues(alpha: 0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw rotated squares
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);

    // Draw multiple squares with different sizes
    for (var i = 0; i < 8; i++) {
      final size = 100.0 + (i * 50.0);
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: size,
        height: size,
      );
      canvas.drawRect(rect, paint);
    }

    // Draw crossing lines
    for (var i = 0; i < 12; i++) {
      final angle = (i * math.pi / 6);
      canvas.save();
      canvas.rotate(angle);
      canvas.drawLine(
        Offset(-size.width, 0),
        Offset(size.width, 0),
        paint..strokeWidth = 1,
      );
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(BackgroundPatternPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
