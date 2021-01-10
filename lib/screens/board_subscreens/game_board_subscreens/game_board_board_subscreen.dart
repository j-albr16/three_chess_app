import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../../board/BoardState.dart';
import '../../../board/Tiles.dart';
import '../../../models/enums.dart';
import '../../../models/player.dart';
import '../../../providers/board_state_manager.dart';
import '../../../widgets/board_boarding_widgets.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/three_chess_board.dart';

class BoardBoardSubScreen extends StatefulWidget {
  final BoardState boardState;
  final BoardState boardStateListen;
  final Tiles tileKeeper;
  final bool local;

  BoardBoardSubScreen(
      {this.local, this.boardState, this.tileKeeper, this.boardStateListen});

  @override
  _BoardBoardSubScreenState createState() => _BoardBoardSubScreenState();
}

class _BoardBoardSubScreenState extends State<BoardBoardSubScreen> {
  bool local;
  ThreeChessBoard threeChessBoard;

  @override
  void initState() {
    local = widget.local;
    super.initState();
  }

  _moveLeft(context) {
    BoardStateManager boardStateManager =
        Provider.of<BoardStateManager>(context, listen: false);
    boardStateManager
        .setSelectedMove(boardStateManager.boardState.selectedMove--);
  }

  _moveRight(context) {
    BoardStateManager boardStateManager =
        Provider.of<BoardStateManager>(context, listen: false);
    boardStateManager
        .setSelectedMove(boardStateManager.boardState.selectedMove++);
  }

  @override
  Widget build(BuildContext context) {
    Player leftCorner;
    Player rightCorner;

    GameProvider gameProvider =
        Provider.of<GameProvider>(context, listen: false);
    GameProvider gameProviderListen = Provider.of<GameProvider>(context);

    threeChessBoard = ThreeChessBoard(
      height: 500,
      width: 500,
      didStart: ValueNotifier<bool>(gameProviderListen.game?.didStart ?? false),
      whoIsPlaying: Provider.of<BoardStateManager>(context).whoIsPlaying,
      tileKeeper: widget.tileKeeper,
      boardState: widget.boardState,
      boardStateListen: widget.boardStateListen,
    );

    Player getPlayer(PlayerColor playerColor) {
      return gameProviderListen?.game?.player?.firstWhere(
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
        builder: (context, screenHeight, screenWidth, sy, sx) {
      double usableHeight = screenHeight - unusableHeight;

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
                            child: Text(
                              widget.boardState.selectedMove + 1 ==
                                      widget.boardState.chessMoves.length
                                  ? "Move ${widget.boardStateListen.chessMoves.length}"
                                  : "Move ${widget.boardStateListen.selectedMove + 1} of ${widget.boardStateListen.chessMoves.length}",
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
