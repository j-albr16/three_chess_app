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

import '../../models/chess_move.dart';
import '../../widgets/board_boarding_widgets.dart';
import '../../providers/game_provider.dart';
import '../../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';

class BoardBoardSubScreen extends StatelessWidget {
  final BoardState boardState;

  BoardBoardSubScreen({this.boardState});

  @override
  Widget build(BuildContext context) {
    Player leftCorner;
    Player rightCorner;

    GameProvider gameProvider =
    Provider.of<GameProvider>(context, listen: false);
    Player getPlayer(PlayerColor playerColor) {
      return gameProvider.game.player.firstWhere(
              (element) => element.playerColor == playerColor,
          orElse: null);
    }

    if (gameProvider.game != null) {
      leftCorner = getPlayer(
          PlayerColor.values[(gameProvider.player.playerColor.index + 1) % 3]);
      rightCorner = getPlayer(
          PlayerColor.values[(gameProvider.player.playerColor.index + 2) % 3]);
    }

    double unusableHeight = MediaQuery.of(context).padding.top + kToolbarHeight;


    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx)
        {
          double usableHeight = screenHeight - unusableHeight;
          ThreeChessBoard threeChessBoard = ThreeChessBoard(height: 500, width: 500, isOffline: gameProvider.game == null ? true : false, boardState: boardState,);

          return Container(
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
              );
        });
  }
}