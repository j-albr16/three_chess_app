import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';

class GameTable extends StatelessWidget {
  Game game;

GameTable(this.game);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.black38,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Column(
        children: <Widget>[
          playerBar(game.player),
          Divider(color: Colors.white,),
          moveTable(game),
          Divider(color: Colors.white),
          iconBar(),
        ],
      ),
    );
  }

  Widget moveTable(Game game) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount: 3,
        children: game.chessMoves.map((e) => tableTile(e)).toList(),
      ),
    );
  }

  Widget tableTile(ChessMove chessMove) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          chessMove.nextTile,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget iconBar() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: () {},
            icon: Text(
              '1/2',
              style: TextStyle(color: Colors.white),
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: () {},
            icon: Icon(Icons.flag, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget playerBar(List<Player> player) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children:
            player.map((e) => playerItem(e.user.userName, e.isConnected)).toList(),
      ),
    );
  }
}

Widget playerItem(String userName, bool isConnected) {
  return Padding(
    padding: EdgeInsets.all(3),
    child: Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),
  );
}
