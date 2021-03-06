import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'ThinkingBoard.dart';
import '../data/board_data.dart';

import '../models/enums.dart';
import '../models/piece.dart';
import '../models/chess_move.dart';

import 'Tiles.dart';


class BoardStateBone{
  Map<String, Piece> pieces;
  Map<PlayerColor, String> enpassent;
  List<ChessMove> chessMoves;
  Map<String, Piece> customStartingBoard;
  PlayerColor startingColor;

  BoardStateBone({this.chessMoves, this.enpassent, this.pieces, this.customStartingBoard, this.startingColor = PlayerColor.white}) {
    if(customStartingBoard == null){
      customStartingBoard = defaultStartingBoard();
    }
    if(chessMoves == null && enpassent == null && pieces == null){
      newGame();
    }
    else if(pieces == null){
      BoardStateBone.generate(chessMoves: chessMoves);
    }
  }

  BoardStateBone.takeOver({@required this.pieces, @required this.enpassent, @required this.chessMoves, @required this.customStartingBoard, @required this.startingColor});

  BoardStateBone.generate({@required this.chessMoves, this.customStartingBoard, this.startingColor = PlayerColor.white}){
    if(customStartingBoard == null){
      customStartingBoard = defaultStartingBoard();
    }
    _generate(chessMoves);
  }

  void _generate(List<ChessMove> chessMoves,){
    pieces = {};
    enpassent = {};
    newGame();
    for(ChessMove chessMove in chessMoves){
      movePieceTo(chessMove.initialTile, chessMove.nextTile);
    }
  }

  BoardStateBone clone(){
    Map<String, Piece> clonePieces = {};
    Map<String, Piece> cloneStartingBoard = {};
    Map<PlayerColor, String> clonePassent = {};

    for (MapEntry potEnPass in enpassent.entries) {
      clonePassent[potEnPass.key] = potEnPass.value;
    }

    for (Piece piece in pieces.values) {
      clonePieces[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );

    } for (Piece piece in customStartingBoard.values) {
      cloneStartingBoard[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );
    }

    return new BoardStateBone.takeOver(
      pieces: clonePieces,
      enpassent: clonePassent,
      chessMoves: [...chessMoves],
      customStartingBoard: cloneStartingBoard,
      startingColor: this.startingColor,
    );
  }


  void movePieceTo(String start, String end){
    List<SpecialMove> specialMoves =[];
    PieceKey takenPiece;
    Piece movedPiece;

    if (end != null && start != null) {
      if(end == "" && start == ""){ //Special No Move Call
        // assert(!ThinkingBoard.anyLegalMove(PlayerColor.values[chessMoves.length % 3], this));
        specialMoves.add(SpecialMove.NoMove);

      }
      else{
        if (pieces[end] != null) {
          //boardState.pieces.firstWhere(()) = boardState.pieces[String]
          takenPiece = pieces[end].pieceKey;
          pieces.remove(end);
        }
        movedPiece = pieces[start];
        if (movedPiece != null) {
          enpassent.removeWhere((key, value) => key == movedPiece.playerColor);

          pieces.remove(start); // removes entry of old piece with old position
          movedPiece.position = end;
          pieces.putIfAbsent(
              end, () => movedPiece); // adds new entry for piece with new pos
          // moves the selectedPieces

          // Following code listens to weather The King is castling and moves the rook accordingly
          //moveCountOnCharAxis calulates the diffrence between start and end on the character Axis
          int moveCountOnCharAxis = Tiles
              .charCoordinatesOf[movedPiece.playerColor]
              .indexOf(start[0]) -
              Tiles.charCoordinatesOf[movedPiece.playerColor].indexOf(end[0]);
          if (movedPiece.pieceType == PieceType.King &&
              moveCountOnCharAxis.abs() == 2) {
            //If true: This is a castling move
            specialMoves.add(SpecialMove.Castling);
            if (moveCountOnCharAxis < 0) {
              //Checks in which direction we should castle
              String rookPos = Tiles.charCoordinatesOf[movedPiece.playerColor]
              [7] +
                  Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = pieces[rookPos];
              String newRookPos =
              BoardData.adjacentTiles[movedPiece.position].left[0];
              rook.position = newRookPos;
              pieces.remove(rookPos);
              pieces.putIfAbsent(newRookPos, () => rook);
              // pieces.firstWhere((e) => e.position == rookPos, orElse: () => null)?.position =
              //     BoardData.adjacentTiles[movedPiece.position].left[0]; //Places the rook to the right of the King

            } else if (moveCountOnCharAxis > 0) {
              //Checks in which direction we should castle
              String rookPos = Tiles.charCoordinatesOf[movedPiece.playerColor]
              [0] +
                  Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = pieces[rookPos];
              String newRookPos =
              BoardData.adjacentTiles[movedPiece.position].right[0];
              rook.position = newRookPos;
              pieces.remove(rookPos);
              pieces.putIfAbsent(newRookPos, () => rook);
              //Places the rook to the right of the King
            }
          }
          //Pawn en passent listener
          if (movedPiece.pieceType == PieceType.Pawn) {
            int numIndexOld = Tiles.numCoordinatesOf[BoardData.sideData[end]]
                .indexOf(start.substring(1));
            int numIndexNew = Tiles.numCoordinatesOf[BoardData.sideData[end]]
                .indexOf(end.substring(1));
            int charIndexOld = Tiles.charCoordinatesOf[BoardData.sideData[end]]
                .indexOf(start[0]);
            int charIndexNew = Tiles.charCoordinatesOf[BoardData.sideData[end]]
                .indexOf(end[0]);
            if (numIndexOld == 1 && numIndexNew == 3) {
              enpassent[movedPiece.playerColor] = end;
            }
            //If passent occurs delete driven by pawn
            else if ((charIndexOld - charIndexNew).abs() == 1 &&
                numIndexOld - numIndexNew == 1 &&
                numIndexNew == 2 &&
                pieces[BoardData.adjacentTiles[end].top[0]] != null) {
              // print("im in boardState movePieceTo enpassent");
              // print(BoardData.adjacentTiles[end].top[0]);
              // print(enpassent[BoardData.sideData[end]].toString() + "this is the enpassent");

              PieceKey possTakenPiece =
                  pieces[BoardData.adjacentTiles[end].top[0]].pieceKey;
              if (enpassent[PieceKeyGen.getPlayerColor(possTakenPiece)] !=
                  null &&
                  enpassent[PieceKeyGen.getPlayerColor(possTakenPiece)] ==
                      ThinkingBoard.checkEmpty(
                          BoardData.adjacentTiles[end].top, 0)) {
                pieces.remove(BoardData.adjacentTiles[end].top[0]);
                takenPiece = possTakenPiece;
              }
            }
          }
        }
      }
      ChessMove chessMove = ChessMove(initialTile: start, nextTile: end);
      chessMoves.add(chessMove);
    }
  }

BoardStateBone cloneBones(){
    return this.clone();
}

  Map<String, Piece> defaultStartingBoard(){
      Map<String, Piece> classicStartingBoard = {};
    BoardData.defaultStartingBoard.forEach((piece) {classicStartingBoard[piece.position] = piece;});

    return classicStartingBoard;
  }

  void newGame() {
    pieces = customStartingBoard;
    startingColor = PlayerColor.white;
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
