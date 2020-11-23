import 'package:flutter/material.dart';

import '../models/enums.dart';
import '../models/tile.dart';
import '../data/board_data.dart';

class Tiles{

  Map<String, Tile> tiles;
  List<String> lastHighlighted;
  PlayerColor perspectiveOf;

  Tiles({ this.perspectiveOf = PlayerColor.white}){
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
    for(int i = 0; i < perspectiveOf.index; i++){
      rotateTilesNext();
    }
  }

  void highlightTiles(List<String> highlighted){
    if(lastHighlighted != null){
      for(String high in lastHighlighted){
        tiles[high] = Tile(
            isHighlighted: false,
            id: tiles[high].id,
            points: tiles[high].points,
            isWhite: BoardData.tileWhiteData[high],
            directions: BoardData.adjacentTiles[high],
            side: BoardData.sideData[high],
            path: tiles[high].path);
      }
    }
    if (highlighted != null) {
      for(String high in highlighted){
        tiles[high] = Tile(
            isHighlighted: true,
            id: tiles[high].id,
            points: tiles[high].points,
            isWhite: BoardData.tileWhiteData[high],
            directions: BoardData.adjacentTiles[high],
            side: BoardData.sideData[high],
            path: tiles[high].path);
      }
    }
    lastHighlighted = highlighted;
  }


  void rotateTilesPrevious() {
    Map<String, Tile> newTiles = {};
  for (Tile tile in tiles.values.toList()) {
    String prevId = previousColorEqualCoordinate(tile.id);
    newTiles[prevId] = Tile(
        id: prevId,
        points: tile.points,
        isWhite: BoardData.tileWhiteData[prevId],
        directions: BoardData.adjacentTiles[prevId],
        side: BoardData.sideData[prevId],
        path: tile.path);
  }
  perspectiveOf = PlayerColor.values[perspectiveOf.index + 2 % 3];

  tiles = newTiles;}

  void rotateTilesNext() {
    Map<String, Tile> newTiles = {};
  for (Tile tile in tiles.values.toList()) {
    String nextId = nextColorEqualCoordinate(tile.id);
    newTiles[nextId] = Tile(
        id: nextId,
        points: tile.points,
        isWhite: BoardData.tileWhiteData[nextId],
        directions: BoardData.adjacentTiles[nextId],
        side: BoardData.sideData[nextId],
        path: tile.path);
  }

    perspectiveOf = PlayerColor.values[perspectiveOf.index + 1 % 3];
    tiles = newTiles;
  }

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

  static String getEqualCoordinate(String tileId, PlayerColor switchTo) {
    if (BoardData.sideData[tileId] == switchTo) {
      return tileId;
    } else if ((BoardData.sideData[tileId].index + 1) % 3 == switchTo.index) {
      return nextColorEqualCoordinate(tileId);
    }
    return previousColorEqualCoordinate(tileId);
  }

  static String previousColorEqualCoordinate(String tileId) {
    PlayerColor currentColor = BoardData.sideData[tileId];

    int charIndex = charCoordinatesOf[currentColor].indexOf(tileId[0]);
    int numIndex = numCoordinatesOf[currentColor].indexOf(tileId.substring(1));

    PlayerColor previousColor = PlayerColor.values[(currentColor.index + 2) % 3];

    return (charCoordinatesOf[previousColor][charIndex] + numCoordinatesOf[previousColor][numIndex]);
  }

  static String nextColorEqualCoordinate(String tileId) {
    PlayerColor currentColor = BoardData.sideData[tileId];

    int charIndex = charCoordinatesOf[currentColor].indexOf(tileId[0]);
    int numIndex = numCoordinatesOf[currentColor].indexOf(tileId.substring(1));

    PlayerColor nextColor = PlayerColor.values[(currentColor.index + 1) % 3];

    return (charCoordinatesOf[nextColor][charIndex] + numCoordinatesOf[nextColor][numIndex]);
  }

  getTilePositionOf(Offset localPosition,){
    return tiles
        .entries
        .firstWhere((e) => e.value.path.contains(localPosition), orElse: () => null)?.key;
  }

  static getTilePositionOfInTiles(Offset localPosition,  Map<String, Tile> tiles){
    return tiles
        .entries
        .firstWhere((e) => e.value.path.contains(localPosition), orElse: () => null).key;
  }

}