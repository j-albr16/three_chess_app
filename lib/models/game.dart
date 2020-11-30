import 'package:flutter/material.dart';
import '../models/enums.dart';

import './player.dart';
import './chess_move.dart';
import './piece.dart';
import './request.dart';

class Game {
  Map finishedGameData;
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
  List<Request> requests;

  Game({
    this.player,
    this.finishedGameData,
    this.chessMoves,
    this.startingBoard,
    this.requests,
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
