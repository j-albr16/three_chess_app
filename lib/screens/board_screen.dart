import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/game.dart';

import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/widgets/three_chess_board.dart';


class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  ThreeChessBoard threeChessBoard = ThreeChessBoard();
  bool didload = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // PieceProvider pieceProvider = Provider.of<PieceProvider>(threeChessBoard.boardKey.currentContext, listen: false);
          // PlayerProvider playerProvider = Provider.of<PlayerProvider>(threeChessBoard.boardKey.currentContext, listen:false);
          // ThinkingBoard thinkingBoard = Provider.of<ThinkingBoard>(threeChessBoard.boardKey.currentContext, listen: false);
          // String selectedPiece = pieceProvider.pieces.values.firstWhere((element) => element.playerColor == playerProvider.currentPlayer).position;
          // threeChessBoard.gameProvider.game.chessMoves.add(ChessMove(initialTile: selectedPiece, nextTile: thinkingBoard.getLegalMove(selectedPiece, MapEntry(pieceProvider.pieces[selectedPiece].pieceType, pieceProvider.pieces[selectedPiece].playerColor), context).first));
          // threeChessBoard.gameProvider.notifyListeners();
          },
      ),
      appBar: AppBar(),
      body: Container(
          width: 2400,
          child: Row(
            children: [
              Padding(
                child: threeChessBoard,
                padding: EdgeInsets.only(right: 5),
              ),
            ],
          )),
    );
  }
}
