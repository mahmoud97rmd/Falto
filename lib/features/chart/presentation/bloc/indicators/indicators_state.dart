class IndicatorsState {
  final List<double> ema;
  final List<double> rsi;

  IndicatorsState({required this.ema, required this.rsi});

  factory IndicatorsState.initial() => IndicatorsState(ema: [], rsi: []);
}
