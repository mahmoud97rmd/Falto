import 'package:equatable/equatable.dart';

abstract class CandlesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CandlesInitial extends CandlesState {}
class CandlesLoading extends CandlesState {}
class CandlesLoaded extends CandlesState {
  final List<dynamic> candles;
  CandlesLoaded({required this.candles});

  @override
  List<Object?> get props => [candles];
}
