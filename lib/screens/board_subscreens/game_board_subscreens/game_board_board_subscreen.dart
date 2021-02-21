import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/board/client_game.dart';
import 'package:three_chess/providers/ClientGameProvider.dart';

import '../../../board/BoardState.dart';
import '../../../board/Tiles.dart';
import '../../../models/enums.dart';
import '../../../models/player.dart';
import '../../../widgets/board_boarding_widgets.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/three_chess_board.dart';

class BoardBoardSubScreen extends StatefulWidget {
  final double bottomSpace;

  BoardBoardSubScreen({this.bottomSpace});

  @override
  _BoardBoardSubScreenState createState() => _BoardBoardSubScreenState();
}

class _BoardBoardSubScreenState extends State<BoardBoardSubScreen> {
  ThreeChessBoard threeChessBoard;

  @override
  void initState() {
    super.initState();
  }

  _moveLeft(context) {
    ClientGameProvider clientGameProvider =
        Provider.of<ClientGameProvider>(context, listen: false);
    clientGameProvider
        .clientGame.selectedMove = clientGameProvider.clientGame.selectedMove--;
  }

  _moveRight(context) {
    ClientGameProvider clientGameProvider =
    Provider.of<ClientGameProvider>(context, listen: false);
    clientGameProvider
        .clientGame.selectedMove = clientGameProvider.clientGame.selectedMove++;
  }

  @override
  Widget build(BuildContext context) {
    ClientGame clientGame = Provider.of<ClientGameProvider>(context).clientGame;
    Player leftCorner;
    Player rightCorner;

    threeChessBoard = ThreeChessBoard(
      height: 500,
      width: 500,
    );

    Player getPlayer(PlayerColor playerColor) {
      return clientGame?.game?.player?.firstWhere(
          (element) => element.playerColor == playerColor,
          orElse: null);
    }

    if (clientGame.game != null) {
      leftCorner = getPlayer(
          PlayerColor.values[(clientGame.clientPlayer.index + 1) % 3]);
      rightCorner = getPlayer(
          PlayerColor.values[(clientGame.clientPlayer.index + 2) % 3]);
    }

    double unusableHeight = MediaQuery.of(context).padding.top + kToolbarHeight;

    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      double usableHeight = screenHeight - unusableHeight-widget.bottomSpace;

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
                          child: PlayerTile(
                            isKnown: leftCorner != null,
                            cutOfLength: 10,
                            startY: (usableHeight / 2) * 0.7,
                            isCornerLeft: true,
                            isOnline: leftCorner?.isOnline ?? false,
                            score: leftCorner?.user?.score,
                            username: leftCorner?.user?.userName,
                            borderWidth: 2,
                          )),
                      Expanded(child: Container(color: Colors.transparent)),
                      Align(
                          alignment: Alignment.topRight,
                          child: PlayerTile(
                            isKnown: rightCorner != null,
                            cutOfLength: 10,
                            startY: (usableHeight / 2) * 0.7,
                            isCornerLeft: false,
                            isOnline: rightCorner?.isOnline ?? false,
                            score: rightCorner?.user?.score,
                            username: rightCorner?.user?.userName,
                            borderWidth: 2,
                          )),
                    ],
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  child: Row(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ActionTile(
                      isCornerLeft: true,
                      cutOfLength: 10,
                      startY: (usableHeight / 2) * 0.8,
                      onTap: () => _moveLeft(context),
                      borderWidth: 2,
                      icon: Container(
                          alignment: Alignment.bottomLeft,
                          padding: EdgeInsets.only(bottom: 10),
                          child: FittedBox(
                              child: Icon(
                            Icons.arrow_left,
                            size: 1000,
                          ))),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    color: Colors.transparent,
                  )),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ActionTile(
                      isCornerLeft: false,
                      cutOfLength: 10,
                      startY: (usableHeight / 2) * 0.8,
                      onTap: () => _moveRight(context),
                      borderWidth: 2,
                      icon: Container(
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.only(bottom: 10),
                          child: FittedBox(
                              child: Icon(
                            Icons.arrow_right,
                            size: 1000,
                          ))),
                    ),
                  )
                ],
              )),
            ),
            Center(
                child: Container(
              height: min(screenWidth, screenHeight * 0.9),
              width: min(screenWidth, screenHeight * 0.9),
              child: FittedBox(
                child: Stack(
                  children: [
                    Positioned(
                      bottom: screenHeight * 0.09,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.07,
                          color: Colors.black45,
                          padding: EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text( // TODO Make consumer Widget
                              clientGame.selectedMove + 1 ==
                                  clientGame.chessMoves.length
                                  ? "Move ${clientGame.chessMoves.length}"
                                  : "Move ${clientGame.selectedMove + 1} of ${clientGame.chessMoves.length}",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    ),
                    threeChessBoard,
                  ],
                ),
              ),
            )),
          ],
        ),
      );
    });
  }
}
