import 'package:flutter/foundation.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool buildScreen = false;
  GameType gameType;
  int gameIndex;

  bool isInit = false;

  Future<void> fetchLocalGames() {
    if (isInit) {
      return null;
    }
    Future.delayed(Duration.zero).then((_) async {
      if (kIsWeb) {
        ServerProvider serverProvider = Provider.of(context, listen: false);
        try {
          Map<String, dynamic> localGames =
              await serverProvider.fetchLocalGames();
          analyzeGameData = localGames['analyzeGame'];
          localGameData = localGames['localGame'];
        } catch (error) {
          serverProvider.handleError('Error While Fetching Local Games', error);
        }
      } else {
        try {
          analyzeGameData =
              await JsonFile(fileKey: JsonFiles.AnalyzeGame).jsonMap;
          localGameData = await JsonFile(fileKey: JsonFiles.LocalGame).jsonMap;
        } catch (error) {
          localGameData = null;
          analyzeGameData = null;
          print(error);
        }
      }
    }).then((_) => setState(() {
          isInit = true;
        }));
  }

  void _confirmGame() {
    setState(() {
      buildScreen = true;
    });
  }

  void _selectGameType(GameType newGameType) {
    setState(() {
      gameType = newGameType;
    });
  }

  void _selectOnlineGame(newIndex) {
    setState(() {
      gameIndex = newIndex;
    });
  }

  _buildSelectedScreen() {
    return GameBoardScreen(gameType: gameType);
  }

  _buildChooseScreen() {
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      return Consumer<GameProvider>(
        builder: (context, gameProvider, child) => BoardStateSelector(
          controller: controller,
          width: screenWidth,
          height: screenHeight,
          analyzeGame: GameConversion.rebaseWholeGame(analyzeGameData),
          localGame: GameConversion.rebaseWholeGame(localGameData),
          confirmGame: _confirmGame,
          localGamesOpen: localGamesOpen,
          onlineGamesOpen: onlineGamesOpen,
          gameType: gameType,
          switchLocalGames: () =>
              setState(() => localGamesOpen = !localGamesOpen),
          switchOnlineGames: () =>
              setState(() => onlineGamesOpen = !onlineGamesOpen),
          currentGames: gameProvider.game != null ? [gameProvider.game] : [],
          gameTypeCall: _selectGameType,
          gameIndex: gameIndex,
          gameIndexCall: _selectOnlineGame,
        ),
      );
    });
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
        appBar: !buildScreen
            ? AppBar(
                title: Text('Select Game'),
              )
            : null,
        body: FutureBuilder(
            future: fetchLocalGames(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return Container(
                  child: buildScreen
                      ? _buildSelectedScreen()
                      : _buildChooseScreen(),
                );
              }
            }),
      ),
    );
  }
}
