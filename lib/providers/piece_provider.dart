import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../painter/piece_painter.dart';
import '../models/piece.dart';
import '../providers/tile_provider.dart';

class PieceProvider with ChangeNotifier {
  List<Piece> _pieces = [];

  List<Piece> get pieces {
    return [..._pieces];
  }

  startGame(BuildContext context) {
    _pieces.addAll(startPos);
    return _pieces.map((e) => PiecePainter(
      tiles: Provider.of<TileProvider>(context).tiles,
      piece: e,
    ));
  }

  List<Piece> startPos = [
    Piece(
      image: '../assets/black/bishop_pawn.png',
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'B2',
    ),
  ];
}
