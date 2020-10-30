import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';

import './player.dart';
import './chess-move.dart';
import './piece.dart';

class Game {
  @required String id;
  @required bool didStart;
  List<Player> player;
  PlayerColor currentPlayer;
  List<Map<PlayerColor, ChessMove>> chessMoves;
  @required List<Piece> startingBoard;
  List<Piece> currentBoard;
  List<Piece> recentBoard;  

  Game({this.player, this.currentPlayer, this.chessMoves, this.currentBoard, this.recentBoard, this.startingBoard, this.didStart, this.id});
}
