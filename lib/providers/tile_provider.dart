import 'dart:math';
import '../models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/board_data.dart';
import 'package:three_chess/models/tile.dart';

class TileProvider with ChangeNotifier {
  Map<String, Tile> tiles = {};
  Map<String, Path> paths = {};

  static Map<PlayerColor, List<String>> charCoordinatesOf = {
    PlayerColor.white: ["A", "B", "C", "D", "E", "F", "G", "H"],
    PlayerColor.black: ["L", "K", "J", "I", "D", "C", "B", "A"],
    PlayerColor.red: ["H", "G", "F", "E", "I", "J", "K", "L"]
  };
  static Map<PlayerColor, List<String>> numCoordinatesOf = {
    PlayerColor.white: ["1", "2", "3", "4"],
    PlayerColor.black: ["8", "7", "6", "5"],
    PlayerColor.red: ["12", "11", "10", "9"],
  };

  static String getEqualCoordinate(String tileId, PlayerColor switchTo, Map<String, Tile> tiles) {
    if (tiles[tileId].side == switchTo) {
      return tileId;
    } else if ((tiles[tileId].side.index + 1) % 3 == switchTo.index) {
      return nextColorEqualCoordinate(tileId, tiles);
    }
    return previousColorEqualCoordinate(tileId, tiles);
  }

  static String previousColorEqualCoordinate(String tileId, Map<String, Tile> tiles) {
    PlayerColor currentColor = tiles[tileId].side;

    int charIndex = charCoordinatesOf[currentColor].indexOf(tileId[0]);
    int numIndex = numCoordinatesOf[currentColor].indexOf(tileId.substring(1));

    PlayerColor previousColor = PlayerColor.values[(currentColor.index + 2) % 3];

    return (charCoordinatesOf[previousColor][charIndex] + numCoordinatesOf[previousColor][numIndex]);
  }

  static String nextColorEqualCoordinate(String tileId, Map<String, Tile> tiles) {
    PlayerColor currentColor = tiles[tileId].side;

    int charIndex = charCoordinatesOf[currentColor].indexOf(tileId[0]);
    int numIndex = numCoordinatesOf[currentColor].indexOf(tileId.substring(1));

    PlayerColor nextColor = PlayerColor.values[(currentColor.index + 1) % 3];

    return (charCoordinatesOf[nextColor][charIndex] + numCoordinatesOf[nextColor][numIndex]);
  }

  TileProvider() {
    generateTiles();
  }

  void rotateTilesNext() {
    Map<String, Tile> newTiles = {};
    for (Tile tile in tiles.values.toList()) {
      String prevId = previousColorEqualCoordinate(tile.id, tiles);
      newTiles[prevId] = Tile(
          id: prevId,
          points: tile.points,
          isWhite: BoardData.tileWhiteData[prevId],
          directions: BoardData.adjacentTiles[prevId],
          side: BoardData.sideData[prevId],
          path: tile.path);
    }
    tiles = newTiles;
    notifyListeners();
  }

  void rotateTilesPrevious() {
    Map<String, Tile> newTiles = {};
    for (Tile tile in tiles.values.toList()) {
      String nextId = nextColorEqualCoordinate(tile.id, tiles);
      newTiles[nextId] = Tile(
          id: nextId,
          points: tile.points,
          isWhite: BoardData.tileWhiteData[nextId],
          directions: BoardData.adjacentTiles[nextId],
          side: BoardData.sideData[nextId],
          path: tile.path);
    }
    tiles = newTiles;
    notifyListeners();
  }

  void printNewColor() {
    print("static Map<String, bool> tileWhiteData = {");
    for (Tile tile in tiles.values.toList()) {
      if (tile.side == PlayerColor.black || tile.side == PlayerColor.red) {
        print('"${tile.id}" : ${!tile.isWhite}, ');
      } else {
        print('"${tile.id}" : ${tile.isWhite}, ');
      }
    }
    print("}");
  }

  void printNewShit() {
    print("static Map<String, List<Point>> tileData = {");
    for (Tile tile in tiles.values.toList()) {
      if (tile.side == PlayerColor.black) {
        print('"${switchBlackCoordinate(tile.id)}" : [');
      } else if (tile.side == PlayerColor.red) {
        print('"${switchRedCoordinate(tile.id)}" : [');
      } else {
        print('"${tile.id}" : [');
      }
      for (Point point in tile.points) {
        print('Point(${point.x.toString()}, ${point.y.toString()}),');
      }
      print('],');
    }
  }

  String switchBlackCoordinate(String tile) {
    String char = tile[0];
    String number = tile.substring(1);
    switch (char) {
      case "L":
        char = "A";
        break;
      case "K":
        char = "B";
        break;
      case "J":
        char = "C";
        break;
      case "I":
        char = "D";
        break;
      case "D":
        char = "I";
        break;
      case "C":
        char = "J";
        break;
      case "B":
        char = "K";
        break;
      case "A":
        char = "L";
        break;
    }
    return (char + number);
  }

  String switchRedCoordinate(String tile) {
    String char = tile[0];
    String num = tile.substring(1);
    switch (char) {
      case "H":
        char = "L";
        break;
      case "G":
        char = "K";
        break;
      case "F":
        char = "J";
        break;
      case "E":
        char = "I";
        break;
      case "I":
        char = "E";
        break;
      case "J":
        char = "F";
        break;
      case "K":
        char = "G";
        break;
      case "L":
        char = "H";
        break;
    }
    return (char + num);
  }

  void generateTiles() {
    tiles = {};

    BoardData.tileData.entries.toList().forEach((e) {
      tiles[e.key] = Tile(
          id: e.key,
          points: e.value,
          isWhite: BoardData.tileWhiteData[e.key],
          directions: BoardData.adjacentTiles[e.key],
          side: BoardData.sideData[e.key],
          path: Path()
            ..moveTo(e.value[0].x.toDouble(), e.value[0].y.toDouble())
            ..lineTo(e.value[1].x.toDouble(), e.value[1].y.toDouble())
            ..lineTo(e.value[2].x.toDouble(), e.value[2].y.toDouble())
            ..lineTo(e.value[3].x.toDouble(), e.value[3].y.toDouble())
            ..lineTo(e.value[0].x.toDouble(), e.value[0].y.toDouble())
            ..close());
    });
  }
}
