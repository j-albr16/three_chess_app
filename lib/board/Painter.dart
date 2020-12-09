import 'package:flutter/material.dart';
import '../models/piece.dart';
import '../models/tile.dart';
import '../helpers/path_clipper.dart';


class BoardPainter extends StatelessWidget {

  final double height;
  final double width;
  final Map<String, Piece> pieces;
  final Map<String, Tile> tiles;
  final Offset pieceOffset;
  final String pieceOffsetKey;
  final List<String> highlighted;


  BoardPainter({Key key, @required this.pieces, @required  this.tiles, @required  this.height, @required  this.width, this.pieceOffset, this.pieceOffsetKey, this.highlighted}) : super(key: key);

  // List<Widget> _buildHighlighted(List<String> currHighlighted){
  //   print(currHighlighted.toString() + "PAINTER SEES THIS");
  //   List<Widget> result = [];
  //   for(String highlight in currHighlighted){
  //     result.add(
  //         ClipPath(
  //         child: Container(
  //           width: double.infinity,
  //           height: double.infinity,
  //           color: highlightColor,
  //         ),
  //         clipper: PathClipper(path: tiles[highlight].path),
  //       ));
  //   }
  //   return result;
  // }




  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //key: boardBoxKey,
        height: 1000,
        width: 1000,
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
