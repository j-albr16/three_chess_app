import '../models/tile.dart';

import '../models/enums.dart';
import '../models/piece.dart';
import '../board/Tiles.dart';
import '../board/BoardState.dart';
import '../data/board_data.dart';
import '../board/PieceMover.dart';
import 'BoardStateBone.dart';

class ThinkingBoard {

  static checkEmpty(List list, int index){
    if(list.isNotEmpty && list.length > index){
      return list[index];
    }
    return null;
  }

  static PlayerColor _getCurrentPlayer(BoardStateBone boardState){
    return PlayerColor.values[boardState.chessMoves.length % 3];
  }

  static List<List<Direction>> _directionListKnight = [[Direction.left, Direction.top, Direction.top], [Direction.right, Direction.top, Direction.top], [Direction.top, Direction.left, Direction.left], [Direction.bottom, Direction.left, Direction.left], [Direction.left, Direction.bottom, Direction.bottom], [Direction.right, Direction.bottom, Direction.bottom], [Direction.top, Direction.right, Direction.right], [Direction.bottom, Direction.right, Direction.right]];
  static List<List<Direction>> _directionListKnight2 = [[Direction.top, Direction.top, Direction.left], [Direction.top, Direction.top, Direction.right], [Direction.left, Direction.left, Direction.top], [Direction.left, Direction.left, Direction.bottom], [Direction.bottom, Direction.bottom, Direction.left], [Direction.bottom, Direction.bottom, Direction.right], [Direction.right, Direction.right, Direction.top], [Direction.right, Direction.right, Direction.bottom]];

  static List<String> getLegalMove(
      String selectedTile, BoardStateBone boardState,) {
    if(selectedTile == null){
      return null;
    }
    Piece piece = boardState.pieces[selectedTile];
    if(piece == null){return [];}

    PlayerColor pieceColor = piece.playerColor;
    //region help

    _legalMovesPawn() {
      List<String> stepsInFront = _getPossibleStep(
        boardState: boardState,
        startingTile: selectedTile,
        direction: Direction.top,
        func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
        canMoveWithoutTake: true,
        canTake: false,
      );
      List<String> allLegalMoves = [
        ..._getPossibleStep(
          boardState: boardState,
          startingTile: selectedTile,
          direction: Direction.topRight,
          func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          canMoveWithoutTake: false,
        ),
        ..._getPossibleStep(
          boardState: boardState,
          startingTile: selectedTile,
          direction: Direction.leftTop,
          func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          canMoveWithoutTake: false,
        ),
        ...stepsInFront,
        if (boardState.pieces[selectedTile]?.didMove == false &&
            stepsInFront?.isNotEmpty == true)
          ..._getPossibleStep(
            boardState: boardState,
            startingTile: BoardData.adjacentTiles[selectedTile].top[0],
            direction: Direction.top,
            func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
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
        if (possPassent != null && [
          checkEmpty(BoardData.adjacentTiles[selectedTile].left, 0),
          checkEmpty(BoardData.adjacentTiles[selectedTile].right, 0)
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
        allLegalMoves += _getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }

    _legalMovesKnight() {
      List<String> allLegalMoves = [];
      for (List<Direction> directions
          in (_directionListKnight + _directionListKnight2)) {
        allLegalMoves += _getComplexStep(
          boardState: boardState,
          directions: directions,
          func: _canMoveOn(boardState.pieces[selectedTile].playerColor, boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves.toSet().toList();
    }

    _legalMovesBishop() {
      List<String> allLegalMoves = [];
      for (Direction direction
          in Direction.values.where((element) => element.index % 2 == 0)) {
        allLegalMoves += _getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }

    _legalMovesKing() {
      List<String> allLegalMoves = [];
      for (Direction direction in Direction.values) {
        allLegalMoves += _getPossibleStep(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn(_getCurrentPlayer(boardState), boardState,
              checkAttacked: true),
          startingTile: selectedTile,
        );
      }
      //Castling check
      if (!boardState.pieces[selectedTile].didMove && selectedTile == Tiles.getEqualCoordinate("E1", boardState.pieces[selectedTile].playerColor)) {
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
        allLegalMoves += _getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
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
    //print(result.toString());
    result.removeWhere((element) {
      bool resultRemove = false;
      BoardStateBone virtualState = boardState.cloneBones();

      if (virtualState.pieces[element]?.pieceType != PieceType.King) {
        virtualState.movePieceTo(piece.position, element);
      }

      resultRemove = isCheck(piece.playerColor, virtualState);
      return resultRemove;
    });
    return result;
  }

  static bool isCheck(PlayerColor toBeChecked, BoardStateBone boardState) {
    return isTileCovered(
      boardState: boardState,
      requestingPlayer: toBeChecked,
      toBeCheckedTile: boardState.pieces
          .values
          .firstWhere((currPiece) => currPiece.pieceType == PieceType.King && currPiece.playerColor == toBeChecked)
          .position);
  }

  static bool anyLegalMove(PlayerColor toBeChecked, BoardStateBone boardState){
    bool result = false;
    for (Piece piece in boardState.pieces.values.where((element) => element.playerColor == toBeChecked).toList()) {
      for (String legalMove in getLegalMove(piece.position, boardState)) {

        BoardStateBone virtualState = boardState.cloneBones();
        virtualState.movePieceTo(piece.position, legalMove);

        if (!isCheck(toBeChecked, virtualState)) {
          result = true;
        }
        if (result) {
          break;
        }
      }
    }
    return result;
  }

  static bool isCheckMate(
      PlayerColor toBeChecked, BoardStateBone boardState) {
    bool result = false;
    if (isCheck(toBeChecked, boardState)) {
      result = true;
      for (Piece piece in boardState.pieces.values.where((element) => element.playerColor == toBeChecked).toList()) {
        for (String legalMove in getLegalMove(piece.position, boardState)) {

          BoardStateBone virtualState = boardState.cloneBones();
          virtualState.movePieceTo(piece.position, legalMove);

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
        BoardStateBone boardState}) {
    //Bishop, 1/2Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      if (_getPossibleLine(
        boardState: boardState,
        stopOnFirst: true,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Bishop, PieceType.Queen], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
        //startingColor: requestingPlayer,
      ).length >
          0) {
        return true;
      }
    }

    //print("I got past Bishop in tile covered");

    //Rook, 2/2 Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 1)) {
      if (_getPossibleLine(
        boardState: boardState,
        stopOnFirst: true,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Rook, PieceType.Queen], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
        //startingColor: requestingPlayer,
      ).length >
          0) {
        return true;
      }
    }

   // print("I got past rook in tile covered");

    //King
    for (Direction direction in Direction.values) {
      if (_getPossibleStep(
        boardState: boardState,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.King], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      ).length >
          0) {
        return true;
      }
    }

   // print("I got past King in tile covered");

    //Knight
    for (List<Direction> directions in (_directionListKnight + _directionListKnight2)) {
      if (_getComplexStep(
        boardState: boardState,
        directions: directions,
        //startingColor: requestingPlayer,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Knight], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      ).length >
          0) {
        return true;
      }
    }

    //Pawns
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      List<String> possMoves = _getPossibleStep(
        boardState: boardState,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Pawn], requestingPlayer: requestingPlayer),
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

   // print("I got past Knight in tile covered");

    return false;
  }

  static Function _canMoveOn(PlayerColor requestingPlayer, BoardStateBone boardState,
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
            boardState: boardState,
            toBeCheckedTile: toBeCheckedTile,
            requestingPlayer: requestingPlayer)) {
          return false;
        }
      }
      return result;
    };
  }

  ///Returns true if given Tile is occupied by one of the given PieceTypes of opposing PlayerColor
  static Function _occupiedBy(
      {BoardStateBone boardState,
      List<PieceType> typesToLookFor,
      PlayerColor requestingPlayer}) {
    return (String toBeCheckedTile, ) {
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

  static List<String> _getComplexStep({BoardStateBone boardState, List<Direction> directions, String startingTile, bool func(String tile), PlayerColor startingColor}) {
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

  static List<String> _getPossibleLine(
      {BoardStateBone boardState, Direction direction, String startingTile, bool func(String tile), bool stopOnFirst = false, PlayerColor startingColor}) {
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

  static _getPossibleStep(
      {BoardStateBone boardState,
      Direction direction,
      String startingTile,
      bool func(String tile),
      bool canTake = true,
      bool canMoveWithoutTake = true,
      PlayerColor twoStepWorkaroundPlayerColor}) {
    twoStepWorkaroundPlayerColor ??=
        boardState.pieces[startingTile]?.playerColor;
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
