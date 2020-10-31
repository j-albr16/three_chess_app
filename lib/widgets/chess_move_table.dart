import 'package:flutter/material.dart';
import 'package:three_chess/models/chess-move.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/piece.dart';
import 'package:three_chess/models/user.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

import '../models/player.dart';
import '../models/user.dart';
import '../models/game.dart';
import '../models/chess-move.dart';

class ChessMoveTable extends StatelessWidget {
  Game game;

  ChessMoveTable(this.game);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 3.0,
            spreadRadius: 0,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 700 / 4,
                child: Text(
                  'No.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              ...game.player.map(
                  (e) => Container(alignment: Alignment.center, width: 700 / 4, height: 100, child: PlayerItem(e.user.userName, true)))
            ],
          ),
          Divider(
            thickness: 3,
          ),
          Container(
            height: 450,
            child: tableContent(game),
          ),
          Divider(
            thickness: 3,
          ),
          playerInteraction()
        ],
      ),
    );
  }

  Widget PlayerItem(String playerName, bool isConnected) {
    return GestureDetector(
      child: Row(children: <Widget>[
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected ? Colors.green : Colors.red,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          playerName ?? 'is Null',
          style: TextStyle(
            fontSize: 35,
            color: Colors.white,
          ),
        ),
      ]),
    );
  }

  Widget tableContent(Game game) {
    int index = 0;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ...game.chessMoves.map((e) {
            index += 1;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                singleMove('$index'),
                singleMove(e[PlayerColor.white].initialTile),
                singleMove(e[PlayerColor.black].initialTile),
                singleMove(e[PlayerColor.red].initialTile),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget singleMove(String tile) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        width: 700 / 4,
        child: Text(
          tile,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Widget playerInteraction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
              size: 50,
            ),
            onPressed: () {}),
        IconButton(icon: Text('1/2', style: TextStyle(fontSize: 30)), onPressed: () {}),
        IconButton(icon: Icon(Icons.flag, size: 50), onPressed: () {}),
      ],
    );
  }
}
