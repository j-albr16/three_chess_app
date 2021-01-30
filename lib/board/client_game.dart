import 'package:flutter/cupertino.dart';
import 'package:three_chess/board/ChessMoveController.dart';

import "BoardState.dart";
import "Tiles.dart";
import '../models/chess_move.dart';
import '../models/enums.dart';
import '../models/player.dart';
import 'chess_move_info.dart';
import 'ChessMoveController.dart';
import '../models/piece.dart';
import '../models/game.dart';



 abstract class ClientGame implements ChessMoveController{

  @protected
 BoardState boardState;
 Tiles tileKeeper;
 Game game;
 PlayerColor clientPlayer;

 ClientGame({this.game}){
  tileKeeper = createTiles;
  boardState = BoardState.generate(chessMoves: game.chessMoves);
 }

 @protected
 Tiles get createTiles;

  Map<String, Piece> get pieces{
   return boardState.clone().pieces;
  }

  Map<String, Piece> get selectedPieces{
   return boardState.clone().selectedPieces;
  }

 List<ChessMove> get chessMoves{
   return boardState.clone().chessMoves;
 }

 List<ChessMoveInfo> get infoChessMoves{
  return boardState.clone().infoChessMoves;
 }

 GameType get gameType;

 doActionButton(RequestType requestType);

 clientMove(String start, String end);

 int get selectedMove{
  return boardState.selectedMove;
 }

 set selectedMove(int newIndex){
  boardState.selectedMove = newIndex;
 }
}


