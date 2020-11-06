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
    Future.delayed(Duration.zero).then((_) {
      GameProvider gameProvider =
          Provider.of<GameProvider>(context, listen: false);
      lobbyTable = LobbyTable(
        onGameTap: (game) => gameProvider.joynGame(game.id),
        games: [],
        width: 1000,
        height: 1000,
      );
      gameProvider.fetchGames();
      Provider.of<GameProvider>(context, listen: false).addListener(() {
        lobbyTable.updatedGames =
            Provider.of<GameProvider>(context, listen: false).games;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.add),
            onPressed: () {
              return Navigator.of(context)
                  .pushNamed(CreateGameScreen.routeName);
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
