abstract class BacktestEvent {}

class BacktestStart extends BacktestEvent {
  final String symbol;
  final DateTime start;
  final DateTime end;

  BacktestStart({
    required this.symbol,
    required this.start,
    required this.end,
  });
}
