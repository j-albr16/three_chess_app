import 'package:flutter/foundation.dart';
import 'package:three_chess/models/piece.dart';


class PlayerProvider with ChangeNotifier{
  PlayerColor currentPlayer = PlayerColor.white;

  PlayerProvider();

  void nextPlayer(){

  }

  void previousPlayer(){

  }

}