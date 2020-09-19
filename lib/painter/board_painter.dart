import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/tile_provider.dart';
import 'package:touchable/touchable.dart';

import '../models/tile.dart';
import '../data/board_data.dart';
import '../providers/piece_provider.dart';

class BoardPainter extends CustomPainter {
  final BuildContext context;

  BoardPainter(this.context);

  //White: A-h, 1-4
  //Black: A-D,I-L, 5-8
  ///Third: E-L 9-12

  void _drawTile(Tile tile, TouchyCanvas myCanvas) {
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
      ..drawPath(path, paint)
      ..drawPoints(PointMode.polygon, points, borderPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var myCanvas = TouchyCanvas(context, canvas);
    Provider.of<TileProvider>(context, listen: false).tiles.forEach((key, value) { _drawTile(value, myCanvas);});
  }



  Offset _toOff(Point point) {
    return Offset(point.x, point.y);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/*
void reset(){
       _whiteBoolCount = 0;
      _lastisWhite = false;
    }
    bool _nextBool(){
    if(_whiteBoolCount >= 8){
      _whiteBoolCount = 1;
      if(_lastisWhite){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      _whiteBoolCount ++;
      if(_lastisWhite){
        _lastisWhite = false;
        return false;
      }
      else{
        _lastisWhite = true;
        return true;
      }
    }
    }

    for (int i = 0; i < 3; i++) {
      Map<String,List<Point>> currentBoardThird = {};
      List<String> idStringThird = BoardData.CoordinateStrings[i];
      for(int j = 0; j < idStringThird.length; j++){
        currentBoardThird[idStringThird[j]] = pointsThird[j];
      }
      print(i.toString());

      currentBoardThird.forEach((key, value) {
        _drawTile(
          Tile(points: [
            value[0],
            value[1],
            value[2],
            value[3],
          ], id: key, isWhite: _nextBool()),
            myCanvas,
           );
      });
      //rotate
      List<List<Point>> pointsThird2 = BoardData.tilePointsThird;
      List<List<Point>> newPoints = new List();
      for(int k = 0; k < pointsThird2.length; k++){
        newPoints.add(List());
        for(int h = 0; h < pointsThird2[k].length; h++){
          newPoints[k].add(_rotatePoint( pointsThird2[k][h], Point(415.1, 358.8), i) );
        }
      }
      pointsThird = newPoints;
       reset();
    }
 */
