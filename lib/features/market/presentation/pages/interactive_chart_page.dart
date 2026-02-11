import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chart/chart_bloc.dart';
import '../bloc/chart/chart_event.dart';
import '../bloc/chart/chart_state.dart';

class InteractiveChartPage extends StatelessWidget {
  final String symbol;

  const InteractiveChartPage({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartBloc()..add(LoadChartHistory(symbol: symbol, timeframe: "M1")),
      child: _InteractiveChartView(symbol: symbol),
    );
  }
}

class _InteractiveChartView extends StatefulWidget {
  final String symbol;
  const _InteractiveChartView({required this.symbol});

  @override
  _InteractiveChartViewState createState() => _InteractiveChartViewState();
}

class _InteractiveChartViewState extends State<_InteractiveChartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chart — ${widget.symbol}")),
      body: BlocBuilder<ChartBloc, ChartState>(
        builder: (context, state) {
          if (state is ChartLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ChartLoaded) {
            return Center(
              child: Text('${state.candles.length} candles loaded'),
            );
          }
          if (state is ChartError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Container();
        },
      ),
    );
  }
}
