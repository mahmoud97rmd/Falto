import 'package:flutter/material.dart';

class RSISubChart extends StatelessWidget {
  final List<double> rsiValues;

  const RSISubChart({super.key, required this.rsiValues});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 100),
      painter: _RSIPainter(rsiValues: rsiValues),
    );
  }
}

class _RSIPainter extends CustomPainter {
  final List<double> rsiValues;

  _RSIPainter({required this.rsiValues});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < rsiValues.length; i++) {
      final x1 = (i - 1) * 5.0;
      final y1 = size.height - rsiValues[i - 1];
      final x2 = i * 5.0;
      final y2 = size.height - rsiValues[i];
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
