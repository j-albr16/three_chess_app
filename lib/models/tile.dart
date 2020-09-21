import 'dart:math';

import 'package:flutter/material.dart';

import '../data/board_data.dart';

class Tile{
  final List<Point> points;
  final bool isWhite;
  final String id;
  final Directions directions;
  Point get middle{
    double x1 = points[0].x;
    double x2 = points[2].x;
    double y1 = points[0].y;
    double y2 = points[2].y;
    return Point(x1 + (1/2 * (x2-x1)), y1 + (1/2 + (y2-y1)));
}
  static Offset toOffset(Point point, Point position, Size size){
      return Offset((point.x + position.x) * size.width / 700, (point.y + position.y) * size.height / 700);
  }

  Tile({@required this.points, @required this.isWhite, @required this.id, @required this.directions});

}