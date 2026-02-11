import '../../features/market/data/streaming/tick_aggregator.dart';

/// Indicator types enum
enum IndicatorType {
  ema,
  rsi,
}

/// Indicator configuration
class IndicatorConfig {
  final IndicatorType type;
  final int period;

  IndicatorConfig({required this.type, required this.period});
}
