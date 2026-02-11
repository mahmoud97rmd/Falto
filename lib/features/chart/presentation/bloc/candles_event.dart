import 'package:equatable/equatable.dart';

abstract class CandlesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCandlesEvent extends CandlesEvent {}
