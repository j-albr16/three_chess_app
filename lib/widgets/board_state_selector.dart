import 'package:flutter/material.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/helpers/constants.dart';
import 'package:three_chess/widgets/basic/advanced_selection.dart';
import 'package:three_chess/widgets/basic/sorrounding_cart.dart';

import '../models/enums.dart';
import '../models/game.dart';
import '../models/enums.dart';
import '../widgets/select_game_widget.dart';
import '../widgets/basic/chess_divider.dart';

typedef void GameTypeCall(GameType gameType);
typedef void GameIndexCall(int selectedGameIndex);
typedef void ConfirmGame();

class BoardStateSelector extends StatelessWidget {
  final GameTypeCall gameTypeCall;
  final GameIndexCall gameIndexCall;
  final ConfirmGame confirmGame;

  final bool onlineGamesOpen;
  final bool localGamesOpen;
  final Function switchOnlineGames;
  final Function switchLocalGames;

  final List<Game> currentGames;
  final Game localGame;
  final Game analyzeGame;

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
    this.gameTypeCall,
    this.confirmGame,
    this.currentGames = const [],
    this.gameIndex,
    this.width,
    this.height,
    this.onlineGamesOpen,
    this.localGamesOpen,
    this.switchLocalGames,
    this.switchOnlineGames,
    this.analyzeGame,
    this.localGame,
  });

  Widget confirmSelection(ThemeData theme) {
    return FlatButton(
      minWidth: double.infinity,
      onPressed: confirmGame,
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
        SelectGame(
          size: size,
          theme: theme,
          game: analyzeGame,
          gameType: GameType.Analyze,
          confirmGame: confirmGame,
          currentGameType: gameType,
          gameTypeCall: gameTypeCall,
          currentGameIndex: gameIndex,
        ),
        SelectGame(
          size: size,
          gameTypeCall: gameTypeCall,
          gameType: GameType.Local,
          game: localGame,
          theme: theme,
          confirmGame: confirmGame,
          currentGameType: gameType,
          currentGameIndex: gameIndex,
        )
      ],
    );
  }

  Widget onlineGames(Size size, ThemeData theme) {
    return ListView(
      children: currentGames
          .asMap()
          .entries
          .map((gameEntry) => SelectGame(
                confirmGame: confirmGame,
                theme: theme,
                currentGameIndex: gameIndex,
                currentGameType: gameType,
                gameIndexCall: gameIndexCall,
                size: size,
                gameTypeCall: gameTypeCall,
                game: gameEntry.value,
                gameType: GameType.Online,
                gameIndex: gameEntry.key,
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
          if(onlineGamesOpen && currentGames.isEmpty)Text('No Online Games Available'),
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
