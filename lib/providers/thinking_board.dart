import 'package:flutter/foundation.dart';

import '../models/piece.dart';

class ThinkingBoard with ChangeNotifier{
  
  ThinkingBoard();
  
  //enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
  
  List<String> getLegalMove(String selectedTile, Piece piece){
    switch (piece.pieceType){
      case PieceType.Pawn:
        return _legalMovesPawn(piece.playerColor);
      case PieceType.Rook:
        return _legalMovesRook(piece.playerColor);
      case PieceType.Knight:
      return _legalMovesKnight(piece.playerColor);
      case PieceType.Bishop:
        return _legalMovesBishop(piece.playerColor);
      case PieceType.King:
        return _legalMovesKing(piece.playerColor);
      case PieceType.Queen:
        return _legalMovesQueen(piece.playerColor);



    }
    }


    List<String> _

    List<String> _legalMovesPawn(PlayerColor playerColor){
      
    }

    List<String> _legalMovesRook(PlayerColor playerColor){

    }

    List<String> _legalMovesKnight(PlayerColor playerColor){

    }

    List<String> _legalMovesBishop(PlayerColor playerColor){

    }

    List<String> _legalMovesKing(PlayerColor playerColor){

    }

    List<String> _legalMovesQueen(PlayerColor playerColor){

    }

  
  void updateStatus(){

  }
}