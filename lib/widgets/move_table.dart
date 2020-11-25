import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';

class GameTable extends StatelessWidget {
  final Game game;
  final Size size;
  final Function pickMove;
  final Function surrender;
  final Function remi;
  final Function takeBack;
  ThemeData theme;

  GameTable(
      {this.theme,
      this.game,
      this.pickMove,
      this.size,
      this.remi,
      this.surrender,
      this.takeBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: theme.backgroundColor,
        border: Border.all(
          color: theme.primaryColorLight,
        ),
      ),
      child: Column(
        children: <Widget>[
          playerBar(game.player),
          moveTable(game),
          iconBar(),
        ],
      ),
    );
  }

  Widget moveTable(Game game) {
    print(game.chessMoves.length);
    return Expanded(
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount: 3,
        children: [
          ...game.chessMoves.map((e) {
            return tableTile(e);
          }).toList()
        ],
      ),
    );
  }

  Widget tableTile(ChessMove chessMove) {
    // TODO Think about how we want to display one Move
    return GestureDetector(
      onTap: () => pickMove(chessMove),
          child: Container(
        child: FittedBox(
          child: Text(
            chessMove.nextTile,
            style: theme.primaryTextTheme.headline2,
            textAlign: TextAlign.center,
          ),
          fit: BoxFit.none,
        ),
      ),
    );
  }

  Widget iconBar() {
    // return Padding(
    //   padding: EdgeInsets.all(10),
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.primaryColorLight),
        ),
      ),
      width: size.width,
      height: size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: takeBack,
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: theme.primaryColorLight,
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: remi,
            icon: Text(
              '1/2',
              style: theme.primaryTextTheme.bodyText2,
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(5),
            onPressed: surrender,
            icon: Icon(Icons.flag, color: theme.primaryColorLight),
          ),
        ],
      ),
    );
  }

  Widget playerBar(List<Player> player) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.primaryColorLight),
        ),
      ),
      width: size.width,
      height: size.height * 0.1,
      child: Row(
        children:
            player.map((e) => playerItem(e.user.userName, e.isOnline)).toList(),
      ),
    );
  }

  Widget playerItem(String userName, bool isOnline) {
    // return Padding(
    //   padding: EdgeInsets.all(3),
    return Flexible(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            userName,
            style: theme.primaryTextTheme.subtitle2,
            textAlign: TextAlign.end,
          ),
          SizedBox(width: 6,),
          Container(
            height:15,
            width: 15,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
              color: isOnline ? Colors.green : theme.errorColor,
            ),
          ),
        ],
      ),
    );
  }
}
