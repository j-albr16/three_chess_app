
import 'package:flutter/material.dart';

import '../models/chess_move.dart';
import '../models/enums.dart';


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

  ChessMoveInfo clone(){
    return new ChessMoveInfo(
        chessMove: chessMove,
        movedPiece: movedPiece,
        specialMoves: [...specialMoves],
        targetedPlayer: Map.from(targetedPlayer.map((key, value) => MapEntry<SpecialMove, List<PlayerColor>>(key, [...value]))),
        takenPiece: takenPiece,
    );
  }
}