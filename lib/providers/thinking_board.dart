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

  List<String> getLegalMove(String selectedTile, Piece piece, BuildContext context) {
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

  void thinkOneStep(List<String> myList, Direction direction, String currTile, BuildContext context ){
    List<String> nextTile = BoardData.adjacentTiles[currTile].getFromEnum(direction); //NO RELATIVE ENUM YET
      for(String thisTile in nextTile){
        oneDirection(myList, direction, thisTile, context);
      }

  }

  bool canMoveOn(String tile, List<Piece> pieces, PlayerColor myColor, BuildContext context){
    bool result = false;
    Piece piece = pieces.singleWhere((e) => e.position == tile, orElse: () => null);
    if(piece == null){
      result = true;
     }
    else if(piece.playerColor != myColor){
      result = null;
    }

    return result;
  }

  void oneDirection(List<String> myList, Direction direction, String tile, BuildContext context){
    bool canI = canMoveOn(tile, _getPieces(context), _getPlayerColor(tile, context), context);
    //Is someTile legal
    if(canI == true){
      //yes: add to result
      myList.add(tile);
      thinkOneStep(myList, direction, tile, context);
      // if legal and not a take --> result.addAll(thinkOneStep)
    }
    else if(canI == null){
      myList.add(tile);
    }


      //no: nothing
  }

  Piece _getPiece(String tile, BuildContext context){
   List<Piece> pieces = _getPieces(context);
    return pieces.firstWhere((e) => e.position == tile, orElse: () => null);
  }
  List<Piece> _getPieces(BuildContext context){
    return Provider
        .of<PieceProvider>(context, listen: false)
        .pieces;
  }
  PlayerColor _getPlayerColor(String tile, BuildContext context) {
    Piece piece = _getPiece(tile, context);
    return piece?.playerColor;
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
    List<String> allLegalMoves = [];
    List<Direction> possibleDirections = [Direction.topRight, Direction.bottomRight, Direction.bottomLeft, Direction.leftTop];

    possibleDirections.forEach((element) {
      thinkOneStep(allLegalMoves, element, selectedTile ,context);
    });
    print(allLegalMoves.toString());
    return allLegalMoves;
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