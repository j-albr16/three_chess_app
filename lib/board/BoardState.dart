import '../models/enums.dart';
import '../models/piece.dart';
import '../models/chess_move.dart';
import 'package:collection/collection.dart';
class BoardState{
  Map<String, Piece> pieces;
  Map<PlayerColor, String> enpassent;
  List<ChessMove> chessMoves;

  BoardState({this.pieces, this.enpassent, this.chessMoves});


  @override
  bool operator ==(Object other) {
    return ListEquality().equals(chessMoves, other);
  }

  @override
  int get hashCode => chessMoves.hashCode;
}