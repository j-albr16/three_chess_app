
enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
enum PlayerColor{white, black, red}

class Piece{
  String position;
  final PieceType pieceType;
  final PlayerColor player;
  final String image;


  Piece({this.position, this.pieceType, this.player,this.image,});
}