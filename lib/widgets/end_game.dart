import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/user.dart';
import '../models/player.dart';
import '../models/enums.dart';

class EndGameAlertDialog extends StatelessWidget {
  Size size;
  Player you;
  Map finishedGameData;
  List<Player> player;

  Function rematch;
  Function leave;
  Function inspect;

  EndGameAlertDialog(
      {this.size, this.finishedGameData, this.player, this.you, this.inspect, this.leave, this.rematch});

  String get title {
    if (finishedGameData['winner'] == you.playerColor) {
      return 'You Won';
    }
    return 'You Lost';
  }

  String get winType {
    switch (finishedGameData['howGameEnded']) {
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
    print(finishedGameData);
    print(you);
    return AlertDialog(
      title: Text(title),
      titlePadding: EdgeInsets.all(7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      elevation: 10,
      contentPadding: EdgeInsets.all(13),
      actionsPadding: EdgeInsets.all(7),
      actions: actionButtons(),
      content: Container(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Win Type :  ' + winType),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:player.map((player) => updatedPlayerTile(
                  player.user.userName,
                  player.user.score,
                  finishedGameData[player.playerColor])).toList(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> actionButtons(){
    return  [
        actionButton(
          action: rematch,
          size: Size(size.width * 0.25, size.height * 0.2),
          title: 'Rematch',
        ),
        actionButton(
          action: leave,
          size: Size(size.width * 0.25, size.height * 0.2),
          title: 'Leave',
        ),
        actionButton(
          action: inspect,
          size: Size(size.width * 0.25, size.height * 0.2),
          title: 'Inspect',
        )
      ];
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

  static Widget actionButton({Size size, String title, Function action}) {
    return FlatButton(
      onPressed: action,
      child: Text(title),
      height: size.height,
      minWidth: size.width,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
    );
  }
}
