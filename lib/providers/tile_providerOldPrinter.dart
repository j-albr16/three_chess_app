import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../data/board_data.dart';
import 'package:three_chess/models/tile.dart';

class TileProvider with ChangeNotifier {
  Map<String, Tile> tiles = {};
  Map<String, Path> paths = {};

  double highestValueX = 0;
  double lowestValueX = double.infinity;
  double highestValueY = 0;
  double lowestValueY = double.infinity;
  double get minHighest{
    return highestValueX < highestValueY ? highestValueY : highestValueX;
  }

  TileProvider() {
    generateTiles();
    // Map<String, List<Point>> tileData{
    // "A1" : [Point(1,1),Point(1,1),Point(1,1),Point(1,1)]


    tiles.forEach((id, tile) {
      for(Point point in tile.points) {
        if (point.x > highestValueX) {
          highestValueX = point.x;
        }
        if (point.x < lowestValueX) {
          lowestValueX = point.x;
        }
        if (point.y > highestValueY) {
          highestValueY = point.y;
        }
        if (point.y < lowestValueY) {
          lowestValueY = point.y;
        }
      }
    });
    print('Map<String, List<Point>> tileData = {');
    tiles.forEach((id, tile) {
      print('"$id" : ' + tile.isWhite.toString() + ',');
    });
    print('};');
   // print('Map<String, List<Point>> tileData = {');
    //tiles.forEach((id, tile) {
    //  print('"$id" : [Point(${dreiSatzX(tile.points[0].x)},${dreiSatzY(tile.points[0].y)}),Point(${dreiSatzX(tile.points[1].x)},${dreiSatzY(tile.points[1].y)}),Point(${dreiSatzX(tile.points[2].x)},${dreiSatzY(tile.points[2].y)}),Point(${dreiSatzX(tile.points[3].x)},${dreiSatzY(tile.points[3].y)})],');
    //});
    //print('};');
  }

  double dreiSatzX(double zahl){
    return (zahl - lowestValueX)*(1000/minHighest);
  }
  double dreiSatzY(double zahl){
    return (zahl - lowestValueY)*(1000/minHighest);
  }

  void generateTiles() {
    tiles = {};
    List<List<Point>> pointsThird = BoardData.tilePointsThird;
    int _whiteBoolCount = 0;
    bool _lastisWhite = true;

    void reset() {
      _whiteBoolCount = 0;
      _lastisWhite = false;
    }

    bool _nextBool() {
      if (_whiteBoolCount >= 8) {
        _whiteBoolCount = 1;
        if (_lastisWhite) {
          return true;
        } else {
          return false;
        }
      } else {
        _whiteBoolCount++;
        if (_lastisWhite) {
          _lastisWhite = false;
          return false;
        } else {
          _lastisWhite = true;
          return true;
        }
      }
    }

    for (int i = 0; i < 3; i++) {
      Map<String, List<Point>> currentBoardThird = {};
      List<String> idStringThird = BoardData.CoordinateStrings[i];
      for (int j = 0; j < idStringThird.length; j++) {
        currentBoardThird[idStringThird[j]] = pointsThird[j];
      }
      print(i.toString());

      currentBoardThird.forEach((key, value) {
        tiles[key] = Tile(
            id: key,
            points: value,
            isWhite: _nextBool(),
            directions: BoardData.adjacentTiles[key]);
      });
      //rotate
      List<List<Point>> pointsThird2 = BoardData.tilePointsThird;
      List<List<Point>> newPoints = new List();
      for (int k = 0; k < pointsThird2.length; k++) {
        newPoints.add(List());
        for (int h = 0; h < pointsThird2[k].length; h++) {
          newPoints[k]
              .add(_rotatePoint(pointsThird2[k][h], Point(415.1, 358.8), i));
        }
      }
      pointsThird = newPoints;
      reset();
    }
  }

  Point _rotatePoint(Point rotate, Point around, int i) {
    double a = around.x - rotate.x;
    double b = around.y - rotate.y;
    double c = (sqrt(pow(a, 2) + pow(b, 2)));
    double alpha = asin(a / c);
    double newAlpha = alpha + -2 / 3 * pi;
    if (i == 1) newAlpha = alpha + 2 / 3 * pi;
    double newA = sin(newAlpha) * c;
    double newB = cos(newAlpha) * c;

    double newX = around.x + newA;
    double newY = around.y + newB;

    if (newX.isNaN) newX = around.x;

    if (newY.isNaN) newY = around.y;

    return Point(newX, newY);
  }
}
