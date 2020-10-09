import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/player_provider.dart';

import '../models/piece.dart';
import '../data/board_data.dart';
import '../models/enums.dart';


class ThinkingBoard with ChangeNotifier {
  //Get methods
  Piece _getPiece(String tile, BuildContext context){
    List<Piece> pieces = _getPieces(context);
    return pieces.firstWhere((e) => e.position == tile, orElse: () => null);
  }
  List<Piece> _getPieces(BuildContext context){
    return Provider
        .of<PieceProvider>(context, listen: false)
        .pieces;
  }
  PlayerColor _getPlayerColor(String pieceId, BuildContext context) {
    Piece piece = _getPiece(pieceId, context);
    return piece?.playerColor;
  }

  PlayerColor _getCurrentColor(context){
    return Provider.of<PlayerProvider>(context, listen: false).currentPlayer;
  }

  //constructor
  ThinkingBoard();

  //enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}

  List<String> getLegalMove(String selectedTile, Piece piece, BuildContext context) {
    switch (piece.pieceType) {
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
  }

  //Validating movabilty of a tile
  bool _canMoveOn(String tile, List<Piece> pieces, PlayerColor myColor, BuildContext context){
    bool result = false;
    Piece piece = pieces.firstWhere((e) => e.position == tile, orElse: () => null);
    if(piece == null){
      result = true;
    }
    else if(piece.playerColor != myColor){
      result = null;
    }

    return result;
  }

  void thinkOneDirection(List<String> myList, Direction direction, String currTile, BuildContext context ){
    List<String> nextTile = BoardData.adjacentTiles[currTile]?.getRelativeEnum(direction, _getCurrentColor(context), BoardData.sideData[currTile] );
      if(nextTile.isNotEmpty){
        for(int i = 0; i < nextTile.length; i++){
          _oneDirection(myList, direction, nextTile[i], context);
        }
      }

  }

  void thinkOneMove(List<String> myList, Direction direction, String currTile, BuildContext context, {bool canTake = true, canMoveWithoutTake = true}){
    List<String> nextTile = BoardData.adjacentTiles[currTile]?.getRelativeEnum(direction, _getCurrentColor(context), BoardData.sideData[currTile] );
    if(nextTile != null){
      for(String thisTile in nextTile){
        bool canI = _canMoveOn(thisTile, _getPieces(context), _getPlayerColor(thisTile, context), context);
        //Is someTile legal
        if(canI == true && canMoveWithoutTake){ //if tile is empty
          //yes: add to result
          myList.add(thisTile);
          // if legal and not a take --> result.addAll(thinkOneStep)
        }
        else if(canI == null && canTake){ //if tile has enemy Piece && taking is enabled (default = true)
          myList.add(thisTile);
        }

      }
    }
  }

  void _oneDirection(List<String> myList, Direction direction, String tile, BuildContext context){
    bool canI = _canMoveOn(tile, _getPieces(context), _getPlayerColor(tile, context), context);
    //Is someTile legal
    if(canI == true){ //if tile is empty
      //yes: add to result
      myList.add(tile);
      thinkOneDirection(myList, direction, tile, context);
      // if legal and not a take --> result.addAll(thinkOneStep)
    }
    else if(canI == null){ //if tile has enemy Piece
      myList.add(tile);
    }


      //no: nothing
  }
  
  List<String> multipleEnum(List<String> myList, List<Direction> directionList, String startTile, context){
    List<String> result = [];
    List<String> nextTiles = BoardData.adjacentTiles[startTile].getRelativeEnum(directionList[0], _getCurrentColor(context), BoardData.sideData[startTile]);
    for(String thisTile in nextTiles){
      _stackEnumCalls(result, directionList.sublist(1), thisTile, context);
    }
  }
  
  void _stackEnumCalls(List<String> myList, List<Direction> directionList, String startTile, context){
    if(directionList.length == 1){
      for(String thisTile in BoardData.adjacentTiles[startTile].getRelativeEnum(directionList[0], _getCurrentColor(context), BoardData.sideData[startTile])){
        if (_canMoveOn(thisTile, _getPieces(context), _getCurrentColor(context), context)) {
          myList.add(thisTile);
        }
      }
    }
    else{
      for(String thisTile in BoardData.adjacentTiles[startTile].getRelativeEnum(directionList[0], _getCurrentColor(context), BoardData.sideData[startTile])){
        _stackEnumCalls(myList, directionList.sublist(1), thisTile, context);
      }
    }
  }

  List<String> _legalMovesPawn(PlayerColor playerColor, String selectedTile,
      context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> directionsTake = [Direction.topRight, Direction.leftTop];
    List<Direction> directionsMove = [Direction.topRight, Direction.leftTop];
    //Directions relative to board side
    List<Direction> possibleDirectionsTake = directionsTake.map((e) => Directions.makeRelativeEnum(e, playerColor, BoardData.sideData[selectedTile])).toList();
    List<Direction> possibleDirectionsMove = directionsTake.map((e) => Directions.makeRelativeEnum(e, playerColor, BoardData.sideData[selectedTile])).toList();
    //Searching all Directions after each other for legal Moves
    possibleDirectionsTake.forEach((element) {
      thinkOneMove(allLegalMoves, element, selectedTile ,context, canTake: true, canMoveWithoutTake: true);
    });
    possibleDirectionsMove.forEach((element) {
      thinkOneMove(allLegalMoves, element, selectedTile ,context, canTake: false, canMoveWithoutTake: false);
    });

    return allLegalMoves;
  }

  List<String> _legalMovesRook(PlayerColor playerColor, String selectedTile,
      context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [Direction.top, Direction.right, Direction.bottom, Direction.left];
    //Directions relative to board side
    List<Direction> possibleDirections = possibleDirectionsAbsolut.map((e) => Directions.makeRelativeEnum(e, playerColor, BoardData.sideData[selectedTile]));
    //Searching all Directions after each other for legal Moves
    possibleDirections.forEach((element) {
      thinkOneDirection(allLegalMoves, element, selectedTile ,context);
    });

    return allLegalMoves;
  }

  List<String> _legalMovesKnight(PlayerColor playerColor, String selectedTile, context) {
   List<String> legalMoves = [];
   for(int i = 0; i < 4; i++){
     for(int j = 0; j < 2; j++){
       int firstDir = ((i+1)*2)%8;
       int secondDir = (((firstDir+2)%8)+j*(4))%8;
      multipleEnum(legalMoves,[Direction.values[firstDir],Direction.values[firstDir],Direction.values[secondDir],], selectedTile, context);
     }
   }
   return legalMoves;
  }

  List<String> _legalMovesBishop(PlayerColor playerColor, String selectedTile,
      context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [Direction.topRight, Direction.bottomRight, Direction.bottomLeft, Direction.leftTop];
    //Directions relative to board side
    List<Direction> possibleDirections = possibleDirectionsAbsolut.map((e) => Directions.makeRelativeEnum(e, playerColor, BoardData.sideData[selectedTile])).toList();
    //Searching all Directions after each other for legal Moves
    possibleDirections.forEach((element) {
      thinkOneDirection(allLegalMoves, element, selectedTile ,context);
    });
    //print
    print(allLegalMoves.toString());

    return allLegalMoves;
  }

  List<String> _legalMovesKing(PlayerColor playerColor, String selectedTile,
      context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [Direction.top, Direction.right, Direction.bottom, Direction.left, Direction.topRight, Direction.bottomRight, Direction.bottomLeft, Direction.leftTop];
    //Directions relative to board side
    List<Direction> possibleDirections = possibleDirectionsAbsolut.map((e) => Directions.makeRelativeEnum(e, playerColor, BoardData.sideData[selectedTile])).toList();
    //Searching all Directions after each other for legal Moves
    possibleDirections.forEach((element) {
      thinkOneMove(allLegalMoves, element, selectedTile ,context, canTake: true, canMoveWithoutTake: true);
    });

    return allLegalMoves;
  }

  List<String> _legalMovesQueen(PlayerColor playerColor, String selectedTile,
      context) {
    //List of all possible Directions
    List<String> allLegalMoves = [];
    //Absolute direction
    List<Direction> possibleDirectionsAbsolut = [Direction.top, Direction.right, Direction.bottom, Direction.left, Direction.topRight, Direction.bottomRight, Direction.bottomLeft, Direction.leftTop];
    //Directions relative to board side
    List<Direction> possibleDirections = possibleDirectionsAbsolut.map((e) => Directions.makeRelativeEnum(e, playerColor, BoardData.sideData[selectedTile])).toList();
    //Searching all Directions after each other for legal Moves
    possibleDirections.forEach((element) {
      thinkOneDirection(allLegalMoves, element, selectedTile ,context);
    });

    return allLegalMoves;
  }


  void updateStatus() {

  }

  bool isValid(BuildContext context, String tile,
      PlayerColor playerColor) {
    List<Piece> pieces = Provider
        .of<PieceProvider>(context, listen: false)
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