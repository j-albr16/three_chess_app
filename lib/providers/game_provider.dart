import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess-move.dart';
import '../models/enums.dart';


class GameProvider with ChangeNotifier {


  Game _game = Game(
  player:  [
    Player(
      playerColor: PlayerColor.white,
      user: User(
        userName: 'jan',
      ),
    ),
    Player(
      playerColor: PlayerColor.black,
      user: User(
        userName: 'leo',
      ),
    ),
    Player(
      playerColor: PlayerColor.red,
      user: User(
        userName: 'david',
      ),
    ),
  ],
  chessMoves: [
    {
      PlayerColor.white: ChessMove(
        initialTile: 'B2',
        nextTile: 'B4',
        piece: PieceType.Pawn,
      ),
      PlayerColor.black: ChessMove(
        initialTile: 'K7',
        nextTile: 'K5',
        piece: PieceType.Pawn,
      ),
      PlayerColor.red: ChessMove(
        initialTile: 'I11',
        nextTile: 'I9',
        piece: PieceType.Pawn,
      ),
    },
    {
      PlayerColor.white: ChessMove(
        initialTile: 'B4',
        nextTile: 'B5',
        piece: PieceType.Pawn,
      ),
      PlayerColor.black: ChessMove(
        initialTile: 'K5',
        nextTile: 'K4',
        piece: PieceType.Pawn,
      ),
      PlayerColor.red: ChessMove(
        initialTile: 'I9',
        nextTile: 'I8',
        piece: PieceType.Pawn,
      ),
    }
  ],

);


  get game {
    // for (int i=0;  i < 14;  i++){
    //   _game.chessMoves.add(_game.chessMoves[0]);
    // }
    // print(_game.chessMoves.length);
    return _game;
  }


}