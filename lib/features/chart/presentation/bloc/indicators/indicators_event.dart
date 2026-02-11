abstract class IndicatorsEvent {}

class LoadIndicators extends IndicatorsEvent {
  final List<double> prices;

  LoadIndicators(this.prices);
}
