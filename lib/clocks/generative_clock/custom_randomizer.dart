import 'dart:math';

/// a custom randomizer, which offers convenience functions
class CustomRandomizer {
  Random rng = Random();

  /// returns a random floating point value between [low] and [high]
  double doubleInRange(double low, high) {
    assert(high > low);
    return rng.nextDouble() * (high - low) + low;
  }

  /// returns a random floating point value between 0.0 and [high]
  double doubleUpTo(double high) {
    return rng.nextDouble() * high;
  }

  /// returns a random point<double> with a x value between [xLow] and [xHigh] and a y value between [yLow] and [yHigh]
  Point point(double xLow, xHigh, yLow, yHigh) {
    return Point(
        this.doubleInRange(xLow, xHigh), this.doubleInRange(yLow, yHigh));
  }
}
