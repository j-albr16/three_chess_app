import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:three_chess/board/ThinkingBoard.dart';

import 'ChessMoveController.dart';

import '../providers/game_provider.dart';

import '../models/piece.dart';
import '../models/chess_move.dart';
import '../models/enums.dart';
import 'Tiles.dart';
import 'client_game.dart';
import '../models/online_game.dart';

class OnlineClientGame extends ClientGame with ChessMoveController{

  Function providerUpdate;
  GameProvider gameProvider;
  bool waitingForResponse = false;
  OnlineGame onlineGame;

  GameType get gameType{
    return GameType.Online;
  }

  OnlineClientGame({OnlineGame onlineGame, this.providerUpdate, this.gameProvider}) : this.onlineGame = onlineGame,  super(game: onlineGame);

  @override
  get createTiles{
    return Tiles(perspectiveOf: clientPlayer);
  }

  syncChessMove(List<ChessMove> chessMoves){ //Needs to be updated when GameProvider does, by ClientGameProvider
    if (!waitingForResponse) {
      int previousLength = boardState.chessMoves.length;
      boardState.transformTo(chessMoves);
      if(boardState.chessMoves.length != previousLength){
        highlighted = null;

      }
    }
  }

  @override
  void doActionButton(RequestType requestType){
    Map<RequestType, Function> onRequest = {
      RequestType.Surrender: () => gameProvider.requestSurrender(),
      RequestType.Remi: () => gameProvider.requestRemi(),
      RequestType.TakeBack: () => gameProvider.requestTakeBack(),
    };

    onRequest[requestType]();
  }

  @override
  void clientMove(String start, String end){
    boardState.movePieceTo(start, end);

    waitingForResponse = true;
    gameProvider.sendMove(chessMove : boardState.chessMoves.last).then((response) {
      if (!response) {
        boardState.transformTo(boardState.chessMoves
            .sublist(0, boardState.chessMoves.length - 1));
      }
      waitingForResponse = false;
    });
  }


  @override
  bool canDrag() {
    return boardState.selectedMove == boardState.chessMoves.length - 1;
  }

  @override
  bool canMove(){
    return clientPlayer.index == chessMoves.length % 3;
  }

  @override
  PlayerColor get clientPlayer{
    return gameProvider.player.playerColor; //TODO Can also be taken by onlineGame (model). To be decided in the future.
  }

  @override
  Map<String, Piece> get pieces{
    return pieces;
  }

  @override
  List<String> legalMoves(String whatsHit){
    return ThinkingBoard.getLegalMove(whatsHit, boardState);
  }

  @override
  String getPosition(Offset localPosition){
    return tileKeeper.getTilePositionOf(localPosition);
  }

  @override
  void update(){
    providerUpdate();
  }

  @override
  void updateHighlighted(){
    tileKeeper.highlightTiles(highlighted);
  }
}