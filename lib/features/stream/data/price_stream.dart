import 'dart:async';

class PriceStream {
  Stream<double> getPrices() {
    return Stream.periodic(
      Duration(seconds: 1),
      (count) => 1000 + count + (count % 5) * 0.3,
    );
  }
}
