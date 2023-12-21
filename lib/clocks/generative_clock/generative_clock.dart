// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'globals.dart';
import 'node.dart';

// An array of all the nodes which are animated
// The fluidity of the animation is highly dependent on the size of this array
// change for convenience
List<Node?> nodes = List.filled(2500, null);

/// A digital clock.
///
/// You can do better than this!
class GenerativeClock extends StatefulWidget {
  const GenerativeClock({super.key});

  @override
  State createState() => _GenerativeClockState();
}

class _GenerativeClockState extends State<GenerativeClock> {
  DateTime _dateTime = DateTime.now();
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    //setup Nodes: one half of the nodes are static and do not move, the other have does
    for (int i = 0; i < 600; i++) {
      nodes[i] = Node(true);
    }

    for (int i = 600; i < nodes.length; i++) {
      nodes[i] = Node(false);
    }

    for (int i = 0; i < quadrantDescriptors.length; i++) {
      quadrantDescriptors[i] = QuadrantDescriptor();
    }

    //we use a ticker to regularly update the state, so that the clock is redrawn
    _ticker = Ticker(_updateTime);
    _ticker.start();
  }

  ///the method invoked by the ticker, which just updates the current time
  void _updateTime(Duration d) {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    int hour = _dateTime.hour;
    if (!MediaQuery.of(context).alwaysUse24HourFormat) {
      hour %= 12;
    }
    int minute = _dateTime.minute;

    bool inside =
        Theme.of(context).brightness == Brightness.light ? true : false;

    double percentageOfMinute = _dateTime.millisecond.toDouble() / 60000.0 +
        _dateTime.second.toDouble() / 60.0;

    return Container(
      color: Colors.black,
      child: CustomPaint(
        painter: Painter(hour, minute, percentageOfMinute, inside),
        // We give the CustomPaint a child, so that it can use the child's size
        // to determine its own size.  If we don't do this, CustomPaint will
        // size itself wrong when inside a Scaffold.
        // https://github.com/flutter/flutter/issues/76230#issuecomment-781119751
        child: Container(),
      ),
    );
  }
}

/// [QuadrantDescriptor] a helper class, which we use to keep track, how many nodes are in a quadrant
/// the real information is stored in the indexs array, the QuadrantDescriptors, just describe the structural information of the array
/// [size] how many nodes are in the quadrant
/// [beginningIndex] in the
/// [filled] how many nodes of the quadrant are already found
/// in this way we define a slice of the indexs array, which only holds indexs of nodes, which belong to one quadrant
class QuadrantDescriptor {
  int size = 0;
  int beginningIndex = 0;
  int filled = 0;

  void reset() {
    size = 0;
    beginningIndex = 0;
    filled = 0;
  }
}

// Maintain a QuadrantDescriptor for every quadrant
List<QuadrantDescriptor> quadrantDescriptors = List.filled(
  quadrants(),
  QuadrantDescriptor(),
);

// aspect ratio of the screen is 5/3
double aspectRatio = 5 / 3;

/// A custom painter, which is used to animate the clockface
class Painter extends CustomPainter {
  final int _hour;
  final int _minute;
  final double _percentageOfMinute;
  final bool _drawInside;

  Painter(
    this._hour,
    this._minute,
    this._percentageOfMinute,
    this._drawInside,
  );

  /// the paint function is used in a similar way to the main loop of a game:
  /// first the state of the world (in this case mainly the position of the nodes) is simulated
  /// second the world state is drawn, i.e. each node tests if it has close neightbors and draws a line to them
  @override
  void paint(Canvas canvas, Size size) {
    /// translate the point [p] from our local coordinate system into that of the canvas
    Point<double> global(Point<double> p) {
      return Point(
        p.x * size.height + size.width / 2,
        p.y * size.height + size.height / 2,
      );
    }

    /// translates the point [p] into an equivalent offset
    Offset offset(Point<double> p) {
      return Offset(p.x, p.y);
    }

    //reset the quadrantDescriptors
    for (var quadrantDescriptor in quadrantDescriptors) {
      quadrantDescriptor.reset();
    }

    // update the positions of the node, we use the quadrant assoziations to count the amount of nodes in each quadrant
    for (var node in nodes) {
      node!.update();
      quadrantDescriptors[node.quadrant].size++;
    }

    // fill out the beginningIndexs of the quadrantDescriptors, by summing over the sizes
    int counter = 0;
    for (var quadrantDescriptor in quadrantDescriptors) {
      quadrantDescriptor.beginningIndex = counter;
      counter += quadrantDescriptor.size;
    }

    {
      // This is a list of indexes of the nodes, it is ordered by the quadrant association of the nodes,
      // i.e. first all indexes of nodes in the first quadrant appear, then of the second and so forth
      List<int> indexs = List.filled(nodes.length, 0);

      // fill out the indexs array, by iterating over nodes, and saving the node at appropriate index according to the quadrantDescriptor
      for (int i = 0; i < nodes.length; i++) {
        var node = nodes[i];
        if (node == null) {
          continue;
        }

        var listDescriptor = quadrantDescriptors[node.quadrant];
        int index = listDescriptor.beginningIndex + listDescriptor.filled;
        listDescriptor.filled++;
        indexs[index] = i;
        nodes[i]!.index = index;
      }

      //sort the nodes array, using the indexs array
      for (int i = 0; i < nodes.length; i++) {
        int index = indexs[i];

        //swap
        Node temp = nodes[i]!;
        int indexOfSwap = temp.index;

        nodes[i] = nodes[index];
        nodes[index] = temp;

        indexs[i] = i;
        indexs[indexOfSwap] = index;
      }
    }

    /// get the following, surrounding quadrants of [quadrant] are the return vakze:
    ///            quadrant, right
    ///left under, under   , right under
    List<int> surroundingQuadrants(int quadrant) {
      List<int> result = [];

      int x = quadrant % columns;

      int nQuadrants = quadrants();

      if (quadrant < nQuadrants) {
        result.add(quadrant);
      }

      if (x + 1 < columns && quadrant + 1 < nQuadrants) {
        result.add(quadrant + 1);
      }

      if (x - 1 > 0 && quadrant + columns - 1 < nQuadrants) {
        result.add(quadrant + columns - 1);
      }

      if (quadrant + columns < nQuadrants) {
        result.add(quadrant + columns);
      }

      if (x + 1 < columns && quadrant + columns + 1 < nQuadrants) {
        result.add(quadrant + columns + 1);
      }
      return result;
    }

    // ----- Draw step ----- //

    //draw half the screen black
    Paint white = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white70;

    // we compute a four sided polygon, which tints have the screen white (the other half is white)
    // it acts as a clockhand for the seconds
    Path path = Path();
    double angle = _percentageOfMinute * 2 * pi;

    double x, y;
    double tangensAngle = atan((size.width / 2) / (size.height / 2));
    if (angle < tangensAngle || angle > 2 * pi - tangensAngle) {
      x = tan(angle) * size.height / 2;
      path.moveTo(size.width / 2 + x, 0.0);
      path.lineTo(size.width, 0.0);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width / 2 - x, size.height);
    } else if (angle < pi - tangensAngle) {
      y = tan(angle - pi / 2) * size.width / 2;
      path.moveTo(size.width, size.height / 2 + y);
      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.lineTo(0.0, size.height / 2 - y);
    } else if (angle < pi + tangensAngle) {
      x = tan(angle - pi) * size.height / 2;
      path.moveTo(size.width / 2 - x, size.height);
      path.lineTo(0.0, size.height);
      path.lineTo(0.0, 0.0);
      path.lineTo(size.width / 2 + x, 0.0);
    } else if (angle < 2 * pi - tangensAngle) {
      y = tan(angle - 3 * pi / 2) * size.width / 2;
      path.moveTo(0.0, size.height / 2 - y);
      path.lineTo(0.0, 0.0);
      path.lineTo(size.width, 0.0);
      path.lineTo(size.width, size.height / 2 + y);
    }
    path.close();
    canvas.drawPath(path, white);

    // this is a function that computes if a point is in the white four sided figure drawn above or not
    bool isBelowAngle(Point p) {
      double pointAngle;
      if (p.x > 0 && p.y < 0) {
        pointAngle = atan(p.x / -p.y);
      } else if (p.x > 0 && p.y > 0) {
        pointAngle = pi / 2 + atan(p.y / p.x);
      } else if (p.x <= 0 && p.y > 0) {
        pointAngle = pi + atan(-p.x / p.y);
      } else {
        pointAngle = 3 * pi / 2 + atan(-p.y / -p.x);
      }

      if (angle > pi && (pointAngle > angle || pointAngle < angle - pi)) {
        return true;
      } else if (angle < pi && pointAngle > angle && pointAngle < angle + pi) {
        return true;
      } else {
        return false;
      }
    }

    // iterate over the nodes and check every other node if it is near
    // as is appearent, algorithmn scales quadratically with the numbers of nodes,
    // because of this we have the optimization with the quadrants
    for (var node in nodes) {
      if (node == null) {
        continue;
      }

      //do we have to draw things for this node?
      if (node.checkCoordinate(_hour, _minute, _drawInside)) {
        Point<double> point1 = node.coordinate;
        Point<double> globalPoint = global(point1);

        /* debug code: draws the nodes 
        Offset off = Offset(globalPoint.x, globalPoint.y);
        Paint paint = Paint()
          ..color = Colors.red;
        canvas.drawCircle(off, 1, paint);
        */

        var quadrantsToCheck = surroundingQuadrants(node.quadrant);

        for (var index in quadrantsToCheck) {
          QuadrantDescriptor quadrantDescriptor = quadrantDescriptors[index];
          int startingIndex =
              max(quadrantDescriptor.beginningIndex, node.index);

          //iterate over the following nodes in the surrounding quadrant, which we can get by looking at the quadrantDescriptors
          for (int i = startingIndex;
              i < quadrantDescriptor.beginningIndex + quadrantDescriptor.size;
              i++) {
            // a node in the surrounding quadrants
            Node node2 = nodes[i]!;
            Point<double> point2 = node2.coordinate;
            double distance = point1.distanceTo(point2);

            //do we have to draw things for this node
            if (node2.checkCoordinate(_hour, _minute, _drawInside)) {
              Point<double> globalPoint2 = global(point2);

              //if the distance between nodes is small enough draw a line between them
              if (distance < maxDistanceBetweenNodes) {
                // we use a more pronaunced line, for close nodes
                // in technical terms: the alpha value of the linepaint is antiproportionally defined to the distance between the nodes
                double alpha = min(0.015 / (distance + 0.0001), 1.0);

                Paint paint;
                if (isBelowAngle(point1)) {
                  paint = Paint()
                    ..color = Colors.black.withAlpha((alpha * 255).floor());
                } else {
                  paint = Paint()
                    ..color = Colors.white.withAlpha((alpha * 255).floor());
                }

                var offset1 = offset(globalPoint);
                var offset2 = offset(globalPoint2);
                canvas.drawLine(offset1, offset2, paint);
              }
            }
          }
        }
      }
    }
  }

  //always repaint, we want an animation, which is as smooth as possible
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
