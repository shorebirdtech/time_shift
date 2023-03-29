import 'dart:math';

/// a custom randomizer, which offers convenience functions
class CustomRandomizer {
  Random rng = Random();

  /// returns a random floating point value between [low] and [high].
  double doubleInRange(double low, high) {
    assert(high > low);
    return rng.nextDouble() * (high - low) + low;
  }

  /// returns a random floating point value between 0.0 and [high].
  double doubleUpTo(double high) {
    return rng.nextDouble() * high;
  }

  /// returns a random [Point<double>] with a x value between [xLow] and [xHigh]
  /// and a y value between [yLow] and [yHigh].
  Point<double> point(double xLow, xHigh, yLow, yHigh) {
    return Point<double>(
      doubleInRange(xLow, xHigh),
      doubleInRange(yLow, yHigh),
    );
  }
}
