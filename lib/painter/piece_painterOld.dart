import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/piece.dart';
import '../data/board_data.dart';
import '../providers/tile_provider.dart';
import '../models/tile.dart';


class PiecePainter extends CustomPainter {
  final Piece piece;
  final Map<String, Tile> tiles;

  PiecePainter({this.piece, this.tiles});

  getMiddleOffset() {
    List<Point> tileCoord = tiles[piece.position].points;
    double x1 = tileCoord[0].x;
    double x2 = tileCoord[2].x;
    double y1 = tileCoord[0].y;
    double y2 = tileCoord[2].y;
    double newX = x1 + 0.5 * (x1 - x2);
    double newY = y1 + 0.5 + (y1 - y2);
    return Offset(newX, newY);
  }
  Future<ui.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      return completer.complete(img);
    });

  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.brown;
    loadUiImage(null).then((value) => {
        canvas.drawImage(value, getMiddleOffset(), paint)
    });


    // TODO: implement paint
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}