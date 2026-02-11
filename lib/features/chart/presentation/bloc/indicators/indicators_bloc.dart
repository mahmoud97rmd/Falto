import 'package:flutter_bloc/flutter_bloc.dart';
import 'indicators_event.dart';
import 'indicators_state.dart';
import 'package:flato/features/chart/domain/indicators/ema_indicator.dart';
import 'package:flato/features/chart/domain/indicators/rsi_indicator.dart';

class IndicatorsBloc extends Bloc<IndicatorsEvent, IndicatorsState> {
  IndicatorsBloc() : super(IndicatorsState.initial()) {
    on<LoadIndicators>((event, emit) {
      final ema = EMAIndicator.calculate(event.prices, period: 14);
      final rsi = RSIIndicator.calculate(event.prices, period: 14);
      emit(IndicatorsState(ema: ema, rsi: rsi));
    });
  }
}
