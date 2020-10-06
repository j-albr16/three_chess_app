import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:provider/provider.dart';

import '../models/piece.dart';
import '../data/board_data.dart';
import '../models/enums.dart';

class ThinkingBoard with ChangeNotifier {

  ThinkingBoard();

  //enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}

  List<String> getLegalMove(String selectedTile, Piece piece,BuildContext context) {
    switch (piece.pieceType) {
      case PieceType.Pawn:
        return _legalMovesPawn(piece.playerColor);
      case PieceType.Rook:
        return _legalMovesRook(piece.playerColor);
      case PieceType.Knight:
        return _legalMovesKnight(piece.playerColor);
      case PieceType.Bishop:
        return _legalMovesBishop(piece.playerColor, selectedTile, context);
      case PieceType.King:
        return _legalMovesKing(piece.playerColor);
      case PieceType.Queen:
        return _legalMovesQueen(piece.playerColor);
    }
  }


  List<String> _legalMovesPawn(PlayerColor playerColor) {

  }

  List<String> _legalMovesRook(PlayerColor playerColor) {

  }

  List<String> _legalMovesKnight(PlayerColor playerColor) {

  }

  List<String> _legalMovesBishop(PlayerColor playerColor, String selectedTile,
      context) {
    //List of all possible Directions
    List<Direction> possibleDirections = [Direction.topRight, Direction.bottomRight, Direction.bottomLeft, Direction.leftTop];
    // List of all legal moves
    List<String> _legalMoves = [];
    //map with all current selected Tiles and directions
    Map<Direction, List<String>> lookAtTiles = {
      possibleDirections[0]: [selectedTile],
      possibleDirections[1]: [selectedTile],
      possibleDirections[2]: [selectedTile],
      possibleDirections[3]: [selectedTile]
    };
    // starting the loop... getting 4 notValid tiles the loop breaks. (+1 for every step over special tile)
    int i = 0;
    while (i < 4) {
      // going to the next Tile according to given direction
      lookAtTiles.forEach((key, value) {
       List<String> currentTile = lookAtTiles[key];
       List<String> nextTile = BoardData.adjacentTiles[value[0]].key;
       // checking whether you go to the next BoardThird
       if (BoardData.sideData[currentTile] != BoardData.sideData[nextTile]){
         // Changing Direction
         changeDirection(key, PieceType.Bishop, possibleDirections);
       }
        currentTile = nextTile;
      });

      // checking whether Tile is allowed or not
      lookAtTiles.forEach((key, value) {
        // first case where we dont have special field::....
        if (value.length == 1) {
          //entry remains if value is valid
          bool isV = isValid(context, value[0], playerColor);
          if (!isV) {
            //entry is removed if value is not valid
            // counter for not valid tiles is increased
            lookAtTiles.removeWhere((k, v) => v == value);
            i += 1;
          }
          // checks whether player color is not equal
          else if (isV == null){
            // if you can kill a piece also stop moving afterwards but this move is viable
            lookAtTiles.removeWhere((k, v) => v == value);
            i += 1;
            _legalMoves.add(value[0]);
          }
        }else{
          // if step over special tile one more not valid tile is expected
          i -= 1;
          value.forEach((element) {
            // iterate over all received tiles after special Tile split
            bool isVal = isValid(context, element, playerColor);
            if (isVal) {
              // if tile is valid add entry with this tile
              lookAtTiles.addEntries([MapEntry(key, [element])]);
              // ceck if you could kill the piece on the tile
            } else if (isVal == null){
              //you can move and kill the enemy piece but then you have to stop
              _legalMoves.add(element);
            }else{
              // else tile is not added but counter is increased
              i += 1;
            }
            lookAtTiles.remove(key);
          });
        }
      });
      // finally adding legal moves for all remaining entries
      lookAtTiles.forEach((key, value) {
        _legalMoves.add(value[0]);
      });
    }
    return _legalMoves;
  }

  List<String> _legalMovesKing(PlayerColor playerColor) {

  }

  List<String> _legalMovesQueen(PlayerColor playerColor) {

  }


  void updateStatus() {

  }

  bool isValid(BuildContext context, String tile,
      PlayerColor playerColor) {
    List<Piece> pieces = Provider
        .of<PieceProvider>(context)
        .pieces;
    //checks whether no piece is on this tile
    if (pieces.firstWhere((e) => e.position == tile, orElse: () => null) ==
        null) {
      return true;
    }
    //checks whether the piece has the same color
    else if (pieces.firstWhere((e) => e.position == tile,
        orElse: () => null).playerColor != playerColor) {
      return null;
    }
    //checks whether you are on the board
    else if (tile != null) {
      return true;
    } else {
      return false;
    }
  }

  Direction changeDirection(Direction direction, PieceType pieceType, List<Direction> possibleDirections){
    int index = possibleDirections.indexOf(direction);
    if(pieceType == PieceType.Bishop || pieceType == PieceType.Rook){
      index < 2 ? index += 2 : index -= 2 ;
    }
    return possibleDirections[index];
  }
}