enum Direction{bottomRight, bottom, bottomLeft, left, leftTop, top, topRight, right}
enum SpecialMove{Castling, Enpassant, Check, CheckMate, Take, NoMove, Win}
enum RequestType {
  Remi,
  Surrender,
  TakeBack,
}

enum TableAction { DrawOffer, TakebackRequest, SurrenderRequest }


enum PieceKey{PawnWhite, PawnBlack, PawnRed, RookWhite, RookBlack, RookRed, KnightWhite, KnightBlack, KnightRed, BishopWhite, BishopBlack, BishopRed, KingWhite, KingBlack, KingRed, QueenWhite, QueenBlack, QueenRed}
enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
enum PlayerColor{white, black, red}

enum HowGameEnded {
  Remi,
  CheckMate,
  Surrender,
  Leave,
}


enum GameType { Local, Analyze, Online }

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

const Map<PlayerColor, String> playerColorString = {
  PlayerColor.white: "White",
  PlayerColor.black: "Black",
  PlayerColor.red: "Red",
};