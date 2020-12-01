

import 'package:flutter/cupertino.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/models/enums.dart';

enum SpecialMove{Castling, Enpassant, Check, CheckMate, Take}

class ChessMoveInfo {
  ChessMove chessMove;
  PieceKey movedPiece;
  List<SpecialMove> specialMoves;
  PieceKey takenPiece; //may only be not null if specialMoves.contains(SpecialMove.Take) == true

  ChessMoveInfo({@required this.chessMove, @required this.movedPiece, @required this.specialMoves, this.takenPiece}) {
    assert ((takenPiece != null) == specialMoves.contains(SpecialMove.Take));
  }
}