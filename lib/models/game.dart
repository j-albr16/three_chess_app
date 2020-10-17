import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';

import './player.dart';
import './chess-move.dart';

class Game {
  List<Player> player;
  int currentPlayer;
  List<Map<PlayerColor, ChessMove>> chessMoves;

  Game({this.player, this.currentPlayer, this.chessMoves});
}
