import './piece.dart';

enum MoveType{QueenSideRochade, KingSideRochade, Take}

class ChessMove{
   String initialTile;
   String nextTile;
   Piece piece;
   bool check;
   bool checkMate;
}