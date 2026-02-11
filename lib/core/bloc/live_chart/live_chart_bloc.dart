import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../../repositories/market/market_repository.dart';
import '../../sync/sync_manager.dart';
import '../../../features/market/data/streaming/tick_aggregator.dart';
import 'live_chart_event.dart';
import 'live_chart_state.dart';

class LiveChartBloc extends Bloc<LiveChartEvent, LiveChartState> {
  final MarketRepository repository;
  final SyncManager syncManager;

  StreamSubscription? _streamSub;

  LiveChartBloc({
    required this.repository,
    required this.syncManager,
  }) : super(LiveChartInitial()) {
    on<LiveChartStart>(_onStart);
    on<LiveChartStop>(_onStop);
    on<LiveChartCandleReceived>(_onCandle);
  }

  Future<void> _onStart(
      LiveChartStart event, Emitter<LiveChartState> emit) async {
    emit(LiveChartLoading());

    try {
      await repository.stopLive();

      final stream = repository.startLiveStream(wsUrl: event.wsUrl);

      _streamSub = stream.listen((candle) {
        add(LiveChartCandleReceived(candle));
      });

      emit(LiveChartRunning([]));
    } catch (e) {
      emit(LiveChartError(e.toString()));
    }
  }

  Future<void> _onStop(
      LiveChartStop event, Emitter<LiveChartState> emit) async {
    await repository.stopLive();
    await _streamSub?.cancel();
    emit(LiveChartStopped());
  }

  void _onCandle(
      LiveChartCandleReceived event, Emitter<LiveChartState> emit) {
    if (state is LiveChartRunning) {
      final current = (state as LiveChartRunning).candles;
      final updated = List.of(current)..add(event.candle);
      emit(LiveChartRunning(updated));
    }
  }
}
