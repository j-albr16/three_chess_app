import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:three_chess/providers/player_provider.dart';
import 'package:three_chess/providers/thinking_board.dart';
import 'tile_provider.dart';
import '../models/enums.dart';
import '../models/piece.dart';
import '../models/tile.dart';

class TileSelect with ChangeNotifier {
  bool isMoveState = false;
  String _selectedTile;
  String get selectedTile {
    return _selectedTile;
  }

  List<Tile> _currentHighlight = null;

  List<Tile> get currentHighlight {
    return _currentHighlight == null ? null : [..._currentHighlight];
  }

  void set currentHighlight(List<Tile> newHighlight) {
    _currentHighlight = newHighlight?.isNotEmpty == true ? newHighlight : null;

    notifyListeners();
  }

  void set selectedTile(String newTile) {
    if (newTile != _selectedTile) {
      _selectedTile = newTile;
      print("selected Tile: " + _selectedTile.toString());
      notifyListeners();
    }
  }

  void changeMoveState(String preNotifyTile, BuildContext context) {
    String oldSelected = selectedTile; //Just to make the Code more readable
    PieceProvider pieceProv = Provider.of<PieceProvider>(context, listen: false);
    List<Piece> pieces = pieceProv.pieces;
    Piece preNotifyPiece = pieces.firstWhere((e) => e.position == preNotifyTile, orElse: () => null);
    Piece oldSelectedPiece = pieces.firstWhere((e) => e.position == oldSelected, orElse: () => null);
    PlayerColor currPlayer = Provider.of<PlayerProvider>(context, listen: false).currentPlayer;

    ThinkingBoard thinkingBoard = Provider.of<ThinkingBoard>(context, listen: false);
    // THIS VERSION HIGHLIGHTS EVERY NEIGHBOUR OF SELECTED TILE NO MATTER WEATHER THERES A PIECE
    // FOR DEBUGGING
    if (!isMoveState) {
      // Nothing select before call
      List<String> adjacentTiles = [];
      List<String> currentDirectionTiles = BoardData.adjacentTiles[preNotifyTile].getRelativeEnum(
          Direction.top, PlayerColor.white, Provider.of<TileProvider>(context, listen: false).tiles[preNotifyTile].side);
      for (String tile in currentDirectionTiles) {
        adjacentTiles.add(tile);
      }
      // for (Direction direction in Direction.values) {
      //   List<String> currentDirectionTiles = BoardData.adjacentTiles[preNotifyTile].getRelativeEnum(
      //       direction, PlayerColor.white, Provider.of<TileProvider>(context, listen: false).tiles[preNotifyTile].side);
      //   for (String tile in currentDirectionTiles) {
      //     adjacentTiles.add(tile);
      //   }
      // }
      currentHighlight = adjacentTiles.map((e) => Provider.of<TileProvider>(context, listen: false).tiles[e]).toList();
      isMoveState = true;
    } else {
      //Something selected before call
      currentHighlight = null;
      isMoveState = false;
    }

    // if (!isMoveState) {
    //   if (preNotifyPiece?.playerColor == currPlayer) {
    //     //Set CurrentHighlight
    //     currentHighlight = thinkingBoard
    //         .getLegalMove(preNotifyTile, preNotifyPiece, context)
    //         .map((id) => Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((tile) => tile.id == id))
    //         .toList();
    //     // Inverting isMoveState.
    //     isMoveState = true;
    //   }
    // } else {
    //   if (thinkingBoard.getLegalMove(selectedTile, oldSelectedPiece, context).contains(preNotifyTile)) {
    //     pieceProv.movePieceTo(oldSelected, preNotifyTile);
    //     thinkingBoard.updateStatus();
    //   }
    //   currentHighlight = null;
    //   isMoveState = false;
    // }
  }

  void setByPosition(BuildContext context, Offset point) {
    //Dont!
    String hitTile = null;
    MapEntry hitPath =
        Provider.of<TileProvider>(context, listen: false).paths.entries.firstWhere((e) => e.value.contains(point), orElse: () => null);
    if (hitPath != null) {
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
