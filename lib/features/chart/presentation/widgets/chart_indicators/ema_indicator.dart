import 'package:flutter/material.dart';
import 'package:flato/features/chart/domain/indicators/ema_indicator.dart';

class EMAIndicatorPainter extends CustomPainter {
  final List<double> emaValues;
  final double candleWidth;

  EMAIndicatorPainter({required this.emaValues, required this.candleWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < emaValues.length; i++) {
      final x1 = (i - 1) * candleWidth;
      final y1 = size.height - emaValues[i - 1];
      final x2 = i * candleWidth;
      final y2 = size.height - emaValues[i];
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
