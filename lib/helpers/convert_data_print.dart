import 'dart:math';

import '../data/board_data.dart';
import '../models/enums.dart';

class ConvertDataPrint {
  static printJSboardDataAj() {
    List<String> directions = ["bottomRight", "bottom", "bottomLeft", "left", "leftTop", "top", "topRight", "right"];
    print("module.exports = adjacentTiles = {");
    for (MapEntry<String, Directions> tile in BoardData.adjacentTiles.entries) {
      print("${tile.key} : {");
      for (int i = 0; i < directions.length; i++) {
        String ajTiles = "";
        for (String ajTile in tile.value.getFromEnum(Direction.values[i])) {
          ajTiles += ('"$ajTile", ');
        }
        print("${directions[i]} : [$ajTiles ],");
      }
      print("},");
    }
    print("};");
  }

  static printNewBlackAndRedOrder(){
    print("static Map<String, List<Point>> tileData = {");
    for(MapEntry<String, List<Point>> entry in BoardData.tileData.entries){
      String actualKey;
      switch(BoardData.sideData[entry.key]){
        case PlayerColor.white:
          actualKey = entry.key;
          break;
        case PlayerColor.black:
          actualKey = blackOrder[entry.key[0]] + entry.key.substring(1);
          break;
        case PlayerColor.red:
          actualKey = redOrder[entry.key[0]] + entry.key.substring(1);
          break;
      }
      print('"$actualKey" : [');
      for(Point point in entry.value){
        print('Point(${point.x}, ${point.y}),');
      }
      print('],');
    }
    print("};");
  }
  static Map<String, String> blackOrder = {
    "L" : "A",
    "K" : "B",
    "J" : "C",
    "I" : "D",
    "D" : "I",
    "C" : "J",
    "B" : "K",
    "A" : "L",
  };

  static Map<String, String> redOrder = {
    "H" : "L",
    "G" : "K",
    "F" : "J",
    "E" : "I",
    "I" : "E",
    "J" : "F",
    "K" : "G",
    "L" : "H",
  };
}
