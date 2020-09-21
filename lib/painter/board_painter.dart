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
  final Point pos;

  BoardPainter(this.context, this.pos);

  //White: A-h, 1-4
  //Black: A-D,I-L, 5-8
  ///Third: E-L 9-12

  void _drawTile(Tile tile, Canvas myCanvas, Size size) {
    //<editor-fold desc="Checks for InputPoint length == 4">
    if (tile.points.length != 4) {
      print("Draw Tile got wrong number of Points!: " +
          tile.points.length.toString());
      return;
    }
    //</editor-fold>

    Paint paint = Paint();
    if(tile.isWhite){
      paint.color = Colors.grey;
    }
    else{
      paint.color = Colors.brown;
    }
    Path path = Path()
      ..moveTo((tile.points[0].x + pos.x) * size.width / 700, (tile.points[0].y + pos.y) * size.height / 700)
      ..lineTo((tile.points[1].x + pos.x) * size.width / 700, (tile.points[1].y + pos.y) * size.height / 700)
      ..lineTo((tile.points[2].x + pos.x) * size.width / 700, (tile.points[2].y + pos.y) * size.height / 700)
      ..lineTo((tile.points[3].x + pos.x) * size.width / 700, (tile.points[3].y + pos.y) * size.height / 700)
      ..lineTo((tile.points[0].x + pos.x) * size.width / 700, (tile.points[0].y + pos.y) * size.height / 700)
      ..close();

    Paint borderPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final List<Offset> points = [
      _toOff(tile.points[0], size),
      _toOff(tile.points[1], size),
      _toOff(tile.points[2], size),
      _toOff(tile.points[3], size),
      _toOff(tile.points[0], size),
    ];
    myCanvas
      ..drawPath(path, paint, )
      ..drawPoints(PointMode.polygon, points, borderPaint, );

  }

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = canvas;
    Provider.of<TileProvider>(context, listen: false).tiles.forEach((key, value) { _drawTile(value, myCanvas, size);});
  }


  Offset _toOff(Point point, Size size) {
    return Offset((point.x  + pos.x) * size.width  / 700, (point.y  + pos.y) * size.height  / 700);
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}


