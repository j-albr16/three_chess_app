import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';

import './player.dart';
import './chess_move.dart';
import './piece.dart';

class Game {
  @required
  String id;
  @required
  bool didStart;
  List<Player> player;
  List<ChessMove> chessMoves;
  @required
  List<Piece> startingBoard;
  int increment;
  int time;
  bool isPublic;
  bool isRated;
  int posRatingRange;
  int negRatingRange;

  Game({
    this.player,
    this.chessMoves,
    this.startingBoard,
    this.didStart,
    this.id,
    this.increment,
    this.time,
    this.isPublic,
    this.isRated,
    this.negRatingRange,
    this.posRatingRange,
  });
}
