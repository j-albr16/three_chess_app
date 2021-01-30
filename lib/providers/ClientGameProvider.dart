import 'package:flutter/foundation.dart';
import 'package:three_chess/board/LocalClientGame.dart';
import 'package:three_chess/board/OnlineClientGame.dart';
import '../models/local_game.dart';
import '../models/online_game.dart';
import '../models/game.dart';
import '../board/BoardState.dart';
import '../models/chess_move.dart';
import '../models/enums.dart';
import '../board/client_game.dart';

import 'game_provider.dart';

typedef Future<bool> ConfirmFunction(dynamic);

class ClientGameProvider with ChangeNotifier{
  ClientGame clientGame;
  GameProvider gameProvider;

  ClientGameProvider(GameProvider currentGameProvider){
    gameProvider = currentGameProvider;
  }

  GameType get gameType{
    return clientGame?.gameType;
  }

  void update(GameProvider gameProviderUpdate){
    gameProvider = gameProviderUpdate;
    if(gameType == GameType.Online){
      List<ChessMove> chessMoves = gameProvider.onlineGame?.chessMoves;
      if(chessMoves != null){
        (clientGame as OnlineClientGame).syncChessMove(chessMoves);
      }
    }
  }

  setClientGame(Game game) {
    if (game == null) {
      clientGame = null;
    }
    else {
      switch (game.runtimeType) {
        case OnlineGame:
          clientGame = OnlineClientGame(
              gameProvider: gameProvider,
              onlineGame: game,
              providerUpdate: notifyListeners);
          break;
        case LocalGame:
          clientGame = LocalClientGame(
            localGame: game,
            providerUpdate: notifyListeners
          );
          break;
      }
    }
    notifyListeners();
  }

}