import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/network/rest/rest_client.dart';
import '../../core/network/ws/ws_manager.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';

/// MarketRepository: يحصل على بيانات السوق من REST و WS
class MarketRepository {
  final RestClient rest;
  final WsManager ws;
  final Duration timeframe;

  final _agg;
  Stream<Candle>? _candleStream;

  MarketRepository({
    required RestClient restClient,
    required WsManager wsManager,
    this.timeframe = const Duration(minutes: 1),
  })  : rest = restClient,
        ws = wsManager,
        _agg = TickAggregator(const Duration(minutes: 1));

  /// Fetch historical candles via REST
  Future<List<Candle>> fetchHistoricalCandles({
    required String symbol,
    required DateTime from,
    required DateTime to,
  }) async {
    final response = await rest.get(
      "/v3/instruments/\$symbol/candles",
      query: {
        "from": from.toIso8601String(),
        "to": to.toIso8601String(),
        "granularity": "\${timeframe.inMinutes}M",
      },
    );

    final List<Candle> result = [];
    try {
      final List<dynamic> raw = (response.body is List)
          ? (response.body as List<dynamic>)
          : [];

      for (var item in raw) {
        final t = DateTime.parse(item["time"] as String);
        final o = item["open"] as num;
        final h = item["high"] as num;
        final l = item["low"] as num;
        final c = item["close"] as num;

        result.add(
          Candle(openTime: t, open: o.toDouble(), high: h.toDouble(), low: l.toDouble(), close: c.toDouble()),
        );
      }
    } catch (_) {}

    return result;
  }

  /// Start streaming and build candle stream
  Stream<Candle> startLiveStream({required String wsUrl}) {
    ws.connect();
    _candleStream = ws.stream.map((msg) {
      final price = msg["price"] as num;
      final time = DateTime.parse(msg["time"] as String);
      final tick = Tick(price.toDouble(), time);
      _agg.addTick(tick);
      return _agg.stream;
    }).transform(
      StreamTransformer.fromHandlers(
        handleData: (stream, sink) {
          stream.listen(sink.add);
        },
      ),
    ).expand((x) => x);
    return _candleStream!;
  }

  /// Stop stream
  Future<void> stopLive() async {
    await ws.disconnect();
    _candleStream = null;
  }
}
