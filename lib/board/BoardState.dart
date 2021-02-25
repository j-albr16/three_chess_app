import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'BoardStateBone.dart';
import 'ThinkingBoard.dart';
import '../data/board_data.dart';
import '../helpers/sound_player.dart';

import '../models/enums.dart';
import '../models/piece.dart';
import '../models/chess_move.dart';

import 'Tiles.dart';
import 'chess_move_info.dart';

class BoardState extends BoardStateBone {
  List<SubBoardState> subStates;
  List<ChessMoveInfo> infoChessMoves;
  bool gameWon = false;

  int _selectedMove;

  int get selectedMove {
    return _selectedMove ?? chessMoves.length - 1;
  }

  set selectedMove(int newIndex) {
    if (newIndex < 0) {
      _selectedMove = -1;
    } else if (newIndex >= chessMoves.length) {
      _selectedMove = chessMoves.length - 1;
    } else {
      _selectedMove = newIndex;
    }
  }

  Map<String, Piece> get selectedPieces {
    return _selectedMove == null ? pieces : subStates[selectedMove + 1].pieces;
  }

  BoardState({Map<String, Piece> customStartingBoard, PlayerColor startingColor}) : super(customStartingBoard: customStartingBoard, startingColor: startingColor) {
    super.chessMoves = [];
    super.pieces = {};
    super.enpassent = {};
    infoChessMoves = [];
    newGame();
  }

  BoardState._takeOver(
      {Map<String, Piece> pieces,
      Map<PlayerColor, String> enpassent,
      List<ChessMove> chessMoves,
      this.infoChessMoves,
      this.subStates,
      int selectedMove,
      Map<String, Piece> customStartingBoard,
      PlayerColor startingColor})
      : super(
            chessMoves: chessMoves,
            pieces: pieces,
            enpassent: enpassent,
            startingColor: startingColor,
            customStartingBoard: customStartingBoard) {
    if (pieces.values
            .where((element) => element.pieceType == PieceType.King)
            .toList()
            .length !=
        3) {
      gameWon = true;
    }
  }

  BoardState.generate({List<ChessMove> chessMoves, Map<String, Piece> customStartingBoard, PlayerColor startingColor}) {
    super.customStartingBoard = customStartingBoard;
    super.startingColor = startingColor;
    _generate(chessMoves ?? []);
  }

  void _generate(List<ChessMove> chessMoves) {
    infoChessMoves = [];
    super.pieces = {};
    super.enpassent = {};
    subStates = [];
    newGame();
    bool isSilent = true;
    for (ChessMove chessMove in chessMoves) {
      if (chessMove == chessMoves.last) {
        isSilent = false;
      }
      movePieceTo(chessMove.initialTile, chessMove.nextTile, silent: isSilent);
    }
  }

  BoardStateBone cloneBones() {
    return super.clone();
  }

  BoardState clone() {
    Map<String, Piece> clonePieces = {};
    Map<PlayerColor, String> clonePassent = {};
    List<SubBoardState> cloneSubStates = [];

    for (MapEntry potEnPass in enpassent.entries) {
      clonePassent[potEnPass.key] = potEnPass.value;
    }

    for (Piece piece in super.pieces.values) {
      clonePieces[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );
    }
    for (SubBoardState subState in subStates) {
      cloneSubStates.add(subState.clone());
    }

    return new BoardState._takeOver(
      pieces: clonePieces,
      enpassent: clonePassent,
      chessMoves: [...chessMoves],
      subStates: cloneSubStates,
      selectedMove: selectedMove,
      infoChessMoves: [...infoChessMoves],
      startingColor: super.startingColor,
    );
  }

  void transformTo(List<ChessMove> newChessMoves) {
    bool isSilent = true;
    bool isSame = true;
    newChessMoves ??= [];
    int smallerLength = newChessMoves.length < super.chessMoves.length
        ? newChessMoves.length
        : super.chessMoves.length;
    for (int i = 0; i < smallerLength; i++) {
      if (!super.chessMoves[i].equalMove(newChessMoves[i])) {
        isSame = false;
      }
    }

    if (isSame && newChessMoves.length > 0) {
      if (newChessMoves.length < super.chessMoves.length) {
        if (selectedMove != null && selectedMove >= newChessMoves.length) {
          selectedMove = newChessMoves.length - 1;
        }
        gameWon = false;
        super.pieces = subStates[newChessMoves.length].pieces;
        super.enpassent = subStates[newChessMoves.length].enpassent;
        subStates = subStates.sublist(0, newChessMoves.length + 1);
        infoChessMoves = infoChessMoves.sublist(0, newChessMoves.length);
        super.chessMoves = newChessMoves;
      } else if (newChessMoves.length > super.chessMoves.length) {
        int difference = newChessMoves.length - super.chessMoves.length;
        for (int i = newChessMoves.length - difference;
            i < newChessMoves.length;
            i++) {
          if (i == newChessMoves.length - 1) {
            isSilent = false;
          }
          movePieceTo(newChessMoves[i].initialTile, newChessMoves[i].nextTile,
              silent: isSilent);
        }
      }
    } else {
      _generate(newChessMoves);
    }
  }

  _makeASound(ChessMoveInfo chessMoveInfo) {
    // TODO sound
    if (chessMoveInfo.specialMoves.contains(SpecialMove.NoMove)) {
      Sounds.playSound(Sound.Move);
    } else if (chessMoveInfo.specialMoves.contains(SpecialMove.Check)) {
      Sounds.playSound(Sound.Check);
    } else if (chessMoveInfo.specialMoves.contains(SpecialMove.Take)) {
      Sounds.playSound(Sound.Capture);
    } else {
      Sounds.playSound(Sound.Move);
    }
  }

  @override
  void movePieceTo(String start, String end, {bool silent = false}) {
    List<SpecialMove> specialMoves = [];
    PieceKey takenPiece;
    Map<SpecialMove, List<PlayerColor>> chessInfoTargetPlayer = {};
    Piece movedPiece;
    if (gameWon) {
      return;
    }

    if (end != null && start != null) {
      if (end == "" && start == "") {
        //Special No Move Call
        // assert(!ThinkingBoard.anyLegalMove(PlayerColor.values[chessMoves.length % 3], this));
        specialMoves.add(SpecialMove.NoMove);
      } else {
        if (super.pieces[end] != null) {
          //boardState.pieces.firstWhere(()) = boardState.pieces[String]
          takenPiece = super.pieces[end].pieceKey;
          specialMoves.add(SpecialMove.Take);
          chessInfoTargetPlayer[SpecialMove.Take] = [
            PieceKeyGen.getPlayerColor(takenPiece)
          ];
          super.pieces.remove(end);
        }
        movedPiece = super.pieces[start];
        if (movedPiece != null) {
          enpassent.removeWhere((key, value) => key == movedPiece.playerColor);

          super
              .pieces
              .remove(start); // removes entry of old piece with old position
          movedPiece.position = end;
          super.pieces.putIfAbsent(
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

              Piece rook = super.pieces[rookPos];
              String newRookPos =
                  BoardData.adjacentTiles[movedPiece.position].left[0];
              rook.position = newRookPos;
              super.pieces.remove(rookPos);
              super.pieces.putIfAbsent(newRookPos, () => rook);
              // pieces.firstWhere((e) => e.position == rookPos, orElse: () => null)?.position =
              //     BoardData.adjacentTiles[movedPiece.position].left[0]; //Places the rook to the right of the King

            } else if (moveCountOnCharAxis > 0) {
              //Checks in which direction we should castle
              String rookPos = Tiles.charCoordinatesOf[movedPiece.playerColor]
                      [0] +
                  Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = super.pieces[rookPos];
              String newRookPos =
                  BoardData.adjacentTiles[movedPiece.position].right[0];
              rook.position = newRookPos;
              super.pieces.remove(rookPos);
              super.pieces.putIfAbsent(newRookPos, () => rook);
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
                super.pieces[BoardData.adjacentTiles[end].top[0]] != null) {
              // print("im in boardState movePieceTo enpassent");
              // print(BoardData.adjacentTiles[end].top[0]);
              // print(enpassent[BoardData.sideData[end]].toString() + "this is the enpassent");

              PieceKey possTakenPiece =
                  super.pieces[BoardData.adjacentTiles[end].top[0]].pieceKey;
              if (enpassent[PieceKeyGen.getPlayerColor(possTakenPiece)] !=
                      null &&
                  super.enpassent[PieceKeyGen.getPlayerColor(possTakenPiece)] ==
                      ThinkingBoard.checkEmpty(
                          BoardData.adjacentTiles[end].top, 0)) {
                specialMoves.add(SpecialMove.Take);
                super.pieces.remove(BoardData.adjacentTiles[end].top[0]);
                specialMoves.add(SpecialMove.Enpassant);
                takenPiece = possTakenPiece;
                chessInfoTargetPlayer[SpecialMove.Take] =
                    PieceKeyGen.getPlayerColor(takenPiece);
              }
            }
          }
        }
      }
      ChessMove chessMove = ChessMove(initialTile: start, nextTile: end);
      super.chessMoves.add(chessMove);
      if (!specialMoves.contains(SpecialMove.NoMove)) {
        bool check = false;
        bool checkMated = false;
        List<PlayerColor> checked = [];
        List<PlayerColor> checkedMated = [];
        for (int i = 0; i < 2; i++) {
          if (ThinkingBoard.isCheck(
              PlayerColor.values[(chessMoves.length + i) % 3], this)) {
            check = true;
            checked.add(PlayerColor.values[(chessMoves.length + i) % 3]);
            if (ThinkingBoard.isCheckMate(
                PlayerColor.values[(chessMoves.length + i) % 3], this)) {
              print("I tell you its checkmate in movePieceTo boardState");
              checkMated = true;
              checkedMated.add(PlayerColor.values[(chessMoves.length + i) % 3]);
            }
          }
        }
        if (check) {
          specialMoves.add(SpecialMove.Check);
          chessInfoTargetPlayer[SpecialMove.Check] = checked;
          if (checkMated) {
            specialMoves.add(SpecialMove.CheckMate);
            chessInfoTargetPlayer[SpecialMove.CheckMate] = checkedMated;
          }
        }
      }
      if (takenPiece != null &&
          PieceKeyGen.getPieceType(takenPiece) == PieceType.King) {
        specialMoves.add(SpecialMove.Win);
        gameWon = true;
      }
      _selectedMove = null;
      subStates
          .add(SubBoardState(enpassent: enpassent, pieces: pieces).clone());
      infoChessMoves.add(ChessMoveInfo(
          chessMove: chessMove,
          movedPiece: movedPiece?.pieceKey,
          specialMoves: specialMoves,
          takenPiece: takenPiece,
          targetedPlayer: chessInfoTargetPlayer));
      if (!silent) {
        _makeASound(infoChessMoves.last);
      }
    }
  }

  @override
  void newGame() {
    super.newGame();
    subStates = [];
    subStates.add(
        SubBoardState(enpassent: super.enpassent, pieces: super.pieces)
            .clone());
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

  SubBoardState clone() {
    Map<PlayerColor, String> newEn = {};
    Map<String, Piece> newPieces = {};
    for (MapEntry entry in enpassent.entries) {
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
