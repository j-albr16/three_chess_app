import 'dart:math';

import 'package:flutter/material.dart';
import '../helpers/path_clipper.dart';

import 'enums.dart';
import '../data/board_data.dart';

class Tile extends StatelessWidget {
  final List<Point> points;
  final bool isWhite;
  final String id;
  final Directions directions;
  final PlayerColor side;
  final Path path;
  Color myColor;

  Point get middle {
    double sx = 0.0;
    double sy = 0.0;
    double sL = 0.0;
    for (int i = 0; i < points.length; i++) {
      double x0 = (i == 0 ? points.last : points[i - 1]).x.toDouble();
      double y0 = (i == 0 ? points.last : points[i - 1]).y.toDouble();
      double x1 = points[i].x.toDouble();
      double y1 = points[i].y.toDouble();
      double L = sqrt(pow((x1 - x0), 2) + pow((y1 - y0), 2)); //Math.p
      sx += ((x0 + x1) / 2) * L;
      sy += ((y0 + y1) / 2) * L;
      sL += L;
    }

    double xc = sx / sL;
    double yc = sy / sL;
    return Point(xc, yc);

    //     double x1 = points[0].x;
//     double x2 = points[2].x;
//     double y1 = points[0].y;
//     double y2 = points[2].y;
//     print("x: " +(x1 + (1/2 * (x2-x1))).toString() + "y: " + (y1 + (1/2 + (y2-y1))).toString());
//     return Point(x1 + (1/2 * (x2-x1)), y1 + (1/2 + (y2-y1)));
  }

  static Offset toOffset(Point point) {
    return Offset(point.x, point.y);
  }

  Tile(
      {@required this.points,
      @required this.isWhite,
      @required this.id,
      @required this.directions,
      @required this.side,
      @required this.path}) {
    myColor = isWhite ? Colors.grey : Colors.deepPurple;
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: myColor,
      ),
      clipper: PathClipper(path: path),
    );
  }
}
