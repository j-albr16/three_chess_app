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
  //Get methods
  Piece _getPiece(String tile, BuildContext context) {
    List<Piece> pieces = _getPieces(context);
    return pieces.firstWhere((e) => e.position == tile, orElse: () => null);
  }

  List<Piece> _getPieces(BuildContext context) {
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

  //Validating movabilty of a tile
  bool _canMoveOn(String tile, List<Piece> pieces, PlayerColor myColor, BuildContext context) {
    bool result = false;
    Piece piece = pieces.firstWhere((e) => e.position == tile, orElse: () => null);
    if (piece == null) {
      result = true;
    } else if (piece.playerColor != myColor) {
      result = null;
    }

    return result;
  }

  void thinkOneDirection(List<String> myList, Direction direction, String currTile, PlayerColor startingColor, BuildContext context) {
    List<String> nextTile = BoardData.adjacentTiles[currTile]?.getRelativeEnum(direction, startingColor, BoardData.sideData[currTile]);
    if (nextTile != null) {
      if (nextTile.isNotEmpty) {
        for (int i = 0; i < nextTile.length; i++) {
          _oneDirection(myList, direction, nextTile[i], startingColor, context);
        }
      }
    }
  }

  void thinkOneMove(List<String> myList, Direction direction, String currTile, BuildContext context,
      {bool canTake = true, canMoveWithoutTake = true}) {
    List<String> nextTile =
        BoardData.adjacentTiles[currTile]?.getRelativeEnum(direction, _getCurrentColor(context), BoardData.sideData[currTile]);
    if (nextTile != null) {
      for (String thisTile in nextTile) {
        bool canI = _canMoveOn(thisTile, _getPieces(context), _getCurrentColor(context), context);
        //Is someTile legal
        if (canI == true && canMoveWithoutTake) {
          //if tile is empty
          //yes: add to result
          myList.add(thisTile);
          // if legal and not a take
        } else if (canI == null && canTake) {
          //if tile has enemy Piece && taking is enabled (default = true)
          myList.add(thisTile);
        }
      }
    }
  }

  void _oneDirection(List<String> myList, Direction direction, String tile, PlayerColor startingColor, BuildContext context) {
    bool canI = _canMoveOn(tile, _getPieces(context), _getCurrentColor(context), context);
    //Is someTile legal
    if (canI == true) {
      //if tile is empty
      //yes: add to result
      myList.add(tile);
      thinkOneDirection(myList, direction, tile, startingColor, context);
      // if legal and not a take --> result.addAll(thinkOneStep)
    } else if (canI == null) {
      //if tile has enemy Piece
      myList.add(tile);
    }

    //no: nothing
  }

  List<String> multipleEnum(List<String> myList, List<Direction> directionList, String startTile, context) {
    List<String> result = [];
    List<String> nextTiles =
        BoardData.adjacentTiles[startTile].getRelativeEnum(directionList[0], _getCurrentColor(context), BoardData.sideData[startTile]);
    for (String thisTile in nextTiles) {
      _stackEnumCalls(result, directionList.sublist(1), thisTile, context);
    }
  }

  void _stackEnumCalls(List<String> myList, List<Direction> directionList, String startTile, context) {
    if (directionList.length == 1) {
      for (String thisTile in BoardData.adjacentTiles[startTile]
          .getRelativeEnum(directionList[0], _getCurrentColor(context), BoardData.sideData[startTile])) {
        if (_canMoveOn(thisTile, _getPieces(context), _getCurrentColor(context), context) != false) {
          myList.add(thisTile);
        }
      }
    } else {
      for (String thisTile in BoardData.adjacentTiles[startTile]
          .getRelativeEnum(directionList[0], _getCurrentColor(context), BoardData.sideData[startTile])) {
        _stackEnumCalls(myList, directionList.sublist(1), thisTile, context);
      }
    }
  }

  List<String> _legalMovesPawn(PlayerColor playerColor, String selectedTile, context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction, sd
    List<Direction> directionsTake = [Direction.topRight, Direction.leftTop];
    List<Direction> directionsMove = [Direction.top];
    //Searching all Directions after each other for legal Moves
    directionsTake.forEach((element) {
      thinkOneMove(allLegalMoves, element, selectedTile, context, canTake: true, canMoveWithoutTake: false);
    });
    directionsMove.forEach((element) {
      thinkOneMove(allLegalMoves, element, selectedTile, context, canTake: false, canMoveWithoutTake: true);
    });

    return allLegalMoves;
  }

  List<String> _legalMovesRook(PlayerColor playerColor, String selectedTile, context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [Direction.top, Direction.right, Direction.bottom, Direction.left];
    //Directions relative to board side
    //Searching all Directions after each other for legal Moves
    possibleDirectionsAbsolut.forEach((element) {
      thinkOneDirection(allLegalMoves, element, selectedTile,
          Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((e) => e.id == selectedTile).side, context);
    });

    return allLegalMoves;
  }

  List<String> _legalMovesKnight(PlayerColor playerColor, String selectedTile, context) {
    List<String> legalMoves = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 2; j++) {
        int firstDir = ((i + 1) * 2) % 8;
        int secondDir = (((firstDir + 2) % 8) + j * (4)) % 8;
        multipleEnum(
            legalMoves,
            [
              Direction.values[firstDir],
              Direction.values[firstDir],
              Direction.values[secondDir],
            ],
            selectedTile,
            context);
      }
    }
    return legalMoves;
  }

  List<String> _legalMovesBishop(PlayerColor playerColor, String selectedTile, context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [Direction.topRight, Direction.bottomRight, Direction.bottomLeft, Direction.leftTop];
    //Directions relative to board side
    //Searching all Directions after each other for legal Moves
    possibleDirectionsAbsolut.forEach((element) {
      thinkOneDirection(allLegalMoves, element, selectedTile,
          Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((e) => e.id == selectedTile).side, context);
    });
    //print
    print(allLegalMoves.toString());

    return allLegalMoves;
  }

  List<String> _legalMovesKing(PlayerColor playerColor, String selectedTile, context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [
      Direction.top,
      Direction.right,
      Direction.bottom,
      Direction.left,
      Direction.topRight,
      Direction.bottomRight,
      Direction.bottomLeft,
      Direction.leftTop
    ];

    //Searching all Directions after each other for legal Moves
    possibleDirectionsAbsolut.forEach((element) {
      thinkOneMove(allLegalMoves, element, selectedTile, context, canTake: true, canMoveWithoutTake: true);
    });

    return allLegalMoves;
  }

  List<String> _legalMovesQueen(PlayerColor playerColor, String selectedTile, context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [
      Direction.top,
      Direction.right,
      Direction.bottom,
      Direction.left,
      Direction.topRight,
      Direction.bottomRight,
      Direction.bottomLeft,
      Direction.leftTop
    ];

    //Searching all Directions after each other for legal Moves
    possibleDirectionsAbsolut.forEach((element) {
      thinkOneDirection(allLegalMoves, element, selectedTile,
          Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((e) => e.id == selectedTile).side, context);
    });

    return allLegalMoves;
  }

  void updateStatus() {}
}
