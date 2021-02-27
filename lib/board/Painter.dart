import 'package:flutter/material.dart';

import '../models/piece.dart';
import '../models/tile.dart';


class BoardPainter extends StatelessWidget {

  final double height;
  final double width;
  final Map<String, Piece> pieces;
  final Map<String, Tile> tiles;
  final Offset pieceOffset;
  final String pieceOffsetKey;
  final List<String> highlighted;


  BoardPainter({Key key, @required this.pieces, @required  this.tiles, this.height = 1000, this.width = 1000, this.pieceOffset, this.pieceOffsetKey, this.highlighted}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //key: boardBoxKey,
        height: height,
        width: width,
        child: Stack(fit: StackFit.expand, children: [
          //The Stack of Tiles, Highlighter and Piece
          ...tiles.values,
          //if(highlighted != null)..._buildHighlighted(highlighted),
          ...pieces.values.map((e) {
            Offset myOffset = Offset(0, 0);
            if (pieceOffset != null && pieceOffsetKey == e.position) {
              myOffset = pieceOffset;
            }
            return Positioned(
              child: IgnorePointer(child: e),
              top: tiles[e.position].middle.y -
                  Piece.pieceSize.height / 2 +
                  myOffset.dy,
              left: tiles[e.position].middle.x -
                  Piece.pieceSize.width / 2 +
                  myOffset.dx,
            );
          }).toList(),
        ]),
    );
  }
}
