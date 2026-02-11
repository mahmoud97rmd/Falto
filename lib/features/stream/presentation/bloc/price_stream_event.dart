part of 'price_stream_bloc.dart';

abstract class PriceStreamEvent extends Equatable {
  const PriceStreamEvent();
  @override
  List<Object?> get props => [];
}

class StartPriceStream extends PriceStreamEvent {}
class StopPriceStream extends PriceStreamEvent {}
class NewPriceReceived extends PriceStreamEvent {
  final double price;
  const NewPriceReceived(this.price);

  @override
  List<Object?> get props => [price];
}
