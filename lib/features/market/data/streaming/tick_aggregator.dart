import 'dart:async';

class Tick {
  final double price;
  final DateTime time;

  Tick(this.price, this.time);
}

class Candle {
  final DateTime openTime;
  double open;
  double high;
  double low;
  double close;

  Candle({
    required this.openTime,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
}

class TickAggregator {
  final Duration timeframe;
  Candle? _currentCandle;
  final _controller = StreamController<Candle>.broadcast();

  TickAggregator(this.timeframe);

  Stream<Candle> get stream => _controller.stream;

  void addTick(Tick tick) {
    final bucket = DateTime(
      tick.time.year,
      tick.time.month,
      tick.time.day,
      tick.time.hour,
      tick.time.minute ~/ timeframe.inMinutes * timeframe.inMinutes,
    );

    if (_currentCandle == null || _currentCandle!.openTime != bucket) {
      if (_currentCandle != null) {
        _controller.add(_currentCandle!);
      }

      _currentCandle = Candle(
        openTime: bucket,
        open: tick.price,
        high: tick.price,
        low: tick.price,
        close: tick.price,
      );
    } else {
      _currentCandle!.high =
          tick.price > _currentCandle!.high ? tick.price : _currentCandle!.high;
      _currentCandle!.low =
          tick.price < _currentCandle!.low ? tick.price : _currentCandle!.low;
      _currentCandle!.close = tick.price;
    }
  }

  void dispose() {
    _controller.close();
  }
}
