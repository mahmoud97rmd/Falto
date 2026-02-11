import 'package:flutter_bloc/flutter_bloc.dart';
import 'candles_event.dart';
import 'candles_state.dart';

class CandlesBloc extends Bloc<CandlesEvent, CandlesState> {
  CandlesBloc() : super(CandlesInitial()) {
    on<LoadCandlesEvent>((event, emit) async {
      emit(CandlesLoading());
      await Future.delayed(Duration(seconds: 1));
      emit(CandlesLoaded(candles: []));
    });
  }
}
