import 'package:flutter/material.dart';

import './player.dart';
import './chess_move.dart';
import './piece.dart';

abstract class Game {

  Map finishedGameData; // Maybe split into more detail in the future

  @required
  String id;
  @required
  bool didStart; // client side maybe: isRunning
  List<Player> player;
  List<ChessMove> chessMoves;
  @required
  List<Piece> startingBoard;
  int increment;
  int time;

  Game({
    this.player,
    this.finishedGameData,
    this.chessMoves,
    this.startingBoard,
    this.didStart,
    this.id,
    this.increment,
    this.time,
  });
}

// example for fnishedGameData : 

// {
//   'winner' : PlayerColor playerColor,
//   PlayerColor.white : int newScore,
//   PlayerColor.black : int newScore,
//   PlayerColor.red : int newScore,
//   'howGameEnded : HowGameEnded howGmaeEnded

// }
