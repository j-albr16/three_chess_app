import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/piece.dart';


class PieceProvider with ChangeNotifier {
  List<Piece> _pieces = [];

  List<Piece> get pieces {
    return  [..._pieces];
  }

  PieceProvider(){
  startGame();
  }

  startGame() {
    _pieces.addAll(startPos);
    notifyListeners();
  }

  List<Piece> startPos = [
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'A1',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'B2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'C2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'D2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'E2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'F2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'G2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'H2',
    ),

  ];
}
