import 'dart:async';
import '../network/ws/ws_manager.dart';
import '../network/rest/rest_client.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';

/// BACKTEST RESULT data class
class BacktestResult {
  final double netProfit;
  final double maxDrawdown;
  final int totalTrades;
  final List<double> equityCurve;

  BacktestResult({
    required this.netProfit,
    required this.maxDrawdown,
    required this.totalTrades,
    required this.equityCurve,
  });
}

/// BacktestEngine: يشرّع عملية الاختبار الخلفي
class BacktestEngine {
  final RestClient restClient;
  final WsManager? wsManager;
  final Duration timeframe;

  BacktestEngine({
    required this.restClient,
    this.wsManager,
    this.timeframe = const Duration(minutes: 1),
  });

  /// Perform full backtest
  Future<BacktestResult> run({
    required String symbol,
    required DateTime start,
    required DateTime end,
  }) async {
    // 1) Fetch history via REST
    final rawResponse = await restClient.get(
      "/v3/instruments/\$symbol/candles",
      query: {
        "from": start.toIso8601String(),
        "to": end.toIso8601String(),
        "granularity": "${timeframe.inMinutes}M",
      },
    );

    final List<dynamic> data = rawResponse.body.isNotEmpty
        ? (rawResponse.body as dynamic) ?? []
        : [];

    // 2) Parse history into candles
    final List<Candle> history = [];
    for (var item in data) {
      try {
        final o = item["open"] as num;
        final h = item["high"] as num;
        final l = item["low"] as num;
        final c = item["close"] as num;
        final t = DateTime.parse(item["time"] as String);
        history.add(
          Candle(openTime: t, open: o.toDouble(), high: h.toDouble(), low: l.toDouble(), close: c.toDouble()),
        );
      } catch (_) {}
    }

    if (history.isEmpty) {
      return BacktestResult(
        netProfit: 0,
        maxDrawdown: 0,
        totalTrades: 0,
        equityCurve: [],
      );
    }

    // 3) Equity Curve Simulation
    final List<double> curve = [];
    double equity = 0;
    double maxDD = 0;
    double peak = 0;
    int trades = 0;

    for (var c in history) {
      final change = (c.close - c.open);
      equity += change;
      curve.add(equity);

      if (equity > peak) peak = equity;
      final dd = peak - equity;
      if (dd > maxDD) maxDD = dd;
      trades++;
    }

    final netProfit = curve.isNotEmpty ? curve.last : 0;

    return BacktestResult(
      netProfit: netProfit,
      maxDrawdown: maxDD,
      totalTrades: trades,
      equityCurve: curve,
    );
  }
}
