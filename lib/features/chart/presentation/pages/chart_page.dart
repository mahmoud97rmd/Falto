import 'package:flutter/material.dart';
import '../bloc/candles_bloc.dart';
import '../widgets/chart_core/candlestick_chart_canvas.dart';
import '../widgets/chart_core/crosshair_overlay.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Chart')),
      body: const Stack(
        children: [
          CandlestickChartCanvas(),
          CrosshairOverlay(),
        ],
      ),
    );
  }
}
