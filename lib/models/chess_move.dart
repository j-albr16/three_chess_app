
enum MoveType { QueenSideRochade, KingSideRochade, Take }

class ChessMove {
  String initialTile;
  String nextTile;
  // TODO think whether we need Piece
  // PieceType piece;
  // bool check = false;
  // bool checkMate = false;
  int remainingTime; // in secs

  ChessMove({this.initialTile, this.nextTile, this.remainingTime});

  bool equalMove(ChessMove chessMove){
    return (chessMove.initialTile == initialTile && chessMove.nextTile == chessMove.nextTile);
  }

  ChessMove clone(){
    return new ChessMove(initialTile: initialTile, nextTile: nextTile);
  }
}
