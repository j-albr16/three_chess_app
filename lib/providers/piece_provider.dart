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
    //White
    //#region White
      //#region pawns
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.white,
      position: 'A2',
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
      //#endregion
      //#region noPawns
    Piece(
      pieceType: PieceType.Rook,
      player: PlayerColor.white,
      position: 'A1',
    ),
    Piece(
      pieceType: PieceType.Knight,
      player: PlayerColor.white,
      position: 'B1',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      player: PlayerColor.white,
      position: 'C1',
    ),
    Piece(
      pieceType: PieceType.Queen,
      player: PlayerColor.white,
      position: 'D1',
    ),
    Piece(
      pieceType: PieceType.King,
      player: PlayerColor.white,
      position: 'E1',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      player: PlayerColor.white,
      position: 'F1',
    ),
    Piece(
      pieceType: PieceType.Knight,
      player: PlayerColor.white,
      position: 'G1',
    ),
    Piece(
      pieceType: PieceType.Rook,
      player: PlayerColor.white,
      position: 'H1',
    ),
    //#endregion
    //#endregion
    //#region Black
      //#region pawns
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'L7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'K7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'J7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'I7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'D7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'C7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'B7',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.black,
      position: 'A7',
    ),
    //#endregion
      //#region noPawns
    Piece(
      pieceType: PieceType.Rook,
      player: PlayerColor.black,
      position: 'L8',
    ),
    Piece(
      pieceType: PieceType.Knight,
      player: PlayerColor.black,
      position: 'K8',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      player: PlayerColor.black,
      position: 'J8',
    ),
    Piece(
      pieceType: PieceType.Queen,
      player: PlayerColor.black,
      position: 'I8',
    ),
    Piece(
      pieceType: PieceType.King,
      player: PlayerColor.black,
      position: 'D8',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      player: PlayerColor.black,
      position: 'C8',
    ),
    Piece(
      pieceType: PieceType.Knight,
      player: PlayerColor.black,
      position: 'B8',
    ),
    Piece(
      pieceType: PieceType.Rook,
      player: PlayerColor.black,
      position: 'A8',
    ),
    //#endregion
    //#endregion
    //#region red
      //#region pawns
      //Pawns
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'H11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'G11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'F11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'E11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'I11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'J11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'K11',
    ),
    Piece(
      pieceType: PieceType.Pawn,
      player: PlayerColor.red,
      position: 'L11',
    ),
    //#endregion
      //#region noPawns
    Piece(
      pieceType: PieceType.Rook,
      player: PlayerColor.red,
      position: 'H12',
    ),
    Piece(
      pieceType: PieceType.Knight,
      player: PlayerColor.red,
      position: 'G12',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      player: PlayerColor.red,
      position: 'F12',
    ),
    Piece(
      pieceType: PieceType.Queen,
      player: PlayerColor.red,
      position: 'E12',
    ),
    Piece(
      pieceType: PieceType.King,
      player: PlayerColor.red,
      position: 'I12',
    ),
    Piece(
      pieceType: PieceType.Bishop,
      player: PlayerColor.red,
      position: 'J12',
    ),
    Piece(
      pieceType: PieceType.Knight,
      player: PlayerColor.red,
      position: 'K12',
    ),
    Piece(
      pieceType: PieceType.Rook,
      player: PlayerColor.red,
      position: 'L12',
    ),
    //#endregion
    //#endregion
  ];
}
