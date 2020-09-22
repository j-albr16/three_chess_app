import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/board_data.dart';
import 'package:three_chess/models/tile.dart';

class TileProvider with ChangeNotifier {
  Map<String, Tile> tiles = {};
  Map<String, Path> paths = {};


  TileProvider() {
    generateTiles();
  }

  void generateTiles() {
    tiles = {};

      BoardData.tileData.entries.toList().forEach((e) {
        tiles[e.key] = Tile(
            id: e.key,
            points: e.value,
            isWhite: BoardData.tileWhiteData[e.key],
            directions: BoardData.adjacentTiles[e.key]);
      });
    }
  }

