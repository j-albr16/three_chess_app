import './piece.dart';

import './enums.dart';

<<<<<<< HEAD
enum MoveType{QueenSideRochade, KingSideRochade, Take}

class ChessMove{
   String initialTile;
   String nextTile;
   PieceType piece;
   bool check = false;
   bool checkMate = false;


   ChessMove({this.initialTile, this.check, this.checkMate, this.nextTile, this.piece});
=======
enum MoveType { QueenSideRochade, KingSideRochade, Take }

class ChessMove {
  String initialTile;
  String nextTile;
  PieceType piece;
  bool check = false;
  bool checkMate = false;

  ChessMove({this.initialTile, this.check, this.checkMate, this.nextTile, this.piece});
>>>>>>> b5e989f3c925ae63cd2ed00d939b8747b7dc5afb
}
