import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:three_chess/data/board_data%20copy.dart';

import 'tile_provider.dart';
import '../models/piece.dart';
import '../models/enums.dart';

class PieceProvider with ChangeNotifier {
  Map<String, Piece> _pieces = {};

  Map<String, Piece> get pieces {
    return {..._pieces};
  }

  PieceProvider() {
    startGame();
  }

  startGame() {
    startPosList.forEach((e) => _pieces.putIfAbsent(e.position, () => e));
    notifyListeners();
  }

  // void switchInvis(Piece piece, bool invis) {
  //   _pieces.firstWhere((element) => element == piece, orElse: () => null)?.invis = invis;
  //   notifyListeners();
  // }

  void movePieceTo(String oldPos, String newPos) {
    if (newPos != null && oldPos != null) {
      if (_pieces[newPos] != null) {
        //_pieces.firstWhere(()) = _pieces[String]
        _pieces.remove(newPos);
        // importend rewrite
      }
      Piece movedPiece = _pieces[oldPos];
      if (movedPiece != null) {
        _pieces.remove(oldPos); // removes entry of old piece with old position
        movedPiece.position = newPos;
        _pieces.putIfAbsent(newPos, () => movedPiece); // adds new entry for piece with new pos
        // moves the selectedPieces

        // Following code listens to weather The King is castling and moves the rook accordingly
        //moveCountOnCharAxis calulates the diffrence between oldPos and newPos on the character Axis
        int moveCountOnCharAxis = TileProvider.charCoordinatesOf[movedPiece.playerColor].indexOf(oldPos[0]) -
            TileProvider.charCoordinatesOf[movedPiece.playerColor].indexOf(newPos[0]);
        if (movedPiece.pieceType == PieceType.King && moveCountOnCharAxis.abs() == 2) {
          //If true: This is a castling move
          if (moveCountOnCharAxis < 0) {
            //Checks in which direction we should castle
            String rookPos =
                TileProvider.charCoordinatesOf[movedPiece.playerColor][7] + TileProvider.numCoordinatesOf[movedPiece.playerColor][0];

            Piece rook = _pieces[rookPos];
            String newRookPos = BoardData.adjacentTiles[movedPiece.position].left[0];
            rook.position = newRookPos;
            _pieces.remove(rookPos);
            _pieces.putIfAbsent(newRookPos, () => rook);
            // _pieces.firstWhere((e) => e.position == rookPos, orElse: () => null)?.position =
            //     BoardData.adjacentTiles[movedPiece.position].left[0]; //Places the rook to the right of the King

          } else if (moveCountOnCharAxis > 0) {
            //Checks in which direction we should castle
            String rookPos =
                TileProvider.charCoordinatesOf[movedPiece.playerColor][0] + TileProvider.numCoordinatesOf[movedPiece.playerColor][0];

            Piece rook = _pieces[rookPos];
            String newRookPos = BoardData.adjacentTiles[movedPiece.position].right[0];
            rook.position = newRookPos;
            _pieces.remove(rookPos);
            _pieces.putIfAbsent(newRookPos, () => rook);
            //Places the rook to the right of the King
          }
        }
      }
      notifyListeners();
    }
  }

  List<Piece> startPosList = [
    //White
    //#region White
    //#region pawns
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'A2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'B2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'C2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'D2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'E2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'F2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'G2',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.white,
      position: 'H2',
    ),
    //#endregion
    //#region noPawns
    Piece(
      pieceType: PieceType.Rook,
      playerColor: PlayerColor.white,
      position: 'A1',
    ),
    Piece(
      pieceType: PieceType.Knight,
      playerColor: PlayerColor.white,
      position: 'B1',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      playerColor: PlayerColor.white,
      position: 'C1',
    ),
    Piece(
      pieceType: PieceType.Queen,
      playerColor: PlayerColor.white,
      position: 'D1',
    ),
    Piece(
      pieceType: PieceType.King,
      playerColor: PlayerColor.white,
      position: 'E1',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      playerColor: PlayerColor.white,
      position: 'F1',
    ),
    Piece(
      pieceType: PieceType.Knight,
      playerColor: PlayerColor.white,
      position: 'G1',
    ),
    Piece(
      pieceType: PieceType.Rook,
      playerColor: PlayerColor.white,
      position: 'H1',
    ),
    //#endregion
    //#endregion
    //#region Black
    //#region pawns
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'L7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'K7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'J7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'I7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'D7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'C7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'B7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.black,
      position: 'A7',
    ),
    //#endregion
    //#region noPawns
    Piece(
      pieceType: PieceType.Rook,
      playerColor: PlayerColor.black,
      position: 'L8',
    ),
    Piece(
      pieceType: PieceType.Knight,
      playerColor: PlayerColor.black,
      position: 'K8',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      playerColor: PlayerColor.black,
      position: 'J8',
    ),
    Piece(
      pieceType: PieceType.Queen,
      playerColor: PlayerColor.black,
      position: 'I8',
    ),
    Piece(
      pieceType: PieceType.King,
      playerColor: PlayerColor.black,
      position: 'D8',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      playerColor: PlayerColor.black,
      position: 'C8',
    ),
    Piece(
      pieceType: PieceType.Knight,
      playerColor: PlayerColor.black,
      position: 'B8',
    ),
    Piece(
      pieceType: PieceType.Rook,
      playerColor: PlayerColor.black,
      position: 'A8',
    ),
    //#endregion
    //#endregion
    //#region red
    //#region pawns
    //Pawns
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'H11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'G11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'F11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'E11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'I11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'J11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'K11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      playerColor: PlayerColor.red,
      position: 'L11',
    ),
    //#endregion
    //#region noPawns
    Piece(
      pieceType: PieceType.Rook,
      playerColor: PlayerColor.red,
      position: 'H12',
    ),
    Piece(
      pieceType: PieceType.Knight,
      playerColor: PlayerColor.red,
      position: 'G12',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      playerColor: PlayerColor.red,
      position: 'F12',
    ),
    Piece(
      pieceType: PieceType.Queen,
      playerColor: PlayerColor.red,
      position: 'E12',
    ),
    Piece(
      pieceType: PieceType.King,
      playerColor: PlayerColor.red,
      position: 'I12',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      playerColor: PlayerColor.red,
      position: 'J12',
    ),
    Piece(
      pieceType: PieceType.Knight,
      playerColor: PlayerColor.red,
      position: 'K12',
    ),
    Piece(
      pieceType: PieceType.Rook,
      playerColor: PlayerColor.red,
      position: 'L12',
    ),
    //#endregion
    //#endregion
  ];
}
