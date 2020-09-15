import 'dart:math';

import 'package:flutter/material.dart';

import 'board_data.dart';

class Tile {
  final List<Point> points;
  final bool isWhite;
  final String id;
  final Directions directions;


  Tile({@required this.points, @required this.isWhite, @required this.id, @required this.directions});

}