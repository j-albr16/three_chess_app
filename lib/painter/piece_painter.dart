

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/image_provider.dart';

import '../models/piece.dart';
import '../data/board_data.dart';
import '../providers/tile_provider.dart';
import '../models/tile.dart';


class PiecePainter extends CustomPainter {
  final List<Piece> pieces;
  final Map<String, Tile> tiles;
  final Map<PieceType, Map<PlayerColor, ui.Image>> images;

  PiecePainter({this.pieces, this.tiles, this.images});

  @override
  void paint(Canvas canvas, Size size) {

      for (Piece piece in pieces) {
        Paint paint = Paint()
          ..color = Colors.brown;


          ui.Image currentImage = images[piece.pieceType][piece.player];
        if (currentImage != null) {
            canvas.drawImage(currentImage, Tile.toOffset(tiles[piece.position].middle), new Paint());
        }
        else{
          print('Piece Painter: Couldnt Paint');
        }
      }

  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }

}