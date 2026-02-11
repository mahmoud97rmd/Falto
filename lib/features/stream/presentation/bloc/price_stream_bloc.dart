import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/price_stream.dart';

part 'price_stream_event.dart';
part 'price_stream_state.dart';

class PriceStreamBloc extends Bloc<PriceStreamEvent, PriceStreamState> {
  final PriceStream streamService;

  StreamSubscription<double>? _subscription;

  PriceStreamBloc({required this.streamService}) : super(PriceStreamInitial()) {
    on<StartPriceStream>((event, emit) {
      emit(PriceStreamLoading());
      _subscription = streamService.getPrices().listen(
        (price) => add(NewPriceReceived(price)),
      );
    });

    on<NewPriceReceived>((event, emit) {
      emit(PriceStreamUpdated(price: event.price));
    });

    on<StopPriceStream>((event, emit) {
      _subscription?.cancel();
      emit(PriceStreamStopped());
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
