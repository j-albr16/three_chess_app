import 'package:flutter/material.dart';

import './player.dart';
import './chess_move.dart';
import './piece.dart';
import './request.dart';

class Game {
  Map finishedGameData;
  DateTime endGameExpiry;
  @required
  String id;
  @required
  bool didStart;
  List<String> invitations;
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
  String chatId;
  bool allowPremades;

  Game({
    this.allowPremades,
    this.chatId,
    this.player,
    this.finishedGameData,
    this.invitations,
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
    this.endGameExpiry,
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
