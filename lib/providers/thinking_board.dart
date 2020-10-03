import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/enums.dart';
import '../models/piece.dart';
import '../data/board_data.dart';

class ThinkingBoard with ChangeNotifier{

  List<Piece> _pieces;
  PlayerColor currentColor;
  
  ThinkingBoard();
  
  //enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
  
  List<String> getLegalMoves(String selectedTile, Piece piece, List<Piece> pieces){
    _pieces = pieces;
    if (piece != null) {
      currentColor = piece?.playerColor;
      switch (piece.pieceType){
        case PieceType.Pawn:
          return _legalMovesPawn(piece.playerColor, selectedTile);
        case PieceType.Rook:
          return _legalMovesRook(piece.playerColor, selectedTile);
        case PieceType.Knight:
        return _legalMovesKnight(piece.playerColor, selectedTile);
        case PieceType.Bishop:
          return _legalMovesBishop(piece.playerColor, selectedTile);
        case PieceType.King:
          return _legalMovesKing(piece.playerColor, selectedTile);
        case PieceType.Queen:
          return _legalMovesQueen(piece.playerColor, selectedTile);
      }
    }
    return [];
    }

    // Direction must be relative to currentColor for this to Work, need to make a make relative wrapper, possible in Directions

    List<String> _getMovesInDirection(String startTile, Direction direction, {bool onlyOne = false, bool oneMoveTake = true}){
      //startTile == piece.position
      List<String> possibleMoves = [];
      List<String> nextTiles = BoardData.adjacentTiles[startTile].getFromEnum(direction);
      print("nextTiles: " + nextTiles.toString());
      bool oneMoveTakeWrapper(bool wrapped){
        bool result = true;
        oneMoveTake ? result = wrapped : result = true;
        return result;
      }

        if (!onlyOne) {
          for (String nextTile in nextTiles) {
            possibleMoves.addAll(_movesInDirection(nextTile, direction));
          }
        }
        else{
          for (String nextTile in nextTiles) {
            if (_pieces.firstWhere((e) => e.position == nextTile && e.playerColor == currentColor, orElse: null) == null) {
              possibleMoves?.add(nextTile);
            }
          }
        }
      print(possibleMoves.toString());
      return possibleMoves;
    }

    List<String> _movesInDirection(String currentTile, Direction direction){
    List<String> possibleMoves = [];
      List<String> nextTiles = BoardData.adjacentTiles[currentTile].getFromEnum(direction);

      possibleMoves.add(currentTile);

      if(nextTiles.isEmpty){
        return [];
      }
      else{
        for(String checkTile in nextTiles){
          if(_pieces.firstWhere((e) => e.position == checkTile, orElse: null)?.playerColor != currentColor){
            possibleMoves.add(checkTile);
          }
          else if(_pieces.firstWhere((e) => e.position == checkTile, orElse: null) == null){
            possibleMoves.addAll(_movesInDirection(checkTile, direction));
          }
        }
        return possibleMoves;
      }
    }


    List<String> _legalMovesPawn(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top, onlyOne: true, oneMoveTake: false));

      return possibleMoves;
    }

    List<String> _legalMovesRook(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.left));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.right));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottom));

      return possibleMoves;
    }

    List<String> _legalMovesKnight(PlayerColor playerColor, String selectedTile){

    }

    List<String> _legalMovesBishop(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomRight));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomLeft));

      return possibleMoves;
    }

    List<String> _legalMovesKing(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.left, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.right, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottom, onlyOne: true));


      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomRight, onlyOne: true));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomLeft, onlyOne: true));

      return possibleMoves;
    }

    List<String> _legalMovesQueen(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.left));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.right));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottom));


      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomRight));
      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomLeft));

      return possibleMoves;
    }

  
  void updateStatus(){

  }
}