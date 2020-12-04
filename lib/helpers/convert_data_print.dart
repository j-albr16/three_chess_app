import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';

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
}
