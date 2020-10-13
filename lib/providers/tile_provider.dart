import 'dart:math';
import '../models/enums.dart';
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
