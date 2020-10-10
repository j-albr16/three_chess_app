import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/tile_provider.dart';
import 'package:three_chess/providers/tile_select.dart';

import '../models/tile.dart';
import '../data/board_data.dart';
import '../providers/piece_provider.dart';

class BoardPainter extends CustomPainter {
  final BuildContext context;
  Map<String, Path> paths = {};

  BoardPainter(this.context);

//Paragraph ....
//######################
  final style =
      TextStyle(color: Colors.black, fontFamily: 'Roboto', fontSize: 5);

  ui.Paragraph drawParagraph(String text) {
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
      fontSize: style.fontSize,
      fontFamily: style.fontFamily,
      textAlign: TextAlign.justify,
    );
    ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(style.getTextStyle())
      ..addText(text);

    return paragraphBuilder.build()..layout(ui.ParagraphConstraints(width: 7));
  }

//#####################
//end Paragraph

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
    if (tile.isWhite) {
      paint.color = Colors.grey;
      paint.color = Colors.brown;
    }
    Path path = Path() // TODO is obsolete since Tile(... @required Path)
      ..moveTo(tile.points[0].x.toDouble(), tile.points[0].y.toDouble())
      ..lineTo(tile.points[1].x.toDouble(), tile.points[1].y.toDouble())
      ..lineTo(tile.points[2].x.toDouble(), tile.points[2].y.toDouble())
      ..lineTo(tile.points[3].x.toDouble(), tile.points[3].y.toDouble())
      ..lineTo(tile.points[0].x.toDouble(), tile.points[0].y.toDouble())
      ..close();

    Paint borderPaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    Paint dotPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final List<Offset> points = [
      _toOff(tile.points[0]),
      _toOff(tile.points[1]),
      _toOff(tile.points[2]),
      _toOff(tile.points[3]),
      _toOff(tile.points[0]),
    ];
    paths[tile.id] = path;
    myCanvas
      ..drawPath(
        path,
        paint,
      )
      ..drawPoints(
        ui.PointMode.polygon,
        points,
        borderPaint,
      )
      ..drawParagraph(drawParagraph(tile.id), _toOff(tile.middle))
      ..drawPoints(ui.PointMode.points, [_toOff(tile.middle)], dotPaint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paths = {};
    var myCanvas = canvas;
    Provider.of<TileProvider>(context, listen: false)
        .tiles
        .forEach((key, value) {
      _drawTile(value, myCanvas, size);
    });
    Provider.of<TileProvider>(context, listen: false).paths =
        paths; // TODO Delete since obsolete, but needs clean up in other files
  }

  Offset _toOff(Point point) {
    return Offset((point.x).toDouble(), (point.y).toDouble());
  }

  Point _toPoint(Offset offset) {
    return Point(offset.dx, offset.dy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
