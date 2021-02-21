import 'dart:ui';

import 'ThinkingBoard.dart';

import 'ChessMoveController.dart';

import '../models/piece.dart';
import '../models/enums.dart';
import 'Tiles.dart';
import 'client_game.dart';
import '../models/local_game.dart';

class LocalClientGame extends ClientGame with ChessMoveController{

  Function providerUpdate;
  LocalGame localGame;

  bool get hasChat{
    return false;
  }

  GameType get gameType{
    return GameType.Local;
  }

  LocalClientGame(
      {LocalGame localGame,
      this.providerUpdate}) : this.localGame = localGame, super(game: localGame);


  @override
  get createTiles{
    if(!localGame.followPlaying){
      return Tiles();
    }
    return Tiles(perspectiveOf: clientPlayer);
  }

  @override
  void doActionButton(RequestType requestType){
    Map<RequestType, Function> onLocalRequest = {
      RequestType.Surrender: () => boardState.newGame(),
      RequestType.Remi: () => boardState.newGame(),
      RequestType.TakeBack: () {
        if (boardState.chessMoves.length != null &&
            boardState.chessMoves.length > 1) {
          boardState.transformTo(boardState.chessMoves
              .sublist(0, boardState.chessMoves.length - 1));
        }
      },
    };

    onLocalRequest[requestType]();
    update();
  }

  @override
  void clientMove(String start, String end){
    boardState.movePieceTo(start, end);
  }


  @override
  bool canDrag() {
    return boardState.selectedMove == boardState.chessMoves.length - 1;
  }

  @override
  bool canMove(){
    return true;
  }

  @override
  PlayerColor get clientPlayer{
    return PlayerColor.values[boardState.chessMoves.length % 3];
  }

  @override
  Map<String, Piece> get pieces{
    return boardState.pieces;
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
    tileKeeper.highlightTiles(highlighted?.value);
  }
}