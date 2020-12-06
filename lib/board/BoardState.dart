import 'package:flutter/cupertino.dart';
import 'package:three_chess/board/ThinkingBoard.dart';
import 'package:three_chess/data/board_data.dart';

import '../models/enums.dart';
import '../models/piece.dart';
import '../models/chess_move.dart';
import 'package:collection/collection.dart';

import 'PieceMover.dart';
import 'Tiles.dart';
import 'chess_move_info.dart';
class BoardState{
  List<SubBoardState> subStates;
  Map<String, Piece> pieces;
  Map<PlayerColor, String> enpassent;
  List<ChessMove> chessMoves;
  List<ChessMoveInfo> infoChessMoves;

  int _selectedMove;

  int get selectedMove{
    return _selectedMove;
  }

  set selectedMove(int newIndex){
    assert(newIndex < chessMoves.length);
    _selectedMove = newIndex;
  }

  Map<String, Piece> get selectedPieces{
    return selectedMove == null ? pieces : subStates[selectedMove].pieces;
  }

  BoardState() {
    chessMoves = [];
    pieces = {};
    enpassent = {};
    infoChessMoves = [];
    _newGame();
  }

  BoardState._takeOver({this.pieces, this.enpassent, this.chessMoves, this.infoChessMoves, this.subStates, int selectedMove}){
  }

  BoardState.generate({this.chessMoves}){
    infoChessMoves = [];
    pieces = {};
    enpassent = {};
    subStates = [];
    _newGame();
    for(ChessMove chessMove in chessMoves){
      movePieceTo(chessMove.initialTile, chessMove.nextTile);
    }
  }

  BoardState clone(){
    Map<String, Piece> clonePieces = {};
    Map<PlayerColor, String> clonePassent = {};
    List<SubBoardState> cloneSubStates = [];

    for (MapEntry potEnPass in enpassent.entries) {
      clonePassent[potEnPass.key] = potEnPass.value;
    }

    for (Piece piece in pieces.values) {
      clonePieces[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );
    }
    for(SubBoardState subState in subStates){
      cloneSubStates.add(subState.clone());
    }

    return new BoardState._takeOver(
      pieces: clonePieces,
      enpassent: clonePassent,
      chessMoves: [...chessMoves],
      subStates: cloneSubStates,
      selectedMove: selectedMove,
      infoChessMoves: [...infoChessMoves],
    );
  }

  void movePieceTo(String start, String end){
    List<SpecialMove> specialMoves =[];
    PieceKey takenPiece;
    
      if (end != null && start != null) {
        if (pieces[end] != null) {
          //boardState.pieces.firstWhere(()) = boardState.pieces[String]
          takenPiece = pieces[end].pieceKey;
          specialMoves.add(SpecialMove.Take);
          pieces.remove(end);
        }
        Piece movedPiece = pieces[start];
        if (movedPiece != null) {
          enpassent.removeWhere((key, value) => key == movedPiece.playerColor);

          pieces.remove(start); // removes entry of old piece with old position
          movedPiece.position = end;
          pieces.putIfAbsent(end, () => movedPiece); // adds new entry for piece with new pos
          // moves the selectedPieces

          // Following code listens to weather The King is castling and moves the rook accordingly
          //moveCountOnCharAxis calulates the diffrence between start and end on the character Axis
          int moveCountOnCharAxis = Tiles.charCoordinatesOf[movedPiece.playerColor].indexOf(start[0]) -
              Tiles.charCoordinatesOf[movedPiece.playerColor].indexOf(end[0]);
          if (movedPiece.pieceType == PieceType.King && moveCountOnCharAxis.abs() == 2) {
            //If true: This is a castling move
            specialMoves.add(SpecialMove.Castling);
            if (moveCountOnCharAxis < 0) {
              //Checks in which direction we should castle
              String rookPos =
                  Tiles.charCoordinatesOf[movedPiece.playerColor][7] + Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = pieces[rookPos];
              String newRookPos = BoardData.adjacentTiles[movedPiece.position].left[0];
              rook.position = newRookPos;
              pieces.remove(rookPos);
              pieces.putIfAbsent(newRookPos, () => rook);
              // pieces.firstWhere((e) => e.position == rookPos, orElse: () => null)?.position =
              //     BoardData.adjacentTiles[movedPiece.position].left[0]; //Places the rook to the right of the King

            } else if (moveCountOnCharAxis > 0) {
              //Checks in which direction we should castle
              String rookPos =
                  Tiles.charCoordinatesOf[movedPiece.playerColor][0] + Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = pieces[rookPos];
              String newRookPos = BoardData.adjacentTiles[movedPiece.position].right[0];
              rook.position = newRookPos;
              pieces.remove(rookPos);
              pieces.putIfAbsent(newRookPos, () => rook);
              //Places the rook to the right of the King
            }
          }
          //Pawn en passent listener
          if (movedPiece.pieceType == PieceType.Pawn) {
            int numIndexOld = Tiles.numCoordinatesOf[BoardData.sideData[end]].indexOf(start.substring(1));
            int numIndexNew = Tiles.numCoordinatesOf[BoardData.sideData[end]].indexOf(end.substring(1));
            int charIndexOld = Tiles.charCoordinatesOf[BoardData.sideData[end]].indexOf(start[0]);
            int charIndexNew = Tiles.charCoordinatesOf[BoardData.sideData[end]].indexOf(end[0]);
            if (numIndexOld == 1 && numIndexNew == 3) {
              enpassent[movedPiece.playerColor] = end;
            }
            //If passent occurs delete driven by pawn
            else if ((charIndexOld - charIndexNew).abs() == 1 &&
                (numIndexOld - numIndexNew).abs() == 1 &&
                pieces[BoardData.adjacentTiles[end].top[0]] != null) {

              takenPiece = pieces[end].pieceKey;
              specialMoves.add(SpecialMove.Take);
              pieces.remove(BoardData.adjacentTiles[end].top[0]);
              specialMoves.add(SpecialMove.Enpassant);
            }
          }
        }

        ChessMove chessMove = ChessMove(initialTile: start, nextTile: end);
        chessMoves.add(chessMove);
        if (ThinkingBoard.isCheckMate(PlayerColor.values[chessMoves.length%3], this)) {
          specialMoves.add(SpecialMove.CheckMate);
        }
        else if(ThinkingBoard.isCheck(PlayerColor.values[chessMoves.length%3], this)){
          specialMoves.add(SpecialMove.Check);
        }
        subStates.add(SubBoardState(enpassent: enpassent, pieces: pieces).clone());
        infoChessMoves.add(ChessMoveInfo(chessMove: chessMove, movedPiece: pieces[end].pieceKey, specialMoves: specialMoves, takenPiece: takenPiece));
      }
  }


  void _newGame() {
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
      //#endregions
      //#endregion
    ].forEach((piece) {pieces[piece.position] = piece;});
        enpassent = {};
    subStates = [];
    subStates.add(SubBoardState(enpassent: enpassent, pieces: pieces).clone());
    chessMoves = [];
    infoChessMoves = [];
  }

  @override
  bool operator ==(Object other) {
    return ListEquality().equals(chessMoves, other);
  }

  @override
  int get hashCode => chessMoves.hashCode;
}

class SubBoardState {
  Map<String, Piece> pieces;
  Map<PlayerColor, String> enpassent;
  SubBoardState({@required this.enpassent, @required this.pieces});

  SubBoardState clone(){
    Map<PlayerColor, String> newEn = {};
    Map<String, Piece> newPieces = {};
    for(MapEntry entry in enpassent.entries){
      newEn[entry.key] = entry.value;
    }
    for (Piece piece in pieces.values) {
      newPieces[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );
    }
    return SubBoardState(enpassent: newEn, pieces: newPieces);
  }
}