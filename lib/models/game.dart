import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';

import './player.dart';
import './chess-move.dart';
import './piece.dart';

class Game {
  List<Player> player;
  int currentPlayer;
  List<Map<PlayerColor, ChessMove>> chessMoves;
  List<Piece> startingBoard;
  
  get currentBoard {
    //implement calc current board with starting board and made chess Moves
  }   

  Game({this.player, this.currentPlayer, this.chessMoves});
}
