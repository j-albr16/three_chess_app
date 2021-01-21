import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../providers/game_provider.dart';
import '../widgets/lobby/lobby_table_mobilefull.dart';
import '../widgets/lobby/lobby_actions.dart';

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
                  .pushNamed(CreateGameScreen.routeName, arguments: {'friend': ''});
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
                      Provider.of<GameProvider>(context, listen: false)
                          .joinGame(game.id)
                          .then((_) {
                        if (Provider.of<GameProvider>(context, listen: false)
                                .game !=
                            null) {
                          Navigator.of(context).pushNamed(BoardScreen.routeName);
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            Flexible(child: LobbyActions(), flex: 2,
            ),
          ],
        );
      }),
    );
  }
}
