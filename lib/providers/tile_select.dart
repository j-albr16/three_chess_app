import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'tile_provider.dart';

class TileSelect with ChangeNotifier{
  String _selectedTile;
  String get selectedTile{
    return _selectedTile;
  }
  void set selectedTile(String newTile){
    if(newTile != _selectedTile) {
      _selectedTile = newTile;
    print("selected Tile: " + _selectedTile.toString());
    notifyListeners();
    }
  }

  void setByPosition(context, Offset point){ //Dont!
    String hitTile = null;
    MapEntry hitPath = Provider.of<TileProvider>(context, listen: false).paths.entries.firstWhere((e) => e.value.contains(point), orElse: () => null);
    if(hitPath != null){
      hitTile = hitPath.key;
    }
    selectedTile = hitTile;
  }

  TileSelect();

  Point _toPoint(Offset offset) {
    return Point(offset.dx, offset.dy);
  }



}