import 'dart:math';

import 'package:flutter/material.dart';

class Tile {
  final List<Point> points;
  final bool isWhite;
  final String id;

  Tile({@required this.points, @required this.isWhite, @required this.id});

}