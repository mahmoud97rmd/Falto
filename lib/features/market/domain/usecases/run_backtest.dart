import 'package:flutter_trading_app/features/market/domain/backtest/backtest_result.dart' as result;
import 'package:flutter_trading_app/features/market/domain/backtest/backtest_engine.dart';
import 'package:flutter_trading_app/features/market/domain/repositories/market_repository.dart';

class RunBacktest {
  final MarketRepository marketRepository;

  RunBacktest(this.marketRepository);

  Future<result.BacktestResult> execute() async {
    final engine = BacktestEngine();
    return await engine.execute();
  }
}
