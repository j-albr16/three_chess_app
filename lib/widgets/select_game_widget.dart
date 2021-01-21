import 'package:flutter/material.dart';

import './basic/sorrounding_cart.dart';
import '../models/game.dart';
import '../widgets/board_state_selector.dart';
import '../helpers/constants.dart';
import '../models/piece.dart';
import '../models/enums.dart';

class SelectGame extends StatelessWidget {
  final Game game;

  final int gameIndex;
  final GameType gameType;

  final int currentGameIndex;
  final GameType currentGameType;

  final ConfirmGame confirmGame;
  final GameTypeCall gameTypeCall;
  final GameIndexCall gameIndexCall;

  final Size size;
  final ThemeData theme;

  SelectGame({
    this.gameIndexCall,
    this.gameTypeCall,
    this.size,
    this.theme,
    this.currentGameType,
    this.confirmGame,
    this.gameType,
    this.gameIndex,
    this.currentGameIndex,
    this.game,
  });

  Color get shadowColor {
    if (gameType == GameType.Online) {
      return gameIndex == currentGameIndex
          ? theme.colorScheme.secondary
          : Colors.black26;
    } else {
      return currentGameType == gameType
          ? theme.colorScheme.secondary
          : Colors.black26;
    }
  }

  Widget boardWidget(List<Piece> currentBoard) {
    return Center(
      child: Text('Need to Implement Board Image'),
    );
  }

  Widget boardImage(Size size, ThemeData theme) {
    return Center(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornerRadius / 2),
          border: Border.all(
              color: Colors.black26, width: 2, style: BorderStyle.solid),
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: game != null
              ? boardWidget(game.startingBoard)
              : Text('No Image', style: theme.textTheme.bodyText1),
        ),
      ),
    );
  }

  Widget advancedGameInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("     Time: ${game.time}"),
        Text("Increment: ${game.increment}"),
        Text(
            "It's ${playerColorString[PlayerColor.values[game.chessMoves.length % 3]]}\'s Turn"),
      ],
    );
  }

  Widget gameInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (gameType == GameType.Local || gameType == GameType.Analyze)
          Text(gameTypeString[gameType] + ' Game',
              style: theme.textTheme.subtitle1),
        if (gameType == GameType.Online) advancedGameInfo(),
      ],
    );
  }

  void checkForConfirm() {
    if (gameType == GameType.Online) {
      if (gameType != currentGameType || currentGameIndex != gameIndex) {
        gameIndexCall(gameIndex);
        gameTypeCall(gameType);
      } else {
        if (game != null) {
          confirmGame();
          print('Game is Null. Dont Confirm Selection');
        }
      }
    } else {
      if (gameType != currentGameType) {
        gameTypeCall(gameType);
      } else {
        if (game != null) {
          confirmGame();
        } else {
          print('Game is Null. Dont Confirm Selection');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => checkForConfirm(),
      child: SorroundingCard(
        height: size.height * 0.20,
        shadowColor: shadowColor,
        child: Row(
          children: [
            Flexible(
                child: boardImage(
                    Size(size.width * 0.35, size.height * 0.16), theme),
                flex: 1),
            Flexible(child: gameInfo(theme), flex: 1)
          ],
        ),
      ),
    );
  }
}
