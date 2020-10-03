import 'enums.dart';



class PieceKeyGen {
static genKey(PieceType pieceType, PlayerColor playerColor){
  return PieceKey.values[pieceType.index*3 + playerColor.index];
}
static getPieceType(PieceKey pieceKey){
  return PieceType.values[(pieceKey.index / 3 ).toInt()];
}
static getPlayerColor(PieceKey pieceKey){
  return PlayerColor.values[pieceKey.index % 3];
}
}


class Piece{
  String position;
  final PieceType pieceType;
  final PlayerColor playerColor;
  PieceKey get pieceKey{
    return PieceKeyGen.genKey(pieceType, playerColor);
  }

  Piece({this.position, this.pieceType, this.playerColor,});


}
