import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/providers/scroll_provider.dart';
import 'package:three_chess/widgets/move_table.dart';

import '../models/chess_move.dart';
import '../widgets/board_boarding_widgets.dart';
import '../providers/game_provider.dart';
import '../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  ThreeChessBoard threeChessBoard;
  BoardState boardState;
  bool didload = false;
  ScrollController controller;

  @override
  void initState() {
    boardState = BoardState();
    controller = ScrollController();
    // threeChessBoard = ThreeChessBoard(
    //     boardState: BoardState.newGame(), height: 1000, width: 1000);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // "A1": [
  //       Point(299.6151407894796, 832.1318750315601),

  // printChangedWhite(){
  //   print("static Map<String, List<Point>> tileWhiteData = {");
  //   for(MapEntry isWhiteTile in BoardData.tileWhiteData.entries){
  //     bool isWhite;
  //     print(' "${isWhiteTile.key}": $isWhite,');
  //   }
  // }

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

    bool isLocked = Provider.of<ScrollProvider>(context).isLockedHorizontal;
    switchIsLocked(){
      Provider.of<ScrollProvider>(context, listen: false).isLockedHorizontal = !isLocked;
    }


    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(icon: Icon(!isLocked ? Icons.lock_open : Icons.lock_clock), onPressed: () => switchIsLocked(),)],
      ),
      body:


      SingleChildScrollView(
        child: RelativeBuilder(
            builder: (context, screenHeight, screenWidth, sy, sx)
            {
              double usableHeight = screenHeight - unusableHeight;
              ThreeChessBoard threeChessBoard = ThreeChessBoard(height: 500, width: 500, isOffline: gameProvider.game == null ? true : false, boardState: boardState,);

          return Column(
                children: [

                   Container(
                    height: usableHeight,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              height: 50,
                              child: Row(
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: PlayerTile(isKnown: leftCorner != null,cutOfLength: 10, startY: (usableHeight / 2) * 0.7, isCornerLeft: true, isOnline: leftCorner?.isOnline, score: leftCorner?.user?.score, username: leftCorner?.user?.userName, borderWidth: 2,)),
                                  Expanded(child: Container(color: Colors.transparent)),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: PlayerTile(isKnown: rightCorner != null, cutOfLength: 10, startY: (usableHeight / 2) * 0.7, isCornerLeft: false, isOnline: rightCorner?.isOnline, score: rightCorner?.user?.score, username: rightCorner?.user?.userName, borderWidth: 2,)),

                                ],
                              )),
                        ),
                        Center(child: Container(
                          height: min(screenWidth, screenHeight*0.9),
                          width: min(screenWidth, screenHeight*0.9),
                          child: FittedBox(
                            child: threeChessBoard,
                          ),
                        )

                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              child: Row(
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: ActionTile(isCornerLeft: true, cutOfLength: 10, startY: (usableHeight / 2) * 0.8, onTap: () => print("I pressed left"), borderWidth: 2, icon:
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      padding: EdgeInsets.only( bottom:10),
                                        child: FittedBox(child: Icon(Icons.arrow_left, size: 1000,))),),
                                  ),
                                  Expanded(child: Container(color: Colors.transparent)),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ActionTile(isCornerLeft: false, cutOfLength: 10, startY: (usableHeight / 2) * 0.8, onTap: () => print("I pressed right"), borderWidth: 2, icon: Container(
                                        alignment: Alignment.bottomRight,
                                        padding: EdgeInsets.only(bottom:10),
                                        child: FittedBox(child: Icon(Icons.arrow_right, size: 1000,))),),
                                  )
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),

                 GameTable(
                   boardState: boardState,
                   size: Size(screenWidth *0.8, 400),
                  controller: controller,
                   confirmation: confirmation,
                   onConfirmation: (requestType) {
                     setState(() {
                       confirmation = requestType;
                     });
                   },
                   onConfirmationCancel: () => setState(() =>confirmation = null),
                   onRequest: (requestType) {
                     print("i demand a $requestType");
                     setState(() {
                       pendingActions.add(requestType);
                       confirmation = null;
                     });
                   },
                   onRequestCancel: (cancelPending) {
                     print("I demand to stop the vote!");
                     setState(() {
                       pendingActions.remove(cancelPending);
                     });

                   },
                   pendingActions: pendingActions ,
                 ),
                ],);
        }),
            ),
          );
        }
  RequestType confirmation;
  List<RequestType> pendingActions = [];
}



