import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BacktestEvent {}
class RunBacktestEvent extends BacktestEvent {}

abstract class BacktestState {}
class BacktestInitial extends BacktestState {}
class BacktestRunning extends BacktestState {}
class BacktestComplete extends BacktestState {}

class BacktestBloc extends Bloc<BacktestEvent, BacktestState> {
  BacktestBloc() : super(BacktestInitial()) {
    on<RunBacktestEvent>((event, emit) async {
      emit(BacktestRunning());
      await Future.delayed(Duration(seconds: 2));
      emit(BacktestComplete());
    });
  }
}
