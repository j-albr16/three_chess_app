enum Direction{bottomRight, bottom, bottomLeft, left, leftTop, top, topRight, right}

enum RequestType {
  Remi,
  Surrender,
  TakeBack,
}
enum PieceKey{PawnWhite, PawnBlack, PawnRed, RookWhite, RookBlack, RookRed, KnightWhite, KnightBlack, KnightRed, BishopWhite, BishopBlack, BishopRed, KingWhite, KingBlack, KingRed, QueenWhite, QueenBlack, QueenRed}
enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
enum PlayerColor{white, black, red}

enum HowGameEnded {
  Remi,
  CheckMate,
  Surrender,
  Leave,
}

enum ResponseRole {
  Accept,
  Create,
  Decline,
}

enum MessageOwner{
  You,
  Server,
  Mate,
}