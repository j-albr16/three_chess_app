import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/widgets/lobby_table_mobilefull.dart';
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

    super.initState();
  }

  Widget getButton(Text text, {double height, double width, Color color = Colors.deepPurpleAccent}){

    return Card(
        child: Container(
          height: height,
          width: width,
        padding: EdgeInsets.symmetric(horizontal: width * 0.1, vertical: height * 0.05),
    color: color,
    child: FittedBox(child: text),
    ),
    );
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
      body: RelativeBuilder(
          builder: (context, screenHeight, screenWidth, sy, sx) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: screenWidth,
              child: Container(
                child: LobbyTable(
                  width: screenWidth,
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
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    [
                      MapEntry([2, 0], "Bullet"),
                      MapEntry([2, 1], "Bullet"),
                      MapEntry([3, 0], "Blitz")
                    ],
                    [
                      MapEntry([4, 3], "Blitz"),
                      MapEntry([8, 0], "Rapid"),
                      MapEntry([8, 5], "Rapid")
                    ],
                    [
                      MapEntry([15, 0], "Rapid"),
                      MapEntry([30, 0], "Classical"),
                      MapEntry([30, 20], "Classical")
                    ]
                  ]
                      .map((column) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: column
                                .map(
                                  (child) => getButton(
                                      Text(child.value + " ${child.key[0]} + ${child.key[1]}"),
                                    width: screenWidth * 0.3,
                                      height: screenHeight * 0.08
                                  ),
                                )
                                .toList(),
                          ))
                      .toList()),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getButton(Text("Find a Game like"),
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.4,
                      color: Colors.deepPurple
                  ),
                  Container(width: screenWidth*0.15, color: Colors.transparent),
                  getButton(Text("Find me this Game"),
                      height: screenHeight * 0.08,
                      width: screenWidth * 0.4,
                      color: Colors.deepPurple
                    ),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
