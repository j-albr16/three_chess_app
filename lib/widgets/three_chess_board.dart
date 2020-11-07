import 'package:flutter/material.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/board/Painter.dart';
import 'package:three_chess/board/PieceMover.dart';
import 'package:three_chess/board/ThinkingBoard.dart';
import 'package:three_chess/board/TileSelect.dart';
import 'package:three_chess/board/Tiles.dart';
import 'package:three_chess/board/timeCounter.dart';



class ThreeChessBoard extends StatefulWidget {
  @override
  _ThreeChessBoardState createState() => _ThreeChessBoardState();

}

class _ThreeChessBoardState extends State<ThreeChessBoard> {
  BoardState boardState;
  List<String> highlighted;


  @override
  Widget build(BuildContext context) {
    return Listener(
        child: BoardPainter(pieces: null, tiles: null, height: null, width: null),
    );
  }
}
