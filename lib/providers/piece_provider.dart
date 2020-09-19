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
      player: PlayerColor.black,
      position: 'B2',
    ),
  ];
}
