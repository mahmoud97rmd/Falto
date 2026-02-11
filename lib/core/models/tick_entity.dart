import 'package:equatable/equatable.dart';

class TickEntity extends Equatable {
  final String instrument;
  final DateTime time;
  final double bid;
  final double ask;

  const TickEntity({
    required this.instrument,
    required this.time,
    required this.bid,
    required this.ask,
  });

  double get mid => (bid + ask) / 2;

  @override
  List<Object?> get props => [instrument, time, bid, ask];
}
