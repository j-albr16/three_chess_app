import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tile_provider.dart';
import 'package:three_chess/models/game.dart';

import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/widgets/three_chess_board.dart';
import 'package:three_chess/widgets/chess_move_table.dart';

import '../providers/player_provider.dart';

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
        onPressed: () {},
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
