import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';

import '../models/piece.dart';
import '../models/tile.dart';


class PiecePainter extends CustomPainter {
  final List<Piece> pieces;
  final Map<String, Tile> tiles;
  final Map<PieceKey, ui.Image> images;
  final Point position;
  Size imageProvSize;


  PiecePainter({this.pieces, this.tiles, this.images, this.position, this.imageProvSize});

  @override
  void paint(Canvas canvas, Size size) {
      for (Piece piece in pieces) {

        Paint paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
          ui.Image currentImage = images[piece.pieceKey];

        if (currentImage != null) {
          if(piece.position == "L2"){
            print(tiles[piece.position].points.toString());
          }

            canvas.drawImage(currentImage, Tile.toOffset(Point(tiles[piece.position].middle.x - (imageProvSize.width / 2) ,tiles[piece.position].middle.y - (imageProvSize.height / 2))), paint);
        }
        else{
          print('Piece Painter: Couldnt Paint');
        }
      }


  }



  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}