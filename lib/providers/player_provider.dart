import 'package:flutter/foundation.dart';
import '../models/enums.dart';

class PlayerProvider with ChangeNotifier {
  PlayerColor _currentPlayer = PlayerColor.white;

  PlayerColor get currentPlayer {
    return _currentPlayer;
  }

  PlayerProvider();

  void nextPlayer() {
    _currentPlayer = PlayerColor.values[(_currentPlayer.index + 1) % 3];
  }

  void previousPlayer() {
    _currentPlayer = PlayerColor.values[(_currentPlayer.index + 2) % 3];
  }
}
