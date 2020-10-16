<<<<<<< HEAD
import './piece.dart';

import './enums.dart';

enum MoveType{QueenSideRochade, KingSideRochade, Take}

class ChessMove{
   String initialTile;
   String nextTile;
   PieceType piece;
   bool check = false;
   bool checkMate = false;


   ChessMove({this.initialTile, this.check, this.checkMate, this.nextTile, this.piece});
}
=======
import '../models/piece.dart';

enum MoveType { QueenSideRochade, KingSideRochade, Take }

class ChessMove {
  String initialTile;
  String nextTile;
  Piece piece;
  bool check;
  bool checkMate;
}
>>>>>>> ee3e7f190547f99ab0ff90aed1cd12c85d456f19
