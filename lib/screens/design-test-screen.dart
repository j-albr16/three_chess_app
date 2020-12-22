import 'package:flutter/material.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/piece.dart';
import 'package:three_chess/models/user.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

import '../models/player.dart';
import '../models/user.dart';
import '../widgets/invitations.dart';
import '../models/game.dart';
import '../models/chess_move.dart';
import '../widgets/end_game.dart';
import '../widgets/move_table.dart';
import '../providers/friends_provider.dart';
import '../helpers/sound_player.dart';
import '../widgets/chat.dart';
import '../widgets/end_game.dart';
import '../providers/popup_provider.dart';
import '../screens/screen_bone.dart';

class DesignTestScreen extends StatefulWidget {
  static const routeName = '/design-test';

  @override
  _DesignTestScreenState createState() => _DesignTestScreenState();
}

class _DesignTestScreenState extends State<DesignTestScreen>
    with notificationPort<DesignTestScreen> {
  @override
  Widget build(BuildContext context) {
    GameProvider _gameProvider =
        Provider.of<GameProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          // Invitations(
          //   acceptInvitation: (String gameId) =>
          //       print('Accept Invitation to ' + gameId),
          //   declineInvitation: () => print('Declined Invitation'),
          //   invitations: Provider.of<FriendsProvider>(context).invitations,
          //   size: Size(400, 300),
          // ),
          testButtonBar(
            text: 'Show fnished Game Popup',
            color: Colors.blue,
            callback: () => showDialog(
                context: context,
                builder: (context) {
                  Map finishedGameData = {
                    'winner': PlayerColor.white,
                    'howGameEnded': HowGameEnded.Surrender,
                    PlayerColor.white: 1300,
                    PlayerColor.black: 800,
                    PlayerColor.red: 800,
                  };
                  Size size = MediaQuery.of(context).size;
                  return EndGameAlertDialog(
                    finishedGameData: finishedGameData,
                    inspect: () {},
                    leave: () => Navigator.of(context).pop(),
                    player: Provider.of<GameProvider>(context).game.player,
                    rematch: () {},
                    size: size,
                    you: Provider.of<GameProvider>(context).player,
                  );
                }),
          ),
          testButtonBar(
            callback: () async {
              await Sounds.playSound(Sound.Capture);
            },
            color: Colors.pink,
            text: 'Capture',
          ),
          testButtonBar(
            callback: () async {
              await Sounds.playSound(Sound.Check);
            },
            color: Colors.pink,
            text: 'Check',
          ),
          testButtonBar(
            callback: () async {
              await Sounds.playSound(Sound.LowTime);
            },
            color: Colors.pink,
            text: 'Low Time',
          ),
          testButtonBar(
            callback: () async {
              await Sounds.playSound(Sound.SocialNotify);
            },
            color: Colors.pink,
            text: 'Social Notify',
          ),
          testButtonBar(
            callback: () async {
              await Sounds.playSound(Sound.Move);
            },
            color: Colors.pink,
            text: 'Move',
          ),
          testButtonBar(
            callback: () => _gameProvider.sendMove(new ChessMove(
              initialTile: 'A2',
              nextTile: 'A4',
              remainingTime: 10,
            )),
            color: Colors.green,
            text: 'Make move',
          ),
          testButtonBar(
              callback: () => _gameProvider.createTestGame(),
              color: Colors.orangeAccent,
              text: 'Create Test Game in DB'),
          sorrounding([
            Text('Surrender'),
            testButtonBar(
                callback: () => _gameProvider.requestSurrender(),
                color: Colors.blue,
                text: 'Surrender Request'),
            testButtonBar(
                callback: () => _gameProvider.acceptSurrender(),
                color: Colors.green,
                text: 'Surrender Accept'),
            testButtonBar(
                callback: () => _gameProvider.declineSurrender(),
                color: Colors.red,
                text: 'Surrender Decline'),
          ]),
          sorrounding([
            Text('Remi'),
            testButtonBar(
                callback: () => _gameProvider.requestRemi(),
                color: Colors.tealAccent,
                text: 'Remi Request'),
            testButtonBar(
                callback: () => _gameProvider.acceptRemi(),
                color: Colors.green,
                text: 'Remi Accpet'),
            testButtonBar(
                callback: () => _gameProvider.declineRemi(),
                color: Colors.red,
                text: 'Remi Decline'),
          ]),
          sorrounding([
            Text('Take Back'),
            testButtonBar(
                callback: () => _gameProvider.requestTakeBack(),
                color: Colors.orangeAccent,
                text: 'take Back request'),
            testButtonBar(
                callback: () => _gameProvider.acceptTakeBack(),
                color: Colors.green,
                text: 'Take Back Accept'),
            testButtonBar(
                callback: () => _gameProvider.declineTakeBack(),
                color: Colors.red,
                text: 'Take Back Decline')
          ])
        ],
      ),
    );
  }

  Widget sorrounding(array) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(width: 2, color: Colors.black),
      ),
      child: Padding(
        padding: EdgeInsets.all(13),
        child: Column(
          children: array,
        ),
      ),
    );
  }

  Widget testButtonBar({String text, callback, Color color}) {
    return FlatButton(
      color: color,
      height: 50,
      minWidth: 100,
      padding: EdgeInsets.all(13),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      onPressed: callback,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
