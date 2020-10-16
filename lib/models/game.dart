import 'package:flutter/material.dart';

import './player.dart';
import './chess-move.dart';


  
class Game {
  List<Player> player;
  int currentPlayer;
  List<ChessMove> chessMove;

  Game({this.player, this.currentPlayer, this.chessMove});
}
