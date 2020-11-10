import '../models/enums.dart';
import '../models/piece.dart';
import '../models/chess_move.dart';
import 'package:collection/collection.dart';

import 'PieceMover.dart';
class BoardState{
  Map<String, Piece> pieces;
  Map<PlayerColor, String> enpassent;
  List<ChessMove> chessMoves;

  BoardState({this.pieces, this.enpassent, this.chessMoves});

  BoardState.newGame() {
    pieces = {};
    [
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
    ].forEach((piece) {pieces[piece.position] = piece;});
        enpassent = {};
    chessMoves = [];
  }

  @override
  bool operator ==(Object other) {
    return ListEquality().equals(chessMoves, other);
  }

  @override
  int get hashCode => chessMoves.hashCode;
}