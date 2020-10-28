import './piece.dart';

import './enums.dart';

enum MoveType { QueenSideRochade, KingSideRochade, Take }

class ChessMove {
  String initialTile;
  String nextTile;
  PieceType piece;
  bool check = false;
  bool checkMate = false;

  ChessMove({this.initialTile, this.check, this.checkMate, this.nextTile, this.piece});
}
