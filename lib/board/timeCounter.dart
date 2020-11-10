import 'package:flutter/foundation.dart';

import '../models/enums.dart';
import '../models/chess_move.dart';

class TimeCounter{

  Map<PlayerColor, Stopwatch> _stopwatches = {
    PlayerColor.white: Stopwatch(),
    PlayerColor.black: Stopwatch(),
    PlayerColor.red: Stopwatch(),
  };

  Map<PlayerColor, int> gatheredTime = {
    PlayerColor.white: 0,
    PlayerColor.black: 0,
    PlayerColor.red: 0,
  };

  void start(PlayerColor playerColor){} //TODO

  void end(PlayerColor playerColor){} //TODO

  void goNext(){} //TODO


  void updateGathered({@required List<ChessMove> serverChessMoves, List<ChessMove> clientChessMoves}){
    clientChessMoves??= serverChessMoves;
    PlayerColor currentPlayer = PlayerColor.values[serverChessMoves.length % 3];
    PlayerColor beforeCurrentPlayer = PlayerColor.values[(serverChessMoves.length+2) % 3];
    PlayerColor beforeBeforeCurrentPlayer = PlayerColor.values[(serverChessMoves.length+1) % 3];

    List<PlayerColor> reversedCurrentPlayers = [currentPlayer, beforeCurrentPlayer, beforeBeforeCurrentPlayer];

    if(serverChessMoves.length > 3){
      for(PlayerColor player in reversedCurrentPlayers){
      gatheredTime[player] = serverChessMoves[serverChessMoves.length - reversedCurrentPlayers.indexOf(player)].remainingTime;
    }}

    // eigentlich akkurater
    // for (PlayerColor player in PlayerColor.values) {
    //   int difference = clientChessMoves.length - serverChessMoves.length;
    //   PlayerColor currentPlayer = PlayerColor.values[clientChessMoves.length % 3];
    //
    //
    //   if (difference == 0 ||
    //       (difference == 1 && player == PlayerColor.values[(currentPlayer.index + 2) % 3]) ||
    //       (difference == 2 && player == PlayerColor.values[(currentPlayer.index + 1) % 3])) {
    //     gatheredTime[player] = serverChessMoves[serverChessMoves.length-1 - (player.index + currentPlayer.index)%3].remainingTime;
    //   }
    // }
  } //TODO need difference
}