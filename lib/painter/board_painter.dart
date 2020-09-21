import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/tile_provider.dart';
import 'package:three_chess/providers/tile_select.dart';
import 'package:poly/poly.dart';

import '../models/tile.dart';
import '../data/board_data.dart';
import '../providers/piece_provider.dart';

class BoardPainter extends CustomPainter {
  final BuildContext context;

  BoardPainter(this.context);

  //White: A-h, 1-4
  //Black: A-D,I-L, 5-8
  ///Third: E-L 9-12

  void _drawTile(Tile tile, Canvas myCanvas) {
    //<editor-fold desc="Checks for InputPoint length == 4">
    if (tile.points.length != 4) {
      print("Draw Tile got wrong number of Points!: " +
          tile.points.length.toString());
      return;
    }
    //</editor-fold>

    Paint paint = Paint();
    if(tile.isWhite){
      paint.color = Colors.white;
    }
    else{
      paint.color = Colors.black;
    }
    Path path = Path()
      ..moveTo(tile.points[0].x, tile.points[0].y)
      ..lineTo(tile.points[1].x, tile.points[1].y)
      ..lineTo(tile.points[2].x, tile.points[2].y)
      ..lineTo(tile.points[3].x, tile.points[3].y)
      ..lineTo(tile.points[0].x, tile.points[0].y)
      ..close();

    Paint borderPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final List<Offset> points = [
      _toOff(tile.points[0]),
      _toOff(tile.points[1]),
      _toOff(tile.points[2]),
      _toOff(tile.points[3]),
      _toOff(tile.points[0]),
    ];
    myCanvas
      ..drawPath(path, paint, )
      ..drawPoints(PointMode.polygon, points, borderPaint, );

  }

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = canvas;
    Provider.of<TileProvider>(context, listen: false).tiles.forEach((key, value) { _drawTile(value, myCanvas,);});
  }


  Offset _toOff(Point point) {
    return Offset(point.x, point.y);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


