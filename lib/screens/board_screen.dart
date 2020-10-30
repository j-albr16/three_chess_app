import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tile_provider.dart';
import 'package:three_chess/widgets/three_chess_board.dart';

import '../providers/player_provider.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  Widget build(BuildContext context) {
    ThreeChessBoard threeChessBoard = ThreeChessBoard();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          threeChessBoard.gameProvider.something();
        },
      ),
      appBar: AppBar(),
      body: threeChessBoard,
    );
  }
}
