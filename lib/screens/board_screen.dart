import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/data/board_data%20copy.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';

import '../models/chess_move.dart';
import '../widgets/board_boarding_widgets.dart';
import '../providers/game_provider.dart';
import '../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';
import 'dart:math';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  ThreeChessBoard threeChessBoard;
  bool didload = false;

  @override
  void initState() {
    // threeChessBoard = ThreeChessBoard(
    //     boardState: BoardState.newGame(), height: 1000, width: 1000);
    super.initState();
  }

  // "A1": [
  //       Point(299.6151407894796, 832.1318750315601),

  printNewPoints(){
    double maxX = 0;
    double maxY =0;
    num turnOverX(num num){
      if(num > maxX) {
        maxX = num;
      }
      return num / 960.3414639624506 * 1000;
    }
    num turnOverY(num num){
      if(num > maxY){
        maxY = num;
      }
      return num / 832.7580722940685 * 866.025;
    }

    print("static Map<String, List<Point>> tileData = {");
    for(MapEntry tileData in BoardData.tileData.entries){
      print('"${tileData.key}": [');
      for(Point point in tileData.value){
        print("Point(${turnOverX(point.x)}, ${turnOverY(point.y)}), ");
      }
      print('],');
    }
    print("};");
    //print("Max x: $maxX and max y: $maxY");
  }

  @override
  Widget build(BuildContext context) {
    double unusableHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    double scaleFactor = 20;
    double borderWith = 4;

    GameProvider gameProvider =
        Provider.of<GameProvider>(context, listen: false);
    Player getPlayer(PlayerColor playerColor) {
      return gameProvider.game.player.firstWhere(
          (element) => element.playerColor == playerColor,
          orElse: null);
    }

    bool waiting = gameProvider.game == null || !gameProvider.game.didStart;
    Player leftCorner;
    Player rightCorner;

    if (gameProvider.game != null) {
      leftCorner = getPlayer(
          PlayerColor.values[(gameProvider.player.playerColor.index + 1) % 3]);
      rightCorner = getPlayer(
          PlayerColor.values[(gameProvider.player.playerColor.index + 2) % 3]);
    }



    return Scaffold(
      appBar: AppBar(),
      body:
      RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx)
    {
      double usableHeight = screenHeight - unusableHeight;
      return Container(
        height: screenHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  height: 50,
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      CornerTile(isKnown: leftCorner != null,cutOfLength: 10, startY: (usableHeight / 2) * 0.7, isCornerLeft: true, isOnline: leftCorner?.isOnline, score: leftCorner?.user?.score, username: leftCorner?.user?.userName, borderWidth: 2,),
                      Container(width: screenWidth * 0.2, color: Colors.transparent),
                      //CornerTile(isKnown: rightCorner != null, cutOfLength: 10, startY: usableHeight / 2, isCornerLeft: false, isOnline: rightCorner?.isOnline, score: rightCorner?.user?.score, username: rightCorner?.user?.userName, borderWidth: 2,),

                    ],
                  )),
            ),
            Center(child: Container(
              height: min(screenWidth, screenHeight*0.9),
              width: min(screenWidth, screenHeight*0.9),
              child: FittedBox(
                child: ThreeChessBoard(height: 500, width: 500, isOffline: gameProvider.game == null ? true : false, boardState: BoardState.newGame(),),
              ),
            )

            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(color: Colors.grey,
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,
                    children: [

                    ],
                  )),
            ),
          ],
        ),
      );

    }),
    );
  }
}

class PlayerInfo extends StatelessWidget {
  final bool isLeft;
  final Player player;
  final double height;
  final double width;

  PlayerInfo({this.isLeft, this.player, this.height, this.width});

  Widget onlineIcon(bool isOnline) {
    return Icon(
      isOnline ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return
    Container(

      color: Colors.grey,
      height: height,
      width: width,

      child: FittedBox(

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              onlineIcon(player?.isOnline ?? false),
              Align(
                  alignment: Alignment.center,
                  child: player != null ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                Text(player.user.userName),
                Text(player.user.score.toString())
              ],) :
              Text("?")),
              if(player != null) Align(
                  alignment: Alignment.centerRight,
                  child: Text(player.remainingTime.toString())),
            ],
          ),
        ),
      );
  }
}

class CornerAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




