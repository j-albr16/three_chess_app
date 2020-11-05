import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/widgets/lobby_table.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/models/user.dart';
import 'package:three_chess/models/enums.dart';

import './create_game_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
    GameProvider gameProviderListner = Provider.of<GameProvider>(context);

    if(lobbyTable == null) {
      lobbyTable = LobbyTable(
        onGameTap: (game) => gameProvider.joynGame(game.id),
    games: [],
    width: 1000,
    height: 1000,
      );
      gameProvider.fetchGames();
    }
    lobbyTable.updatedGames = gameProviderListner.games;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () {
              return Navigator.of(context).pushNamed(CreateGameScreen.routeName);
            },
          ),
          SizedBox(width: 20)
        ],
        title: Text('Lobby'),
      ),
      body: lobbyTable,
    );
  }
}
