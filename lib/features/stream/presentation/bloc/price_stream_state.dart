part of 'price_stream_bloc.dart';

abstract class PriceStreamState extends Equatable {
  const PriceStreamState();
  @override
  List<Object?> get props => [];
}

class PriceStreamInitial extends PriceStreamState {}
class PriceStreamLoading extends PriceStreamState {}
class PriceStreamUpdated extends PriceStreamState {
  final double price;
  const PriceStreamUpdated({required this.price});
  @override
  List<Object?> get props => [price];
}
class PriceStreamStopped extends PriceStreamState {}
