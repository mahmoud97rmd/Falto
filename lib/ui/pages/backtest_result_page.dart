import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/backtest/backtest_bloc.dart';
import '../../core/bloc/backtest/backtest_event.dart';
import '../../core/bloc/backtest/backtest_state.dart';
import '../../core/backtest/backtest_engine.dart';

class BacktestResultPage extends StatelessWidget {
  final String symbol;
  final DateTime start;
  final DateTime end;

  BacktestResultPage({
    required this.symbol,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Backtest")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              context.read<BacktestBloc>().add(
                    BacktestStart(
                      symbol: symbol,
                      start: start,
                      end: end,
                    ),
                  );
            },
            child: Text("Run Backtest"),
          ),
          BlocBuilder<BacktestBloc, BacktestState>(
            builder: (context, state) {
              if (state is BacktestRunning) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is BacktestSuccess) {
                final r = state.result;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Net Profit: \${r.netProfit}"),
                    Text("Max Drawdown: \${r.maxDrawdown}"),
                    Text("Trades: \${r.totalTrades}"),
                    SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: r.equityCurve.length,
                        itemBuilder: (ctx, i) =>
                            Text("Point \$i: \${r.equityCurve[i]}"),
                      ),
                    ),
                  ],
                );
              }
              if (state is BacktestError) {
                return Text("Error: \${state.message}");
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }
}
