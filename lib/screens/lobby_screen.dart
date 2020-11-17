import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/widgets/lobby_table.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/models/user.dart';
import 'package:three_chess/models/enums.dart';

import './create_game_screen.dart';
import 'board_screen.dart';

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
        width: 1000,
        height: 1000,
        games: [
          Game(
              isPublic: true,
              didStart: false,
              isRated: true,
              id: "boom",
              increment: 2,
              time: 500,
              chessMoves: [
                new ChessMove(
                  initialTile: 'H6',
                  nextTile: 'B4',
                  remainingTime: 6,
                )
              ],
              player: [
                new Player(
                  playerColor: PlayerColor.white,
                  isConnected: true,
                  user: new User(score: 1000, userName: 'bro'),
                ),
                new Player(
                  playerColor: PlayerColor.black,
                  isConnected: true,
                  user: new User(
                    score: 1000,
                    userName: 'Leo',
                  ),
                ),
                new Player(
                  playerColor: PlayerColor.red,
                  isConnected: true,
                  user: new User(score: 1000, userName: 'Jan'),
                ),
              ])
        ],
        onGameTap: (game) =>
            Provider.of<GameProvider>(context, listen: false).joinGame(game.id),
      );
      gameProvider.fetchGames();
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
      body: LobbyTable(
        width: 1000,
        height: 1000,
        games: Provider.of<GameProvider>(context).games ?? [],
        onGameTap: (game) {

          Provider.of<GameProvider>(context, listen: false).joinGame(game.id).then((_){
            if (Provider.of<GameProvider>(context, listen: false).game !=
                null) {
              Navigator.of(context).pushNamed(BoardScreen.routeName);
            }
          });
        },
      ),
    );
  }
}
