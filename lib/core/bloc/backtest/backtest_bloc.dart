import 'package:bloc/bloc.dart';
import '../../backtest/backtest_engine.dart';
import 'backtest_event.dart';
import 'backtest_state.dart';

class BacktestBloc extends Bloc<BacktestEvent, BacktestState> {
  final BacktestEngine engine;

  BacktestBloc({required this.engine}) : super(BacktestInitial()) {
    on<BacktestStart>(_onStart);
  }

  Future<void> _onStart(
      BacktestStart event, Emitter<BacktestState> emit) async {
    emit(BacktestRunning());

    try {
      final result = await engine.run(
        symbol: event.symbol,
        start: event.start,
        end: event.end,
      );

      emit(BacktestSuccess(result));
    } catch (e) {
      emit(BacktestError(e.toString()));
    }
  }
}
