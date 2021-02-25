import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/screens/game_lobby_screen.dart';

import '../providers/game_provider.dart';
import '../providers/lobby_provider.dart';
import '../screens/test_screen.dart';
import '../widgets/lobby/lobby_table_mobilefull.dart';
import '../widgets/lobby/lobby_actions.dart';
import '../providers/lobby_provider.dart';
import '../widgets/lobby/lobby_select.dart';
import './create_game_screen.dart';
import 'board_screen.dart';
import '../models/online_game.dart';

class LobbyScreen extends StatefulWidget {
  static const routeName = '/lobby-screen';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  LobbyTable lobbyTable;

  @override
  void initState() {
    super.initState();
  }

  void lobbySelectPopUp(
      BuildContext context, List<OnlineGame> onlineGames, Size size) {
    showDialog(
      context: context,
      builder: (context) => LobbySelect(
        size: size,
        onlineGames: onlineGames,
        selectLobbyCall: (gameId, context) =>
            Provider.of<LobbyProvider>(context, listen: false)
                .setAndNavigateToGameLobby(context, gameId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.dashboard_sharp),
              onPressed: () =>
                  Navigator.of(context).pushNamed(DesignTestScreen.routeName)),
          Consumer<LobbyProvider>(
            builder: (context, lobbyProvider, child) => IconButton(
                icon: Icon(Icons.person),
                onPressed: () => lobbySelectPopUp(
                    context, lobbyProvider.pendingGames, size)),
          ),
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () {
              return Navigator.of(context).pushNamed(CreateGameScreen.routeName,
                  arguments: {'friend': ''});
            },
          ),
          SizedBox(width: 20)
        ],
        title: Text('Lobby'),
      ),
      body: RelativeBuilder(
          builder: (context, screenHeight, screenWidth, sy, sx) {
        return Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                width: screenWidth,
                child: Container(
                  child: LobbyTable(
                    width: screenWidth,
                    lobbyProvider: Provider.of<LobbyProvider>(context),
                    theme: Theme.of(context),
                    height: screenHeight * 0.5,
                    selectedColumns: [
                      ColumnType.Time,
                      ColumnType.AverageScore,
                      ColumnType.Mode,
                      ColumnType.UserNames
                    ],
                    gameProvider: Provider.of<GameProvider>(context),
                    onGameTap: (game) {
                      Provider.of<LobbyProvider>(context, listen: false)
                          .joinGame(game.id);
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              child: LobbyActions(),
              flex: 2,
            ),
          ],
        );
      }),
    );
  }
}
