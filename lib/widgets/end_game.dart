import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/user.dart';
import '../models/player.dart';
import '../models/enums.dart';

class FinishedGame extends StatelessWidget {
  Size size;
  Game game;
  Player you;

  FinishedGame({
    this.size,
    this.game,
    this.you,
  });

  String get title {
    if (game.finishedGameData['winner'] == you.playerColor) {
      return 'You Won';
    }
    return 'You Lost';
  }

  String get winType {
    switch (game.finishedGameData['howGameEnded']) {
      case HowGameEnded.CheckMate:
        return 'CheckMate';
      case HowGameEnded.Leave:
        return 'Player Left';
      case HowGameEnded.Remi:
        return 'Draw';
      case HowGameEnded.Surrender:
        return 'Surrender';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: size.width,
            height: size.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Text('Win Type :  ' + winType),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: game.player.map((player) => updatedPlayerTile(
                player.user.userName,
                player.user.score,
                game.finishedGameData[player.playerColor])),
          ),
        ],
      ),
    );
  }

  static Widget updatedPlayerTile(String userName, int oldScore, int newScore) {
    int difference = newScore - oldScore;
    Color intColor = Colors.green;
    if (difference < 0) {
      intColor = Colors.red;
    }
    return Column(
      children: [
        Text(userName),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(oldScore.toString()),
            Text('+'),
            Text(
              difference.toString(),
              style: TextStyle(color: intColor),
            )
          ],
        ),
      ],
    );
  }
}
