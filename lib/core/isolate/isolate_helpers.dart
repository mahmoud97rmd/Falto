import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../features/market/domain/entities/candle.dart';
import '../../features/market/domain/indicators/ema_calculator.dart';
import '../../features/market/domain/indicators/stochastic_calculator.dart';

class IndicatorParams {
  final List<Candle> candles;
  final int emaShort;
  final int emaLong;
  final int stochPeriod;
  final int stochSmoothK;
  final int stochSmoothD;

  IndicatorParams({
    required this.candles,
    required this.emaShort,
    required this.emaLong,
    required this.stochPeriod,
    required this.stochSmoothK,
    required this.stochSmoothD,
  });
}

class IndicatorResult {
  final List<double> emaShort;
  final List<double> emaLong;
  final List<double> stochK;
  final List<double> stochD;

  IndicatorResult({
    required this.emaShort,
    required this.emaLong,
    required this.stochK,
    required this.stochD,
  });
}

Future<IndicatorResult> computeIndicatorsInBackground(IndicatorParams params) async {
  return await compute(_calculateIndicators, params);
}

IndicatorResult _calculateIndicators(IndicatorParams params) {
  try {
    final emaShortResult = EMACalculator.calculate(params.candles, params.emaShort);
    final emaLongResult = EMACalculator.calculate(params.candles, params.emaLong);
    final stochResult = StochasticCalculator.calculate(
      data: params.candles,
      period: params.stochPeriod,
      smoothK: params.stochSmoothK,
      smoothD: params.stochSmoothD,
    );

    return IndicatorResult(
      emaShort: emaShortResult.values,
      emaLong: emaLongResult.values,
      stochK: stochResult.kValues,
      stochD: stochResult.dValues,
    );
  } catch (e) {
    log("Indicator isolate error: $e");
    rethrow;
  }
}
