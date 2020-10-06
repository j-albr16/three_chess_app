import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:three_chess/providers/player_provider.dart';
import 'package:three_chess/providers/thinking_board.dart';
import 'tile_provider.dart';
import '../models/enums.dart';
import '../models/piece.dart';

class TileSelect with ChangeNotifier{
  bool isMoveState = false;
  String _selectedTile;
  String get selectedTile{
    return _selectedTile;
  }

  void set selectedTile(String newTile){
    if(newTile != _selectedTile) {
      _selectedTile = newTile;
    print("selected Tile: " + _selectedTile.toString());
    notifyListeners();
    }
  }

  void changeMoveState(String newTile, BuildContext context){
    PieceProvider pieceProv = Provider.of<PieceProvider>(context, listen: false);
    List<Piece> pieces  = pieceProv.pieces;
    Piece selectedPiece = pieces.firstWhere((e) => e.position == newTile, orElse: () => null);
    PlayerColor currPlayer = Provider.of<PlayerProvider>(context, listen: false).currentPlayer;

    ThinkingBoard thinkingBoard = Provider.of<ThinkingBoard>(context, listen: false);
    if(!isMoveState){
      print('MoveState: OFF');
      if(selectedPiece?.playerColor == currPlayer){
        isMoveState = true;
      }
    }
    else { // isMoveState = true
      Piece piece = pieces.firstWhere((e) => e.position == selectedTile);
      if (piece.pieceType == PieceType.Bishop){
        thinkingBoard.getLegalMove(selectedTile, piece, context);
      }
      print('MoveState: ON');
      if(true){ // thinkingBoard.getLegalMoves(selectedTile, selectedPiece, pieces).contains(newTile)
        pieceProv.movePieceTo(selectedTile, newTile);
        thinkingBoard.updateStatus();
      }
      isMoveState = false;
    }
  }

  void setByPosition(BuildContext context, Offset point){ //Dont!
    String hitTile = null;
    MapEntry hitPath = Provider.of<TileProvider>(context, listen: false).paths.entries.firstWhere((e) => e.value.contains(point), orElse: () => null);
    if(hitPath != null){
      hitTile = hitPath.key;
    }
    changeMoveState(hitTile, context);
    selectedTile = hitTile;
  }

  TileSelect();

  Point _toPoint(Offset offset) {
    return Point(offset.dx, offset.dy);
  }



}