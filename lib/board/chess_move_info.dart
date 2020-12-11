

import 'package:flutter/cupertino.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/models/enums.dart';

enum SpecialMove{Castling, Enpassant, Check, CheckMate, Take, NoMove, Win}

class ChessMoveInfo {
  ChessMove chessMove;
  PieceKey movedPiece;
  List<SpecialMove> specialMoves;
  Map<SpecialMove, List<PlayerColor>> targetedPlayer;
  PieceKey takenPiece; //may only be not null if specialMoves.contains(SpecialMove.Take) == true

  ChessMoveInfo({@required this.chessMove, @required this.movedPiece, @required this.specialMoves, this.takenPiece, this.targetedPlayer}) {
    assert ((takenPiece != null) == specialMoves.contains(SpecialMove.Take));
    assert (specialMoves.where((element) {
      if(element == SpecialMove.Check || element == SpecialMove.CheckMate || element == SpecialMove.Take ){
           return targetedPlayer[element] == null || targetedPlayer[element].isEmpty;
          }
      return false;
        }).toList().isEmpty);
  }
}