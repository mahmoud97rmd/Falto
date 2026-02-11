import '../../../features/market/data/streaming/tick_aggregator.dart';

abstract class LiveChartEvent {}

class LiveChartStart extends LiveChartEvent {
  final String wsUrl;
  LiveChartStart(this.wsUrl);
}

class LiveChartCandleReceived extends LiveChartEvent {
  final Candle candle;
  LiveChartCandleReceived(this.candle);
}

class LiveChartStop extends LiveChartEvent {}
