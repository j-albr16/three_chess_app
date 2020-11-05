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
    lobbyTable = LobbyTable(
      width: 1000,
      height: 1000,
      onGameTap: (Game game) => print(game.isRated.toString() + "sagen alle die grad ein game angeklickt haben"),
      games: [
        Game(
            chessMoves: [],
            time: 300,
            increment: 5,
            isRated: true,
            player: [Player(playerColor: PlayerColor.white, user: User(userName: "Felix", score: 1500))]),
        Game(
            chessMoves: [],
            time: 200,
            increment: 4,
            isRated: false,
            player: [
              Player(playerColor: PlayerColor.white, user: User(userName: "Jan", score: 2890)),
              Player(playerColor: PlayerColor.white, user: User(userName: "Leo", score: 2200)),
            ])
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (lobbyTable.onGameTap == null) {
      lobbyTable.onGameTap = (game) => Provider.of<GameProvider>(context, listen: false).joynGame(game.id);
    }
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
