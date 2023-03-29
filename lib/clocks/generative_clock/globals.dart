import 'package:digital_clock/custom_randomizer.dart';
import 'digit_checker.dart';

double aspectRatio = 5 / 3;

CustomRandomizer randomizer = CustomRandomizer();
DigitChecker digitChecker = DigitChecker();

double maxDistanceBetweenNodes = 0.05;
// the number of columns and rows, with which the screen is partitioned
// we do this as an optimization, the reason is explained in the paint method in digital clock
int columns = (aspectRatio / maxDistanceBetweenNodes).ceil();
int rows = (1.0 / maxDistanceBetweenNodes).ceil();

int quadrants() {
  return rows * columns;
}
