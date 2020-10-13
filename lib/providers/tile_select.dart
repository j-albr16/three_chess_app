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

  void set currentHighlight(List<Tile> newHightight) {
    _currentHighlight = newHightight;
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
    Piece selectedPiece = pieces.firstWhere((e) => e.position == preNotifyTile, orElse: () => null);
    PlayerColor currPlayer = Provider.of<PlayerProvider>(context, listen: false).currentPlayer;

    ThinkingBoard thinkingBoard = Provider.of<ThinkingBoard>(context, listen: false);
    if (!isMoveState) {
      // Nothing select before call
      List<String> adjacentTiles = [];
      for (Direction direction in Direction.values) {
        List<String> currentDirectionTiles = BoardData.adjacentTiles[preNotifyTile].getFromEnum(direction);
        for (String tile in currentDirectionTiles) {
          adjacentTiles.add(tile);
        }
      }
      currentHighlight = adjacentTiles.map((e) => Provider.of<TileProvider>(context, listen: false).tiles[e]).toList();
      isMoveState = true;
    } else {
      //Something selected before call
      currentHighlight = null;
      isMoveState = false;
    }
    // if (!isMoveState) {
    //   print('MoveState: OFF');
    //   if (selectedPiece?.playerColor == currPlayer) {
    //     isMoveState = true;
    //     selectedPiece != null
    //         ? currentHightlight = thinkingBoard
    //             .getLegalMove(preNotifyTile, selectedPiece, context)
    //             .map((id) => Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((tile) => tile.id == id))
    //             .toList()
    //         : null;
    //     List<String> highlightStrings = currentHightlight.map((e) => e.id).toList();
    //     print(highlightStrings.toString());
    //   }
    //   if (currentHightlight != null) {
    //     if (currentHightlight.isEmpty) {
    //       currentHightlight = null;
    //     }
    //   }
    // } else {
    //   // isMoveState = true
    //   print('MoveState: ON');
    //   if (true) {
    //     // thinkingBoard.getLegalMove(selectedTile, selectedPiece, context).contains(newTile)
    //     pieceProv.movePieceTo(oldSelected, preNotifyTile);
    //     thinkingBoard.updateStatus();
    //   }
    //   currentHightlight = null;
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
