import 'dart:math';

/// The [DigitChecker] stores the information of the 10 digits and can determine if a point intersects with a given digit
class DigitChecker {
  // ten digits with 15 "pixels" each
  // we "paint" the digits by defining the 1 as filled and 0 as unfilled
  List<int> digits = [
    1, 1, 1, // 0
    1, 0, 1,
    1, 0, 1,
    1, 0, 1,
    1, 1, 1,

    0, 1, 1, // 1
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,

    1, 1, 1, // 2
    0, 0, 1,
    1, 1, 1,
    1, 0, 0,
    1, 1, 1,

    1, 1, 1, // 3
    0, 0, 1,
    0, 1, 1,
    0, 0, 1,
    1, 1, 1,

    1, 0, 1, // 4
    1, 0, 1,
    1, 1, 1,
    0, 0, 1,
    0, 0, 1,

    1, 1, 1, // 5
    1, 0, 0,
    1, 1, 1,
    0, 0, 1,
    1, 1, 1,

    1, 1, 1, // 6
    1, 0, 0,
    1, 1, 1,
    1, 0, 1,
    1, 1, 1,

    1, 1, 1, // 7
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,

    1, 1, 1, // 8
    1, 0, 1,
    1, 1, 1,
    1, 0, 1,
    1, 1, 1,

    1, 1, 1, // 9
    1, 0, 1,
    1, 1, 1,
    0, 0, 1,
    1, 1, 1
  ];

  /// is the [point] inside the [digit] stretched over the [rect]
  bool isIn(int digit, Point point, Rectangle rect) {
    if (rect.containsPoint(point)) {
      double x = point.x - rect.topLeft.x;
      double y = point.y - rect.topLeft.y;

      int column = (3 * x / rect.width).floor();
      int row = (5 * y / rect.height).floor();

      int offset = digit * 15;

      int index = offset + column + row * 3;

      if (digits[index] == 1) {
        return true;
      }
    }
    return false;
  }

  /// is the [point] outside the [digit] stretched over the [rect]
  bool isOut(int digit, Point point, Rectangle rect) {
    return !isIn(digit, point, rect);
  }
}
