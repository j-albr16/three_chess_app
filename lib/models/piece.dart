import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';


enum PieceKey{PawnWhite, PawnBlack, PawnRed, RookWhite, RookBlack, RookRed, KnightWhite, KnightBlack, KnightRed, BishopWhite, BishopBlack, BishopRed, KingWhite, KingBlack, KingRed, QueenWhite, QueenBlack, QueenRed}
enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
enum PlayerColor{white, black, red }

class PieceKeyGen {
static genKey(PieceType pieceType, PlayerColor playerColor){
  return PieceKey.values[pieceType.index*3 + playerColor.index];
}
static getPieceType(PieceKey pieceKey){
  return PieceType.values[(pieceKey.index / 3 ).toInt()];
}
static getPlayerColor(PieceKey pieceKey){
  return PlayerColor.values[pieceKey.index % 3];
}
}


class Piece{
  String position;
  final PieceType pieceType;
  final PlayerColor player;
  PieceKey get pieceKey{
    return PieceKeyGen.genKey(pieceType, player);
  }

  Piece({this.position, this.pieceType, this.player,});


}
