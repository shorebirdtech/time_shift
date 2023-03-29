import 'dart:math';
import 'globals.dart';

/// [Node] represents one of the moving elements in the net
/// [coordinate] of the node
/// the coordinate system we use has its origin in the middle of the screen for convinience
/// the maximal y range is -0.5 to 0.5
/// the maximal x range is -0.5 * aspectRatio to 0.5 * aspectRatio
/// [velocity]: how does the node move every timestep
class Node {
  late Point coordinate;
  Point velocity = randomizer.point(-0.5, 0.5, -0.5, 0.5);
  int quadrant = 0;
  int index = 0;
  bool isStatic;

  /// returns a node with randomized values
  /// if [isStatic] is true, then the node does not move and its coordinate is more more likely to be arround the (0,0)
  Node(this.isStatic) {
    if (!isStatic) {
      coordinate =
          randomizer.point(-aspectRatio / 2, aspectRatio / 2, -0.5, 0.5);
      // velocity = randomizer.doubleInRange(0.2, 1.0);
      velocity = randomizer.point(-0.5, 0.5, -0.5, 0.5);
    } else {
      Point randomPoint = randomizer.point(-aspectRatio / 2 + 1.5 / 12.0,
          aspectRatio / 2 - 1.5 / 12.0, -0.5 + 3.0 / 12.0, 0.5 - 3.0 / 12.0);
      coordinate = randomPoint;
      //velocity = 0.0;
      velocity = const Point(0, 0);
    }
  }

  // update the position of the node and compute in which quadrant it is located
  void update() {
    if (!isStatic) {
      //update position
      coordinate += velocity * 0.004;

      double maxX = aspectRatio / 2, maxY = 0.5;

      // if the point has reached a wall, then we move it to the opposite wall
      // i think this is called a periodic boundary condition
      if (coordinate.x > maxX || coordinate.x < -maxX) {
        coordinate = Point(-coordinate.x, coordinate.y);
      }
      if (coordinate.y > maxY || coordinate.y < -maxY) {
        coordinate = Point(coordinate.x, -coordinate.y);
      }

      //compute quadrant of node
      int xQuadrant =
          (columns * (coordinate.x + aspectRatio / 2) / aspectRatio).floor();
      int yQuadrant = (rows * (coordinate.y + 0.5)).floor();
      quadrant = max(0, min(columns * yQuadrant + xQuadrant, quadrants() - 1));
    }
  }

  /// gives back the result of the right Outside/Inside check, according to the [checkInside] flag
  bool checkCoordinate(int hour, minute, bool checkInside) {
    if (checkInside) {
      return _isInsideOfNumbers(hour, minute);
    } else {
      return _isOutsideOfNumbers(hour, minute);
    }
  }

  /// check if the coordinate of the node is in one of the four digits, which represent [hour] and [minute]
  bool _isOutsideOfNumbers(int hour, minute) {
    int digit1 = hour ~/ 10;
    int digit2 = hour % 10;

    int digit3 = minute ~/ 10;
    int digit4 = minute % 10;

    double width = 3 * aspectRatio / 20;
    double height = 5 * width / 3;
    double distance = width / 3;

    Rectangle rect1 =
        Rectangle(-2 * (width + distance), -height / 2, width, height);
    Rectangle rect2 =
        Rectangle(-1 * (width + distance), -height / 2, width, height);
    Rectangle rect3 = Rectangle(distance, -height / 2, width, height);
    Rectangle rect4 =
        Rectangle(2 * distance + width, -height / 2, width, height);

    return digitChecker.isOut(digit1, coordinate, rect1) &&
        digitChecker.isOut(digit2, coordinate, rect2) &&
        digitChecker.isOut(digit3, coordinate, rect3) &&
        digitChecker.isOut(digit4, coordinate, rect4);
  }

  // the inverse of the function above
  bool _isInsideOfNumbers(int hour, minute) {
    return !_isOutsideOfNumbers(hour, minute);
  }
}
