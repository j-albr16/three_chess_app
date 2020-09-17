import 'dart:math';

import 'package:flutter/material.dart';

import 'board_data.dart';

class Tile {
  final List<Point> points;
  final bool isWhite;
  final String id;
  final Directions directions;
  Point get middle{
    double x1 = points[0].x;
    double x2 = points[2].x;
    double y1 = points[0].y;
    double y2 = points[2].y;
    return Point(x1 + 1/2 * (x1-x2).abs(), y1 + 1/2 + (y1-y2).abs());
}

  Tile({@required this.points, @required this.isWhite, @required this.id, @required this.directions});

}