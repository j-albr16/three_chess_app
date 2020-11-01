import 'piece.dart';

import 'enums.dart';

enum MoveType { QueenSideRochade, KingSideRochade, Take }

class ChessMove {
  String initialTile;
  String nextTile;
  // PieceType piece;
  // bool check = false;
  // bool checkMate = false;
  int remainingTime; // in secs

  ChessMove({this.initialTile, this.nextTile, this.remainingTime});
}
