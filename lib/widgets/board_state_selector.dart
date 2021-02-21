import 'package:flutter/material.dart';
import '../data/board_data.dart';
import '../helpers/constants.dart';
import '../models/game.dart';
import '../models/online_game.dart';
import '../widgets/basic/advanced_selection.dart';

import '../models/enums.dart';
import '../models/online_game.dart';
import '../models/enums.dart';
import '../models/local_game.dart';
import '../widgets/select_game_widget.dart';
import '../widgets/basic/chess_divider.dart';

typedef void GameCall(Game game);
typedef void GameIndexCall(int selectedGameIndex);
typedef void ConfirmGame();

class BoardStateSelector extends StatelessWidget {
  final GameCall confirmGame;
  final GameIndexCall gameIndexCall;

  final bool onlineGamesOpen;
  final bool localGamesOpen;
  final Function switchOnlineGames;
  final Function switchLocalGames;

  final List<Game> currentGames;

  final int gameIndex;
  final GameType gameType;

  final double height;
  final double width;
  final ScrollController controller;

  final double selectorHeightFraction = 0.3;
  final double gameTileSquareFraction = 0.25;
  final double selectorWidthFraction = 0.8;

  final selectedColor = Colors.orange;

  BoardStateSelector({
    this.gameType,
    this.controller,
    this.gameIndexCall,
    this.confirmGame,
    this.currentGames = const [],
    this.gameIndex,
    this.width,
    this.height,
    this.onlineGamesOpen,
    this.localGamesOpen,
    this.switchLocalGames,
    this.switchOnlineGames,
  });

  Widget confirmSelection(ThemeData theme) {
    return FlatButton(
      minWidth: double.infinity,
      onPressed: () => confirmGame(gameIndex != null ? currentGames[gameIndex] : null),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      color: theme.colorScheme.secondary,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Confirm Selection'),
      ),
    );
  }

Widget localGames(Size size, ThemeData theme) {
    return Column(
      children: [
        // SelectGame(
        //   size: size,
        //   theme: theme,
        //   game: ,
        //   confirmGame: () => confirmGame(),
        //   currentGameIndex: gameIndex,
        //   gameIndex: ,
        //   gameIndexCall: gameIndexCall,
        // ),
        // SelectGame(
        //   size: size,
        //   game: ,
        //   theme: theme,
        //   confirmGame: () => confirmGame(),
        //   currentGameIndex: gameIndex,
        //   gameIndex: ,
        //   gameIndexCall: gameIndexCall,
        // ),
        ...currentGames.where((game) => (game.runtimeType == LocalGame)).map((game) =>
            SelectGame(
              size: size,
              game: game,
              theme: theme,
              confirmGame: () => confirmGame(game),
              currentGameIndex: gameIndex,
              gameIndex: currentGames.indexOf(game),
              gameIndexCall: gameIndexCall,
            )
        ).toList(),
      ],
    );
  }

  Widget onlineGames(Size size, ThemeData theme) {
    return ListView(
      children: currentGames.where((game) => game.runtimeType == OnlineGame).map(
              (gameEntry) => SelectGame(
        confirmGame: () => confirmGame(gameEntry),
        theme: theme,
        currentGameIndex: gameIndex,
        gameIndexCall: gameIndexCall,
        size: size,
        game: gameEntry,
        gameIndex: currentGames.indexOf(gameEntry),
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Container(
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          AdvancedSelection(
            updateSelection: switchOnlineGames,
            nameSelected: 'Hide Online Games',
            nameDeselected: 'Show Online Games',
            isSelected: onlineGamesOpen,
          ),
          // ChessDivider(),
          if(onlineGamesOpen && currentGames.where((element) => element.runtimeType == OnlineGame).toList().isEmpty)Text('No Online Games Available'),
          if (onlineGamesOpen) Flexible(child: onlineGames(size, theme), flex: 1),
          // ChessDivider(),
          AdvancedSelection(
            isSelected: localGamesOpen,
            nameDeselected: 'Show Local Games',
            nameSelected: 'Hide Local Games',
            updateSelection: switchLocalGames,
          ),
          // ChessDivider(),
          if (localGamesOpen) localGames(size, theme),
          if (gameType != null) confirmSelection(theme),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}
