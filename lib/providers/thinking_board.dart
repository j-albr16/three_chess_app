import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/tile_provider.dart';
import 'package:three_chess/providers/player_provider.dart';

import '../models/piece.dart';
import '../data/board_data.dart';
import '../models/enums.dart';

class ThinkingBoard with ChangeNotifier {
  List<List<Direction>> _directionListKnight;
  List<List<Direction>> _directionListKnight2;

  List<List<Direction>> get directionListKnight {
    if (_directionListKnight == null) {
      _directionListKnight = [];
      List<Direction> firstDir = [Direction.top, Direction.left, Direction.bottom, Direction.right];
      List<List<Direction>> secondDir = [
        [Direction.left, Direction.right],
        [Direction.top, Direction.bottom]
      ];
      int i = 0;
      for (Direction firstDire in firstDir) {
        for (Direction secondDire in secondDir[i % 2]) {
          _directionListKnight.add([secondDire, firstDire, firstDire]);
        }
        i++;
      }
    }
    return _directionListKnight;
  }

  List<List<Direction>> get directionListKnight2 {
    if (_directionListKnight2 == null) {
      _directionListKnight2 = [];
      List<Direction> firstDir = [Direction.top, Direction.left, Direction.bottom, Direction.right];
      List<List<Direction>> secondDir = [
        [Direction.left, Direction.right],
        [Direction.top, Direction.bottom]
      ];
      int i = 0;
      for (Direction firstDire in firstDir) {
        for (Direction secondDire in secondDir[i % 2]) {
          _directionListKnight2.add([firstDire, firstDire, secondDire]);
        }
        i++;
      }
    }
    return _directionListKnight2;
  }

  //Get methods
  Piece _getPiece(String tile, BuildContext context) {
    return Provider.of<PieceProvider>(context, listen: false).pieces[tile];
  }

  Map<String, Piece> _getPieces(BuildContext context) {
    return Provider.of<PieceProvider>(context, listen: false).pieces;
  }

  PlayerColor _getPlayerColor(String pieceId, BuildContext context) {
    Piece piece = _getPiece(pieceId, context);
    return piece?.playerColor;
  }

  PlayerColor _getCurrentColor(context) {
    return Provider.of<PlayerProvider>(context, listen: false).currentPlayer;
  }

  //constructor
  ThinkingBoard();

  //enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}

  List<String> getLegalMove(String selectedTile, Piece piece, BuildContext context) {
    switch (piece?.pieceType) {
      //Should not be null, but we dont like errors (talking to my self rn)
      case PieceType.Pawn:
        return _legalMovesPawn(piece.playerColor, selectedTile, context);
      case PieceType.Rook:
        return _legalMovesRook(piece.playerColor, selectedTile, context);
      case PieceType.Knight:
        return _legalMovesKnight(piece.playerColor, selectedTile, context);
      case PieceType.Bishop:
        return _legalMovesBishop(piece.playerColor, selectedTile, context);
      case PieceType.King:
        return _legalMovesKing(piece.playerColor, selectedTile, context);
      case PieceType.Queen:
        return _legalMovesQueen(piece.playerColor, selectedTile, context);
    }
    return [];
  }

  _legalMovesPawn(PlayerColor pieceColor, String selectedTile, context) {
    List<String> allLegalMoves = [
      ...getPossibleStep(
        context,
        startingTile: selectedTile,
        direction: Direction.topRight,
        func: canMoveOn(context, _getCurrentColor(context)),
        canMoveWithoutTake: false,
      ),
      ...getPossibleStep(
        context,
        startingTile: selectedTile,
        direction: Direction.leftTop,
        func: canMoveOn(context, _getCurrentColor(context)),
        canMoveWithoutTake: false,
      ),
      ...getPossibleStep(
        context,
        startingTile: selectedTile,
        direction: Direction.top,
        func: canMoveOn(context, _getCurrentColor(context)),
        canMoveWithoutTake: true,
        canTake: false,
      ),
      if (_getPiece(selectedTile, context)?.didMove == false)
        ...getPossibleStep(
          context,
          startingTile: BoardData.adjacentTiles[selectedTile].top[0],
          direction: Direction.top,
          func: canMoveOn(context, _getCurrentColor(context)),
          canMoveWithoutTake: true,
          canTake: false,
          twoStepWorkaroundPlayerColor: pieceColor,
        ),
    ];
    if (TileProvider.numCoordinatesOf[BoardData.sideData[selectedTile]].indexOf(selectedTile.substring(1)) == 3) {
      String possPassent = Provider.of<PieceProvider>(context, listen: false).enPassentCanidate[BoardData.sideData[selectedTile]];
      if ([BoardData.adjacentTiles[selectedTile].left[0], BoardData.adjacentTiles[selectedTile].right[0]].contains(possPassent)) {
        allLegalMoves.add(BoardData.adjacentTiles[possPassent].bottom[0]);
      }
    }
    return allLegalMoves;
  }

  _legalMovesRook(PlayerColor pieceColor, selectedTile, context) {
    List<String> allLegalMoves = [];
    for (Direction direction in Direction.values.where((element) => element.index % 2 != 0)) {
      allLegalMoves += getPossibleLine(
        context,
        direction: direction,
        func: canMoveOn(context, _getCurrentColor(context)),
        startingTile: selectedTile,
      );
    }
    return allLegalMoves;
  }

  _legalMovesKnight(PlayerColor pieceColor, selectedTile, context) {
    List<String> allLegalMoves = [];
    for (List<Direction> directions in (directionListKnight + directionListKnight2)) {
      allLegalMoves += getComplexStep(
        context,
        directions: directions,
        func: canMoveOn(context, _getCurrentColor(context)),
        startingTile: selectedTile,
      );
    }
    return allLegalMoves.toSet().toList();
  }

  _legalMovesBishop(PlayerColor pieceColor, selectedTile, context) {
    List<String> allLegalMoves = [];
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      allLegalMoves += getPossibleLine(
        context,
        direction: direction,
        func: canMoveOn(context, _getCurrentColor(context)),
        startingTile: selectedTile,
      );
    }
    return allLegalMoves;
  }

  _legalMovesKing(PlayerColor pieceColor, selectedTile, context) {
    List<String> allLegalMoves = [];
    for (Direction direction in Direction.values) {
      allLegalMoves += getPossibleStep(
        context,
        direction: direction,
        func: canMoveOn(context, _getCurrentColor(context), checkAttacked: true),
        startingTile: selectedTile,
      );
    }
    //Castling check
    if (!_getPiece(selectedTile, context).didMove) {
      Map<String, Piece> rooks = {
        "left": _getPiece(
            TileProvider.getEqualCoordinate("A1", _getCurrentColor(context), Provider.of<TileProvider>(context, listen: false).tiles),
            context),
        "right": _getPiece(
            TileProvider.getEqualCoordinate("H1", _getCurrentColor(context), Provider.of<TileProvider>(context, listen: false).tiles),
            context)
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
          if (_getPieces(context)[BoardData.adjacentTiles[selectedTile].left[0]] == null &&
              _getPieces(context)[BoardData.adjacentTiles[BoardData.adjacentTiles[selectedTile].left[0]].left[0]] == null &&
              _getPieces(context)[BoardData
                      .adjacentTiles[BoardData.adjacentTiles[BoardData.adjacentTiles[selectedTile].left[0]].left[0]].left[0]] ==
                  null) {
            //IF WE WANT MORE CASTELING OPTIONS ADD HERE
            allLegalMoves.add(BoardData.adjacentTiles[BoardData.adjacentTiles[selectedTile].left[0]].left[0]);
          }
        } else if (pieceEntry.key == "right") {
          if (_getPieces(context)[BoardData.adjacentTiles[selectedTile].right[0]] == null &&
              _getPieces(context)[BoardData.adjacentTiles[BoardData.adjacentTiles[selectedTile].right[0]].right[0]] == null) {
            //IF WE WANT MORE CASTELING OPTIONS ADD HERE
            allLegalMoves.add(BoardData.adjacentTiles[BoardData.adjacentTiles[selectedTile].right[0]].right[0]);
          }
        }
      }
    }

    return allLegalMoves;
  }

  _legalMovesQueen(PlayerColor pieceColor, selectedTile, context) {
    List<String> allLegalMoves = [];
    for (Direction direction in Direction.values) {
      allLegalMoves += getPossibleLine(
        context,
        direction: direction,
        func: canMoveOn(context, _getCurrentColor(context)),
        startingTile: selectedTile,
      );
    }
    return allLegalMoves;
  }

  /// Returns true if given Tile is Covered by Piece that is not the requestingPlayer
  bool isTileCovered(context, {String toBeCheckedTile, PlayerColor requestingPlayer}) {
    //Bishop, 1/2Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      if (getPossibleLine(
            context,
            stopOnFirst: true,
            direction: direction,
            func: occupiedBy(context, pieceTypes: [PieceType.Bishop, PieceType.Queen], requestingPlayer: requestingPlayer),
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
            context,
            stopOnFirst: true,
            direction: direction,
            func: occupiedBy(context, pieceTypes: [PieceType.Rook, PieceType.Queen], requestingPlayer: requestingPlayer),
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
            context,
            direction: direction,
            func: occupiedBy(context, pieceTypes: [PieceType.King], requestingPlayer: requestingPlayer),
            startingTile: toBeCheckedTile,
          ).length >
          0) {
        return true;
      }
    }

    print("I got past King in tile covered");

    //Knight
    for (List<Direction> directions in (directionListKnight + directionListKnight2)) {
      if (getComplexStep(
            context,
            directions: directions,
            //startingColor: requestingPlayer,
            func: occupiedBy(context, pieceTypes: [PieceType.Knight], requestingPlayer: requestingPlayer),
            startingTile: toBeCheckedTile,
          ).length >
          0) {
        return true;
      }
    }

    //Pawns
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      List<String> possMoves = getPossibleStep(
        context,
        direction: direction,
        func: occupiedBy(context, pieceTypes: [PieceType.Pawn], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      );

      for (String move in possMoves) {
        if (BoardData.adjacentTiles[move]
                .getRelativeEnum(Direction.leftTop, _getPiece(move, context).playerColor, BoardData.sideData[toBeCheckedTile])
                .contains(toBeCheckedTile) ||
            BoardData.adjacentTiles[move]
                .getRelativeEnum(Direction.topRight, _getPiece(move, context).playerColor, BoardData.sideData[toBeCheckedTile])
                .contains(toBeCheckedTile)) {
          return true;
        }
      }
    }

    print("I got past Knight in tile covered");

    return false;
  }

  ///Returns all possible tiles in one Direction till Condition is meet.
  ///if Condition returns null algorithm stops but still adds last checked tile to result
  List<String> getPossibleLine(context,
      {Direction direction, String startingTile, bool func(String tile), bool stopOnFirst = false, PlayerColor startingColor}) {
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
          if (stopOnFirst && _getPiece(tile, context) == null) {
            _nextStep(allMoves, tile);
          }
        }
      }
    }

    List<String> resultList = [];
    _nextStep(resultList, startingTile);
    return resultList;
  }

  ///Returns all possible tiles one in given Direction that meet given Condition.
  ///if Condition returns null algorithm stops but still adds last checked tile to result
  List<String> getPossibleStep(context,
      {Direction direction,
      String startingTile,
      bool func(String tile),
      bool canTake = true,
      bool canMoveWithoutTake = true,
      PlayerColor twoStepWorkaroundPlayerColor}) {
    twoStepWorkaroundPlayerColor ??= _getPiece(startingTile, context).playerColor;
    List<String> nextTiles = BoardData.adjacentTiles[startingTile]
        ?.getRelativeEnum(direction, twoStepWorkaroundPlayerColor, BoardData.sideData[startingTile]);
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

  ///Returns all possible tiles at given Direction path when Condition is meet.
  ///if Condition returns null algorithm stops but still adds last checked tile to result
  List<String> getComplexStep(context,
      {List<Direction> directions, String startingTile, bool func(String tile), PlayerColor startingColor}) {
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

  ///Returns true if given Tile is empty,
  ///null when its occupied by a player unequal to requestingPlayer
  ///and false when its occupied by requestingPlayer
  Function canMoveOn(context, PlayerColor requestingPlayer, {bool checkAttacked = false}) {
    return (String toBeCheckedTile) {
      bool result = false;
      Piece piece = _getPiece(toBeCheckedTile, context);
      if (piece == null) {
        result = true;
      } else if (piece.playerColor != requestingPlayer) {
        result = null;
      }
      if (checkAttacked && (result != false)) {
        if (isTileCovered(context, toBeCheckedTile: toBeCheckedTile, requestingPlayer: requestingPlayer)) {
          return false;
        }
      }
      return result;
    };
  }

  ///Returns true if given Tile is occupied by one of the given PieceTypes of opposing PlayerColor
  Function occupiedBy(context, {List<PieceType> pieceTypes, PlayerColor requestingPlayer}) {
    return (String toBeCheckedTile) {
      bool result = false;
      Piece piece = _getPiece(toBeCheckedTile, context);
      if (piece != null) {
        if (piece.playerColor != requestingPlayer && pieceTypes.contains(piece.pieceType)) {
          result = true;
          print("occupy says yes with ${piece.pieceType} when ${pieceTypes[0]} at $toBeCheckedTile of ${piece.playerColor}");
        }
      }
      return result;
    };
  }
}
