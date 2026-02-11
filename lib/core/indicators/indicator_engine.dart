import 'dart:math';
import '../../features/market/data/streaming/tick_aggregator.dart';
import 'indicator_models.dart';

/// Core indicator calculator
class IndicatorEngine {

  /// Compute EMA on list of close prices
  static List<double> computeEMA(List<double> prices, int period) {
    if (prices.length < period) return [];

    List<double> ema = [];
    double multiplier = 2 / (period + 1);

    double prevEma = prices.take(period).reduce((a, b) => a + b) / period;
    ema.add(prevEma);

    for (int i = period; i < prices.length; i++) {
      prevEma = (prices[i] - prevEma) * multiplier + prevEma;
      ema.add(prevEma);
    }

    return ema;
  }

  /// Compute RSI on list of close prices
  static List<double> computeRSI(List<double> prices, int period) {
    if (prices.length <= period) return [];

    List<double> rsiValues = [];
    double gainSum = 0, lossSum = 0;

    for (int i = 1; i <= period; i++) {
      double diff = prices[i] - prices[i - 1];
      if (diff >= 0) gainSum += diff;
      else lossSum -= diff;
    }

    double avgGain = gainSum / period;
    double avgLoss = lossSum / period;
    double rs = avgLoss == 0 ? 0 : avgGain / avgLoss;
    rsiValues.add(100 - (100 / (1 + rs)));

    for (int i = period + 1; i < prices.length; i++) {
      double diff = prices[i] - prices[i - 1];
      avgGain = ((avgGain * (period - 1)) + (diff > 0 ? diff : 0)) / period;
      avgLoss = ((avgLoss * (period - 1)) + (diff < 0 ? -diff : 0)) / period;
      rs = avgLoss == 0 ? 0 : avgGain / avgLoss;
      rsiValues.add(100 - (100 / (1 + rs)));
    }

    return rsiValues;
  }

  /// Compute any indicator by config
  static List<double> compute(
      List<double> prices, IndicatorConfig config) {
    switch (config.type) {
      case IndicatorType.ema:
        return computeEMA(prices, config.period);
      case IndicatorType.rsi:
        return computeRSI(prices, config.period);
    }
  }
}
