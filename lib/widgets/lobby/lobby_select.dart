import 'package:flutter/material.dart';

import '../../models/online_game.dart';
import '../../helpers/constants.dart';

const Map<int, IconData> iconInterface = {
  1: Icons.person_outline,
  2: Icons.person,
  3: Icons.people
};

typedef void SelectLobby(String gameId, BuildContext context);

class LobbySelect extends StatelessWidget {

  static getTimeString(int time, int increment) {
    int average = time * 60 + increment * 30;
    if (average < 3 * 60) {
      return 'Bullet';
    }
    if (average < 7 * 60) {
      return 'Blitz';
    }
    if (average < 10 * 60) {
      return 'Rapid';
    }
    if (average < 15 * 60) {
      return 'Classic';
    }
  }

  final SelectLobby selectLobbyCall;
  final List<OnlineGame> onlineGames;
  final Size size;

  LobbySelect({this.onlineGames,this.size, this.selectLobbyCall});

  Widget lobbyGameTile(
      {ThemeData theme, OnlineGame onlineGame, BuildContext context}) {
    return TextButton(
      onPressed: () => selectLobbyCall(onlineGame.id, context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          leading(onlineGame: onlineGame, theme: theme),
          main(theme: theme, onlineGame: onlineGame),
          trailing(onlineGame: onlineGame, theme: theme),
        ],
      ),
    );
  }

  Widget leading({OnlineGame onlineGame, ThemeData theme}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(Icons.timer, color: theme.colorScheme.onBackground),
        Text('${onlineGame.time} + ${onlineGame.increment}',
            style: theme.textTheme.bodyText1),
      ],
    );
  }

  Widget trailing({OnlineGame onlineGame, ThemeData theme}) {
    return Icon(iconInterface[onlineGame.player.length],
        color: theme.colorScheme.onBackground);
  }

  Widget main({OnlineGame onlineGame, ThemeData theme}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(onlineGame.player[0].user.userName,
            style: theme.textTheme.subtitle1),
        Text(getTimeString(onlineGame.time, onlineGame.increment),
            style: theme.textTheme.bodyText1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Widget> widgetList = onlineGames
        .map((onlineGame) => lobbyGameTile(
            context: context, onlineGame: onlineGame, theme: theme))
        .toList();
    return AlertDialog(
      titlePadding: EdgeInsets.all(10),
        title: Text('Game Lobbies',style:   theme.textTheme.subtitle1),
        contentPadding: EdgeInsets.all(5),
        content: Container(
          height: size.height * 0.9,
          width: size.width * 0.9,
          child: ListView(
            children: widgetList,
          ),
        ));
  }
}
