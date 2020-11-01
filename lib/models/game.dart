import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';

import './player.dart';
import 'chess_move.dart';
import './piece.dart';

class Game {
  @required
  String id;
  @required
  bool didStart;
  List<Player> player;
  PlayerColor currentPlayer;
  List<ChessMove> chessMoves;
  @required
  List<Piece> startingBoard;
  List<Piece> currentBoard;
  List<Piece> recentBoard;
  int increment;
  double time;
  bool isPublic;
  bool isRated;
  int posRatingRange;
  int negRatingRange;

  Game({
    this.player,
    this.currentPlayer,
    this.chessMoves,
    this.currentBoard,
    this.recentBoard,
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
