import 'package:flutter/material.dart';
import 'dart:math';

import '../board/BoardStateBone.dart';
import '../board/Painter.dart';
import '../board/Tiles.dart';
import '../models/local_game.dart';
import '../models/online_game.dart';

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
      return isSelected
          ? theme.colorScheme.secondary
          : Colors.black26;
  }

  bool get isSelected{
    return currentGameIndex == gameIndex;
  }

  Widget boardWidget(Map<String, Piece> currentBoard) {
    return Center(
      child: BoardPainter(
        height: 1000/2 * sqrt(3),
        width: 1000,
        pieces: currentBoard,
        tiles: Tiles(perspectiveOf: PlayerColor.white).tiles, //TODO When gameModel includes it: "game.startingColor"
      ),
    );
  }

  Widget boardImage(Size size) {
    return Center(
        child: Container(
          height: size.height/2 * sqrt(3),
          width: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius / 2),
            border: Border.all(
                color: Colors.black26, width: 2, style: BorderStyle.solid),
          ),
          child: Center(
              child: FittedBox(
                child: boardWidget(BoardStateBone.generate(
                  chessMoves: game.chessMoves,
                  customStartingBoard: Map.fromEntries(game.startingBoard.map((e) => MapEntry<String, Piece>(e.position, e))),
                  startingColor: PlayerColor.white, // TODO When gameModel includes it: "game.startingColor"
                ).pieces),
            ),
          ),
        ),
    );
  }

  Widget firstColumn(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Time', style: theme.textTheme.bodyText1,),
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
        if (game is LocalGame) // || game.runtimeType is AnalyzeGame)
          Text(gameTypeString[game.gameType] + ' Game',
              style: theme.textTheme.subtitle1),
        if (game is OnlineGame) onlineGameInfo(),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => gameIndexCall(gameIndex),
      onDoubleTap: confirmGame,
      child: SurroundingCard(
        height: size.height * 0.20,
        shadowColor: shadowColor,
        child: Row(
          children: [
            Flexible(
                child: boardImage(
                    Size(size.width * 0.35, size.height * 0.16)),
                flex: 1),
            Flexible(child: gameInfo(theme), flex: 1)
          ],
        ),
      ),
    );
  }
}
