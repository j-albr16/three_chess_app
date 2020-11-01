import 'package:flutter/foundation.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/providers/piece_provider.dart';
import '../models/enums.dart';
import '../models/game.dart';

import 'package:provider/provider.dart';
import 'game_provider.dart';

class PlayerProvider with ChangeNotifier {
  PlayerColor currentPlayer = PlayerColor.white;
  Map<PlayerColor, Stopwatch> stopwatches = {
    PlayerColor.white: Stopwatch(),
    PlayerColor.black: Stopwatch(),
    PlayerColor.red: Stopwatch(),
  };

  Map<PlayerColor, int> gatheredTime = {
    PlayerColor.white: 0,
    PlayerColor.black: 0,
    PlayerColor.red: 0,
  };

  void updateGathered(context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    PieceProvider pieceProvider = Provider.of<PieceProvider>(context, listen: false);

    for (Player player in gameProvider.game.player) {
      int serverChessMoveLength = gameProvider.game.chessMoves.length;
      int clientChessMoveLength = pieceProvider.doneChessMoves.length;
      int difference = clientChessMoveLength - serverChessMoveLength;

      if (difference == 0 ||
          (difference == 1 && player.playerColor == PlayerColor.values[(currentPlayer.index + 2) % 3]) ||
          (difference == 2 && player.playerColor == PlayerColor.values[(currentPlayer.index + 1) % 3])) {
        gatheredTime[player.playerColor] = player.remainingTime;
      }
    }
  }

  int getRemainingTime(PlayerColor playerColor, context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);

    return gameProvider.game.time - gatheredTime[playerColor] + stopwatches[playerColor].elapsed.inSeconds;
  }

  PlayerProvider();

  void nextPlayer() {
    stopwatches[PlayerColor.values[(currentPlayer.index) % 3]].stop();
    gatheredTime[PlayerColor.values[(currentPlayer.index) % 3]] +=
        stopwatches[PlayerColor.values[(currentPlayer.index) % 3]].elapsed.inSeconds;
    stopwatches[PlayerColor.values[(currentPlayer.index) % 3]].reset();

    stopwatches[PlayerColor.values[(currentPlayer.index + 1) % 3]].start();
    currentPlayer = PlayerColor.values[(currentPlayer.index + 1) % 3];
  }

  void previousPlayer() {
    //TODO HAS TO RESET TIME INSTEAD OF THIS WEIRD SHIT
    stopwatches[PlayerColor.values[(currentPlayer.index) % 3]].stop();
    stopwatches[PlayerColor.values[(currentPlayer.index + 2) % 3]].start();
    currentPlayer = PlayerColor.values[(currentPlayer.index + 2) % 3];
  }
}
