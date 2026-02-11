import '../../../features/market/data/streaming/tick_aggregator.dart';

abstract class LiveChartState {}

class LiveChartInitial extends LiveChartState {}

class LiveChartLoading extends LiveChartState {}

class LiveChartRunning extends LiveChartState {
  final List<Candle> candles;
  LiveChartRunning(this.candles);
}

class LiveChartStopped extends LiveChartState {}

class LiveChartError extends LiveChartState {
  final String message;
  LiveChartError(this.message);
}
