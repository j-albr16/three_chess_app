import 'dart:ui';

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

    List<String> _getMovesInDirection(){

  }

    // Direction must be relative to currentColor for this to Work, need to make a make relative wrapper, possible in Directions

    List<String> _movesDirection (String StartingTile, Direction direction){
    
    }

    List<String> _movesOneDirection (String StartingTile, Direction direction, bool canTake) {
    
    }

    List<String> _LShape (){

    }

    List<String> _movesKnightDirection (String StartingTile){
      List<String> possMoves = [];

      for(int i = 0; i < 8; i++){
        List<String> adjecTiles = null ; // TODO MAKE L SHAPE
        for(String adjecTile in adjecTiles) {
          if (_pieces.firstWhere((element) => element.position == adjecTile,
              orElse: null) == null) { //Check for Piece
            possMoves.add(adjecTile);
            possMoves.addAll(_movesKnightDirection(adjecTile));
          }
          else
          if (_pieces.firstWhere((element) => element.position == adjecTile &&
              element.playerColor != currentColor, orElse: null) ==
              null) { //If theres a piece, check if enemy Piece (takeable)
            possMoves.add(adjecTile);
          }
        }
      }
    }


    List<String> _legalMovesPawn(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top, onlyOne: true, oneMoveTake: false));

      return possibleMoves;
    }

    List<String> _legalMovesRook(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.left));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.right));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottom));

      return possibleMoves;
    }

    List<String> _legalMovesKnight(PlayerColor playerColor, String selectedTile){

    }

    List<String> _legalMovesBishop(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomRight));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomLeft));

      return possibleMoves;
    }

    List<String> _legalMovesKing(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.left, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.right, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottom, onlyOne: true));
//
//
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomRight, onlyOne: true));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomLeft, onlyOne: true));

      return possibleMoves;
    }

    List<String> _legalMovesQueen(PlayerColor playerColor, String selectedTile){
      List<String> possibleMoves = [];
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.left));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.right));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.top));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottom));
//
//
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.topRight));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.leftTop));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomRight));
//      possibleMoves.addAll(_getMovesInDirection(selectedTile, Direction.bottomLeft));

      return possibleMoves;
    }

  
  void updateStatus(){

  }


}