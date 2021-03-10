import 'package:flutter/foundation.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/local_game.dart';
import 'package:three_chess/providers/current_games_provider.dart';
import 'package:three_chess/providers/local_provider.dart';
import 'package:three_chess/screens/screen_bone.dart';
import '../providers/ClientGameProvider.dart';
import 'dart:developer';

import '../models/enums.dart';
import '../screens/board_subscreens/game_board_screen.dart';
import '../widgets/board_state_selector.dart';
import '../models/enums.dart';
import '../providers/game_provider.dart';
import '../helpers/json_file.dart';
import '../models/game.dart';
import '../conversion/game_conversion.dart';
import '../providers/server_provider.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  ScrollController controller;

  Map<String, dynamic> analyzeGameData;
  Map<String, dynamic> localGameData;

  bool localGamesOpen = true;
  bool onlineGamesOpen = true;

  GameType gameType;
  int gameIndex;

  bool isInit = false;


  void _confirmGame(Game game, context) {
    setState(() {
      Provider.of<ClientGameProvider>(context, listen: false).setClientGame(game, context: context);
    });
  }

  void _selectGameType(GameType newGameType) {
    setState(() {
      gameType = newGameType;
    });
  }

  void _selectGame(newIndex) {
    setState(() {
      gameIndex =  newIndex;
    });
}

  _buildSelectedScreen(Game game) {
    return GameBoardScreen(game: game);
  }

  _buildChooseScreen() {
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      return Consumer<CurrentGamesProvider>(
        builder: (context, currentGamesProvider, child) {
          print(currentGamesProvider.games.where((e) => e.runtimeType == LocalGame).isNotEmpty);
          return BoardStateSelector(
            controller: controller,
            width: screenWidth,
            height: screenHeight,
            // analyzeGame: GameConversion.rebaseOnlineGame(analyzeGameData),
            // localGame: GameConversion.rebaseOnlineGame(localGameData, localGameData[]),
            confirmGame: (Game game, context) => _confirmGame(game, context),
            localGamesOpen: localGamesOpen,
            onlineGamesOpen: onlineGamesOpen,
            gameType: gameType,
            switchLocalGames: () =>
                setState(() => localGamesOpen = !localGamesOpen),
            switchOnlineGames: () =>
                setState(() => onlineGamesOpen = !onlineGamesOpen),
            currentGames: currentGamesProvider.games,
            gameIndex: gameIndex,
            gameIndexCall: _selectGame,

          );

        }
      );
    });
  }

  Future<void> doNothing(){
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          gameIndex = null;
          gameType = null;
        });
      },
      child: Scaffold(
        appBar: !(Provider.of<ClientGameProvider>(context).clientGame != null)
            ? AppBar(
                title: Text('Select Game'),
              )
            : null,
        body: FutureBuilder(
            future: doNothing(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Container(
                  child: Provider.of<ClientGameProvider>(context).clientGame != null
                      ? _buildSelectedScreen(Provider.of<ClientGameProvider>(context).clientGame.game)
                      : _buildChooseScreen(),
                );
              }
            }),
      ),
    );
  }
}
