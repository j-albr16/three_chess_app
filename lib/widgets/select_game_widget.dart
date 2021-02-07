import 'package:flutter/material.dart';
import 'package:three_chess/models/local_game.dart';
import 'package:three_chess/models/online_game.dart';

import './basic/sorrounding_cart.dart';
import '../models/game.dart';
import '../widgets/board_state_selector.dart';
import '../helpers/constants.dart';
import '../models/piece.dart';
import '../models/enums.dart';

class SelectGame extends StatelessWidget {
  final Game game;

  final int gameIndex;

  final int currentGameIndex;

  final ConfirmGame confirmGame;
  final GameIndexCall gameIndexCall;

  final Size size;
  final ThemeData theme;

  SelectGame({
    this.gameIndexCall,
    this.size,
    this.theme,
    this.confirmGame,
    this.gameIndex,
    this.currentGameIndex,
    this.game,
  });

  Color get shadowColor {
      return currentGameIndex == gameIndex
          ? theme.colorScheme.secondary
          : Colors.black26;
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
          fit: BoxFit.none,
          child: game != null
              ? boardWidget(game.startingBoard)
              : Text('No Image', style: theme.textTheme.bodyText1),
        ),
      ),
    );
  }

  Widget firstColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Time', style: theme.textTheme.bodyText1),
        Text('Increment', style: theme.textTheme.bodyText1)
      ],
    );
  }
  Widget secondColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(game.time.toString(), style: theme.textTheme.bodyText1),
        Text( game.increment.toString() , style: theme.textTheme.bodyText1)
      ],
    );
  }
  Widget data(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        firstColumn(),
        secondColumn(),
      ],
    );
  }

  Widget onlineGameInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        data(),
        SizedBox(height: 23),
        Text(
            "It's ${playerColorString[PlayerColor.values[game.chessMoves.length % 3]]}\'s Turn", style: theme.textTheme.bodyText1),
      ],
    );
  }

  Widget gameInfo(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (game.runtimeType is LocalGame) // || game.runtimeType is AnalyzeGame)
          Text(gameTypeString[game.gameType] + ' Game',
              style: theme.textTheme.subtitle1),
        if (game.runtimeType is OnlineGame) onlineGameInfo(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: confirmGame,
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
