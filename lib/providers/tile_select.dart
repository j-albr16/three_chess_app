import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:three_chess/providers/player_provider.dart';
import 'package:three_chess/providers/thinking_board.dart';
import 'tile_provider.dart';
import '../models/enums.dart';
import '../models/chess_move.dart';
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
    _currentHighlight = newHighlight;

    notifyListeners();
  }

  void set selectedTile(String newTile) {
    if (newTile != _selectedTile) {
      _selectedTile = newTile;
      print("selected Tile: " + _selectedTile.toString());
      print("Highights: $currentHighlight");
      notifyListeners();
    }
  }

  void goIntoMoveState(String preNotifyTile, BuildContext context) {
    PieceProvider pieceProv = Provider.of<PieceProvider>(context, listen: false);
    GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    Map<String, Piece> pieces = pieceProv.pieces;
    Piece preNotifyPiece = pieces[preNotifyTile];
    ThinkingBoard thinkingBoard = Provider.of<ThinkingBoard>(context, listen: false);

    isMoveState = true;

    if (preNotifyTile != selectedTile) {
      currentHighlight = thinkingBoard
          .getLegalMove(preNotifyTile, MapEntry(preNotifyPiece.pieceType, preNotifyPiece.playerColor), context)
          .map((id) => Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((tile) => tile.id == id))
          .toList();
      selectedTile = preNotifyTile;
      if (currentHighlight == null || currentHighlight.isEmpty) {
        isMoveState = false;
        selectedTile = null;
        currentHighlight = null;
      }
      notifyListeners();
    }
  }

  void endMoveState(String preNotifyTile, BuildContext context) {
    String oldSelected = selectedTile; //Just to make the Code more readable
    PieceProvider pieceProv = Provider.of<PieceProvider>(context, listen: false);
    Map<String, Piece> pieces = pieceProv.pieces;
    Piece oldSelectedPiece = pieces[oldSelected];

    ThinkingBoard thinkingBoard = Provider.of<ThinkingBoard>(context, listen: false);

    if (preNotifyTile != null) {
      if (thinkingBoard
          .getLegalMove(selectedTile, MapEntry(oldSelectedPiece.pieceType, oldSelectedPiece.playerColor), context)
          .contains(preNotifyTile)) {
        pieceProv.movePieceTo(oldSelected, preNotifyTile);
        GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
        PlayerProvider playerProvider = Provider.of<PlayerProvider>(context, listen: false);
        if (gameProvider.game.chessMoves.length < pieceProv.doneChessMoves.length) {
          playerProvider.nextPlayer();
          gameProvider.sendMove(ChessMove(
            initialTile: oldSelected,
            nextTile: preNotifyTile,
            remainingTime: playerProvider.getRemainingTime(gameProvider.game.player.playerColor, context),
          ));
        }
      }
    }
    selectedTile = null;
    currentHighlight = null;
    isMoveState = false;
    notifyListeners();
  }

  String getPieceAtPosition(BuildContext context, Offset point) {
    String hitTile = null;
    MapEntry hitPath = Provider.of<TileProvider>(context, listen: false)
        .tiles
        .entries
        .firstWhere((e) => e.value.path.contains(point), orElse: () => null);
    if (hitPath != null) {
      hitTile = hitPath.key;
    }
    return hitTile;
  }

  TileSelect();

  Point _toPoint(Offset offset) {
    return Point(offset.dx, offset.dy);
  }
}
