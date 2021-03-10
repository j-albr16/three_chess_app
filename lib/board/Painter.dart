import 'package:flutter/material.dart';

import '../models/piece.dart';
import '../models/tile.dart';
import '../models/dragged_piece.dart';


class BoardPainter extends StatelessWidget {

  final double height;
  final double width;
  final Map<String, Piece> pieces;
  final Map<String, Tile> tiles;
  final List<String> highlighted;
  final Map<String, DraggedPiece> draggedPieces;


  BoardPainter({Key key, @required this.pieces, @required  this.tiles, this.height = 1000, this.width = 1000, this.draggedPieces, this.highlighted}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      //key: boardBoxKey,
        height: height,
        width: width,
        child: Stack(fit: StackFit.expand, children: [
          //The Stack of Tiles, Highlighter and Piece
          ...tiles.values,
          //if(highlighted != null)..._buildHighlighted(highlighted),
          ...pieces.values.map((e) {
            Offset myOffset = Offset(0, 0);
            DraggedPiece currentDragged = draggedPieces == null ? null : draggedPieces[e.position];
            if (draggedPieces != null &&  currentDragged != null) {
              myOffset = currentDragged.dragOffset;
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
