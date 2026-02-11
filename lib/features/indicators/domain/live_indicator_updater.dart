import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';

class LiveIndicatorUpdater {
  CandleEntity? _current;

  void initialize(CandleEntity candle) {
    _current = candle;
  }

  void onTick(TickEntity tick) {
    if (_current == null) return;

    final mid = tick.mid;
    _current = CandleEntity(
      time: _current!.time,
      open: _current!.open,
      high: mid > _current!.high ? mid : _current!.high,
      low: mid < _current!.low ? mid : _current!.low,
      close: mid,
      volume: _current!.volume + 1,
    );
  }

  CandleEntity? get current => _current;
}
