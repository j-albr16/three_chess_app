import '../models/tile.dart';

import '../models/enums.dart';
import '../models/piece.dart';
import '../Board/Tiles.dart';
import '../Board/BoardState.dart';
import '../data/board_data.dart';
import '../Board/PieceMover.dart';

class ThinkingBoard {

  static PlayerColor _getCurrentPlayer(BoardState boardState){
    return PlayerColor.values[boardState.chessMoves.length % 3];
  }

  static List<List<Direction>> _directionListKnight;
  static List<List<Direction>> _directionListKnight2;

  static BoardState copyBoardState(BoardState boardState) {
    Map<String, Piece> virtualPieces = {};
    Map<PlayerColor, String> virtualEnPassent = {};

    for (MapEntry potEnPass in boardState.enpassent.entries) {
      virtualEnPassent[potEnPass.key] = potEnPass.value;
    }

    for (Piece piece in boardState.pieces.values) {
      virtualPieces[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );
    }

    return new BoardState(
      pieces: virtualPieces,
      enpassent: virtualEnPassent,
      chessMoves: [...boardState.chessMoves],
    );
  }

  static List<String> getLegalMove(
      String selectedTile, BoardState boardState,) {
    Piece piece = boardState.pieces[selectedTile];
    if(piece == null){return [];}

    PlayerColor pieceColor = piece.playerColor;
    //region help

    _legalMovesPawn() {
      List<String> stepsInFront = getPossibleStep(
        boardState: boardState,
        startingTile: selectedTile,
        direction: Direction.top,
        func: canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
        canMoveWithoutTake: true,
        canTake: false,
      );
      List<String> allLegalMoves = [
        ...getPossibleStep(
          boardState: boardState,
          startingTile: selectedTile,
          direction: Direction.topRight,
          func: canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          canMoveWithoutTake: false,
        ),
        ...getPossibleStep(
          boardState: boardState,
          startingTile: selectedTile,
          direction: Direction.leftTop,
          func: canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          canMoveWithoutTake: false,
        ),
        ...stepsInFront,
        if (boardState.pieces[selectedTile]?.didMove == false &&
            stepsInFront?.isNotEmpty == true)
          ...getPossibleStep(
            boardState: boardState,
            startingTile: BoardData.adjacentTiles[selectedTile].top[0],
            direction: Direction.top,
            func: canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
            canMoveWithoutTake: true,
            canTake: false,
            twoStepWorkaroundPlayerColor: pieceColor,
          ),
      ];
      if (Tiles.numCoordinatesOf[BoardData.sideData[selectedTile]]
              .indexOf(selectedTile.substring(1)) ==
          3) {
        String possPassent =
            boardState.enpassent[BoardData.sideData[selectedTile]];
        if ([
          BoardData.adjacentTiles[selectedTile].left[0],
          BoardData.adjacentTiles[selectedTile].right[0]
        ].contains(possPassent)) {
          allLegalMoves.add(BoardData.adjacentTiles[possPassent].bottom[0]);
        }
      }
      return allLegalMoves;
    }

    _legalMovesRook() {
      List<String> allLegalMoves = [];
      for (Direction direction
          in Direction.values.where((element) => element.index % 2 != 0)) {
        allLegalMoves += getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }

    _legalMovesKnight() {
      List<String> allLegalMoves = [];
      for (List<Direction> directions
          in (_directionListKnight + _directionListKnight2)) {
        allLegalMoves += getComplexStep(
          boardState: boardState,
          directions: directions,
          func: canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves.toSet().toList();
    }

    _legalMovesBishop() {
      List<String> allLegalMoves = [];
      for (Direction direction
          in Direction.values.where((element) => element.index % 2 == 0)) {
        allLegalMoves += getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }

    _legalMovesKing() {
      List<String> allLegalMoves = [];
      for (Direction direction in Direction.values) {
        allLegalMoves += getPossibleStep(
          boardState: boardState,
          direction: direction,
          func: canMoveOn(_getCurrentPlayer(boardState), boardState,
              checkAttacked: true),
          startingTile: selectedTile,
        );
      }
      //Castling check
      if (!boardState.pieces[selectedTile].didMove) {
        Map<String, Piece> rooks = {
          "left": boardState.pieces[Tiles.getEqualCoordinate("A1", _getCurrentPlayer(boardState))],
          "right": boardState.pieces[Tiles.getEqualCoordinate("H1", _getCurrentPlayer(boardState))]
        };
        Map<String, Piece> usableRooks = {};
        rooks.entries.forEach((element) {
          if (element.value != null) {
            if (!element.value.didMove) {
              usableRooks[element.key] = element.value;
            }
          }
        });
        for (MapEntry pieceEntry in usableRooks.entries) {
          if (pieceEntry.key == "left") {
            if (boardState.pieces[
                        BoardData.adjacentTiles[selectedTile].left[0]] ==
                    null &&
                boardState.pieces[BoardData
                        .adjacentTiles[
                            BoardData.adjacentTiles[selectedTile].left[0]]
                        .left[0]] ==
                    null &&
                boardState.pieces[BoardData
                        .adjacentTiles[BoardData
                            .adjacentTiles[
                                BoardData.adjacentTiles[selectedTile].left[0]]
                            .left[0]]
                        .left[0]] ==
                    null) {
              if (!isTileCovered(
                  boardState: boardState,
                      toBeCheckedTile:
                          BoardData.adjacentTiles[selectedTile].left[0],
                      requestingPlayer: pieceColor) &&
                  !isTileCovered(
                      boardState: boardState,
                      toBeCheckedTile: BoardData
                          .adjacentTiles[
                              BoardData.adjacentTiles[selectedTile].left[0]]
                          .left[0],
                      requestingPlayer: pieceColor)) {
                //IF WE WANT MORE CASTELING OPTIONS ADD HERE
                allLegalMoves.add(BoardData
                    .adjacentTiles[
                        BoardData.adjacentTiles[selectedTile].left[0]]
                    .left[0]);
              }
            }
          } else if (pieceEntry.key == "right") {
            if (boardState.pieces[
                        BoardData.adjacentTiles[selectedTile].right[0]] ==
                    null &&
                boardState.pieces[BoardData
                        .adjacentTiles[
                            BoardData.adjacentTiles[selectedTile].right[0]]
                        .right[0]] ==
                    null) {
              if (!isTileCovered(
                      boardState: boardState,
                      toBeCheckedTile:
                          BoardData.adjacentTiles[selectedTile].right[0],
                      requestingPlayer: pieceColor) &&
                  !isTileCovered(
                      boardState: boardState,
                      toBeCheckedTile: BoardData
                          .adjacentTiles[
                              BoardData.adjacentTiles[selectedTile].right[0]]
                          .right[0],
                      requestingPlayer: pieceColor)) {
                //IF WE WANT MORE CASTELING OPTIONS ADD HERE
                allLegalMoves.add(BoardData
                    .adjacentTiles[
                        BoardData.adjacentTiles[selectedTile].right[0]]
                    .right[0]);
              }
            }
          }
        }
      }

      return allLegalMoves;
    }

    _legalMovesQueen() {
      List<String> allLegalMoves = [];
      for (Direction direction in Direction.values) {
        allLegalMoves += getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }
    //region end

    List<String> result = [];
    switch (piece.pieceType) {
    //Should not be null, but we dont like errors (talking to my self rn)
      case PieceType.Pawn:
        result.addAll(_legalMovesPawn());
        break;
      case PieceType.Rook:
        result.addAll(_legalMovesRook());
        break;
      case PieceType.Knight:
        result.addAll(_legalMovesKnight());
        break;
      case PieceType.Bishop:
        result.addAll(_legalMovesBishop());
        break;
      case PieceType.King:
        result.addAll(_legalMovesKing());
        break;
      case PieceType.Queen:
        result.addAll(_legalMovesQueen());
        break;
    }

    // Check for checks and therefor remove
    result.removeWhere((element) {
      bool resultRemove = false;
      BoardState virtualState = copyBoardState(boardState);
      PieceMover.movePieceTo(piece.position, element, virtualState);

      resultRemove = isTileCovered(
        boardState: virtualState,
          toBeCheckedTile: virtualState.pieces
              .values
              .firstWhere((currPiece) => currPiece.pieceType == PieceType.King && currPiece.playerColor == piece.playerColor)
              .position,
          requestingPlayer: piece.playerColor);
      return resultRemove;
    });
    return result;
  }

  static bool isCheck(PlayerColor toBeChecked, BoardState boardState) {
    return isTileCovered(
      boardState: boardState,
      requestingPlayer: toBeChecked,
      toBeCheckedTile: boardState.pieces
          .values
          .firstWhere((currPiece) => currPiece.pieceType == PieceType.King && currPiece.playerColor == toBeChecked)
          .position);
  }

  static bool isCheckMate(
      PlayerColor toBeChecked, BoardState boardState) {
    bool result = false;
    if (isCheck(toBeChecked, boardState)) {
      result = true;
      for (Piece piece in boardState.pieces.values.where((element) => element.playerColor == toBeChecked).toList()) {
        for (String legalMove in getLegalMove(piece.position, boardState)) {

          BoardState virtualState = copyBoardState(boardState);
          PieceMover.movePieceTo(piece.position, legalMove, virtualState);

          if (!isCheck(toBeChecked, virtualState)) {
            result = false;
          }
          if (!result) {
            break;
          }
        }
      }
    }
    return result;
  }

  static bool isTileCovered(
      {String toBeCheckedTile,
      PlayerColor requestingPlayer,
      BoardState boardState}) {
    //Bishop, 1/2Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      if (getPossibleLine(
        boardState: boardState,
        stopOnFirst: true,
        direction: direction,
        func: occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Bishop, PieceType.Queen], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
        //startingColor: requestingPlayer,
      ).length >
          0) {
        return true;
      }
    }

    print("I got past Bishop in tile covered");

    //Rook, 2/2 Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 1)) {
      if (getPossibleLine(
        boardState: boardState,
        stopOnFirst: true,
        direction: direction,
        func: occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Rook, PieceType.Queen], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
        //startingColor: requestingPlayer,
      ).length >
          0) {
        return true;
      }
    }

    print("I got past rook in tile covered");

    //King
    for (Direction direction in Direction.values) {
      if (getPossibleStep(
        boardState: boardState,
        direction: direction,
        func: occupiedBy(boardState: boardState, typesToLookFor: [PieceType.King], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      ).length >
          0) {
        return true;
      }
    }

    print("I got past King in tile covered");

    //Knight
    for (List<Direction> directions in (_directionListKnight + _directionListKnight2)) {
      if (getComplexStep(
        boardState: boardState,
        directions: directions,
        //startingColor: requestingPlayer,
        func: occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Knight], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      ).length >
          0) {
        return true;
      }
    }

    //Pawns
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      List<String> possMoves = getPossibleStep(
        boardState: boardState,
        direction: direction,
        func: occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Pawn], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      );

      for (String move in possMoves) {
        if (BoardData.adjacentTiles[move]
            .getRelativeEnum(Direction.leftTop, boardState.pieces[move].playerColor, BoardData.sideData[toBeCheckedTile])
            .contains(toBeCheckedTile) ||
            BoardData.adjacentTiles[move]
                .getRelativeEnum(Direction.topRight, boardState.pieces[move].playerColor, BoardData.sideData[toBeCheckedTile])
                .contains(toBeCheckedTile)) {
          return true;
        }
      }
    }

    print("I got past Knight in tile covered");

    return false;
  }

  static Function canMoveOn(PlayerColor requestingPlayer, BoardState boardState,
      {bool checkAttacked = false}) {
    return (String toBeCheckedTile) {
      bool result = false;
      Piece piece = boardState.pieces[toBeCheckedTile];
      if (piece == null) {
        result = true;
      } else if (piece.playerColor != requestingPlayer) {
        result = null;
      }
      if (checkAttacked && (result != false)) {
        if (isTileCovered(
            toBeCheckedTile: toBeCheckedTile,
            requestingPlayer: requestingPlayer)) {
          return false;
        }
      }
      return result;
    };
  }

  ///Returns true if given Tile is occupied by one of the given PieceTypes of opposing PlayerColor
  static Function occupiedBy(
      {BoardState boardState,
      List<PieceType> typesToLookFor,
      PlayerColor requestingPlayer}) {
    return (String toBeCheckedTile) {
      bool result = false;
      Piece piece = boardState.pieces[toBeCheckedTile];
      if (piece != null) {
        if (piece.playerColor != requestingPlayer &&
            typesToLookFor.contains(piece.pieceType)) {
          result = true;
          //print("occupy says yes with ${piece.pieceType} when ${typesToLookFor[0]} at $toBeCheckedTile of ${piece.playerColor}");
        }
      }
      return result;
    };
  }

  static List<String> getComplexStep({BoardState boardState, List<Direction> directions, String startingTile, bool func(String tile), PlayerColor startingColor}) {
    startingColor ??= BoardData.sideData[startingTile];
    void _nextSteps(List<String> allMoves, int index, String currentTile) {
      List<String> nextTiles =
      BoardData.adjacentTiles[currentTile]?.getRelativeEnum(directions[index], startingColor, BoardData.sideData[currentTile]);
      if (nextTiles.length > 0) {
        if (index == directions.length - 1) {
          if (func(nextTiles[0]) != false) {
            allMoves.add(nextTiles[0]);
          }
        } else {
          _nextSteps(allMoves, index + 1, nextTiles[0]);
        }
      }
    }

    List<String> resultList = [];
    _nextSteps(resultList, 0, startingTile);
    return resultList;
  }

  static List<String> getPossibleLine(
      {BoardState boardState, Direction direction, String startingTile, bool func(String tile), bool stopOnFirst = false, PlayerColor startingColor}) {
    startingColor ??= BoardData.sideData[startingTile];
    void _nextStep(List<String> allMoves, String currentTile) {
      List<String> nextTiles =
      BoardData.adjacentTiles[currentTile]?.getRelativeEnum(direction, startingColor, BoardData.sideData[currentTile]);
      for (String tile in nextTiles) {
        bool evualtion = func(tile);
        if (evualtion == true && !stopOnFirst) {
          allMoves.add(tile);
          _nextStep(allMoves, tile);
        } else if (evualtion == null || (evualtion == true && stopOnFirst)) {
          allMoves.add(tile);
        } else if (evualtion == false) {
          if (stopOnFirst && boardState.pieces[tile] == null) {
            _nextStep(allMoves, tile);
          }
        }
      }
    }

    List<String> resultList = [];
    _nextStep(resultList, startingTile);
    return resultList;
  }

  static getPossibleStep(
      {BoardState boardState,
      Direction direction,
      String startingTile,
      bool func(String tile),
      bool canTake = true,
      bool canMoveWithoutTake = true,
      PlayerColor twoStepWorkaroundPlayerColor}) {
    twoStepWorkaroundPlayerColor ??=
        boardState.pieces[startingTile].playerColor;
    twoStepWorkaroundPlayerColor ??= BoardData.sideData[startingTile];
    List<String> nextTiles = BoardData.adjacentTiles[startingTile]
        ?.getRelativeEnum(direction, twoStepWorkaroundPlayerColor,
            BoardData.sideData[startingTile]);
    List<String> resultList = [];
    for (String tile in nextTiles) {
      if (func(tile) == true && canMoveWithoutTake) {
        //if tile is empty
        //yes: add to result
        resultList.add(tile);
        // if legal and not a take
      } else if (func(tile) == null && canTake) {
        //if tile has enemy Piece && taking is enabled (default = true)
        resultList.add(tile);
      }
    }
    return resultList;
  }
}
