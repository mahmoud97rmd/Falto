import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/bloc/live_chart/live_chart_bloc.dart';
import '../../core/bloc/live_chart/live_chart_event.dart';
import '../../core/bloc/live_chart/live_chart_state.dart';
import '../../features/chart/presentation/widgets/chart_core/candlestick_chart_canvas.dart';
import '../../core/indicators/indicator_models.dart';
import '../../core/indicators/indicator_painter.dart';
import '../../ui/widgets/indicator_selector.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';

class LiveChartPage extends StatefulWidget {
  final String wsUrl;
  LiveChartPage({required this.wsUrl});

  @override
  _LiveChartPageState createState() => _LiveChartPageState();
}

class _LiveChartPageState extends State<LiveChartPage> {
  final List<IndicatorConfig> _indicators = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Chart")),
      body: Column(
        children: [
          IndicatorSelector(
            selected: _indicators,
            onAdd: (cfg) {
              setState(() => _indicators.add(cfg));
            },
            onRemove: (type) {
              setState(() =>
                  _indicators.removeWhere((c) => c.type == type));
            },
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LiveChartBloc>().add(
                    LiveChartStart(widget.wsUrl),
                  );
            },
            child: Text("Start Live"),
          ),
          Expanded(
            child: BlocBuilder<LiveChartBloc, LiveChartState>(
              builder: (context, state) {
                if (state is LiveChartLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is LiveChartRunning) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: IndicatorPainter(
                      candles: state.candles,
                      configs: _indicators,
                    ),
                  );
                }
                if (state is LiveChartError) {
                  return Center(child: Text("Error: \${state.message}"));
                }
                return Center(child: Text("Press Start"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
