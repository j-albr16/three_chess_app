import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';

class GameTable extends StatelessWidget {
 final Game game;
 final Size size;

GameTable({this.game, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  size.width,
      height: size.height,
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
          moveTable(game),
          iconBar(),
        ],
      ),
    );
  }

  Widget moveTable(Game game) {
    print(game.chessMoves.length);
    return 
      Expanded(
              child: GridView.count(
          padding: EdgeInsets.all(5),
          crossAxisCount: 3,
          children: [...game.chessMoves.map((e) {
            return tableTile(e);
          }).toList() ],
    ),
      );
  }

  Widget tableTile(ChessMove chessMove) {
    // return Padding(
    //   padding: EdgeInsets.all(2),
    return Container(
      // width: 100,
      // height: 100,
      child: FittedBox(
        // fit: BoxFit.contain,
        child: Center(
                  child: Text(
            chessMove.nextTile,
            style: TextStyle(
              color: Colors.white,
              fontSize: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget iconBar() {
    // return Padding(
    //   padding: EdgeInsets.all(10),
         return Container(
           decoration: BoxDecoration(
             border: Border(top: BorderSide(color: Colors.white),
           ),),
      width: size.width,
      height: size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
    // return Padding(
    //   padding: EdgeInsets.all(10),
         return Container(
       decoration: BoxDecoration(
         border: Border(
           bottom: BorderSide(color: Colors.white),
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
}

Widget playerItem(String userName, bool isOnline) {
  // return Padding(
  //   padding: EdgeInsets.all(3),
       return Flexible(
         flex: 1,
    child: Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isOnline ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
      ],
    ),
  );
}
