class Candle {
  final double open, high, low, close;
  const Candle({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });
  bool get isBullish => close >= open;
}
