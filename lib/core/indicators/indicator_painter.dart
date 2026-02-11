import 'package:flutter/material.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';
import 'indicator_models.dart';
import 'indicator_engine.dart';
import 'dart:math';

class IndicatorPainter extends CustomPainter {
  final List<Candle> candles;
  final List<IndicatorConfig> configs;

  IndicatorPainter({required this.candles, required this.configs});

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty || configs.isEmpty) return;

    final closes = candles.map((c) => c.close).toList();

    final maxPrice = candles.map((c) => c.high).reduce(max);
    final minPrice = candles.map((c) => c.low).reduce(min);
    final priceRange = maxPrice - minPrice;

    final barWidth = size.width / candles.length;

    for (var config in configs) {
      final values = IndicatorEngine.compute(closes, config);
      if (values.isEmpty) continue;

      final path = Path();
      final paint = Paint()
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke
        ..color = config.type == IndicatorType.ema
            ? Colors.blue
            : Colors.orange;

      for (int i = 0; i < values.length; i++) {
        final x = i * barWidth;
        final y = size.height -
            ((values[i] - minPrice) / priceRange) * size.height;
        if (i == 0)
          path.moveTo(x, y);
        else
          path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant IndicatorPainter old) =>
      old.candles != candles || old.configs != configs;
}
