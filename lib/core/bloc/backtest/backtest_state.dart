import '../../backtest/backtest_engine.dart';

abstract class BacktestState {}

class BacktestInitial extends BacktestState {}

class BacktestRunning extends BacktestState {}

class BacktestSuccess extends BacktestState {
  final BacktestResult result;
  BacktestSuccess(this.result);
}

class BacktestError extends BacktestState {
  final String message;
  BacktestError(this.message);
}
