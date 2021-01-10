import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/widgets/basic/sorrounding_cart.dart';

typedef GameTypeCall(GameType gameType);
typedef OnlineGameSelect(int selectedGameIndex);

class BoardStateSelector extends StatelessWidget {
  final List<Game> currentGames;
  final GameTypeCall gameTypeCall;
  final int selectedOnlineGame;
  final OnlineGameSelect selectOnlineGameCall;
  final double height;
  final double width;
  final ScrollController controller;

  final double selectorHeightFraction = 0.3;
  final double gameTileSquareFraction = 0.25;
  final double selectorWidthFraction = 0.8;

  final selectedColor = Colors.orange;

  BoardStateSelector({this.controller,
    this.selectOnlineGameCall,
    this.gameTypeCall,
    this.currentGames = const [],
    this.selectedOnlineGame,
    this.width,
    this.height});

  Widget _selectedGameTile(Game game) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: selectedColor,
            width:
            (height * (selectorHeightFraction - gameTileSquareFraction) * 0.9) *
                1 /
                2,
          )),
      child: _onlineGameTile(game),
    );
  }

  Widget selectableTile(Widget child, int index) {
    return GestureDetector(
      onTap: selectOnlineGameCall(index),
      child: child,
    );
  }

  Widget _gameLabel(Game game) {
    return SorroundingCard(
      maxWidth: 400,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Center(
          child: Column(
            children: [
              Text("Time: ${game.time}"),
              Text("Increment: ${game.increment}"),
              Text(
                  "It's ${playerColorString[PlayerColor.values[game.chessMoves
                      .length % 3]]}`s turn"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _onlineSelector() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(
              color: Colors.black, //Theme Border color?
            ),
          ),
          height: height * selectorHeightFraction,
          width: width * selectorWidthFraction,
          child: currentGames.length > 0
              ? SingleChildScrollView(
            controller: controller,
            child: Column(
              children: currentGames.map((game) {
                if (game == currentGames[selectedOnlineGame]) {
                  return _selectedGameTile(game);
                }
                return selectableTile(
                    _onlineGameTile(game), currentGames.indexOf(game));
              }).toList(),
            ),
          )
              : Center(
              child: Text(
                  "No current Games, swipe left to join one in the lobby or go for local :D")),
        ),
        Container(
          padding: EdgeInsets.all(15),
          child: ElevatedButton(
            child: Text("OnlineGame"),
            onPressed: () =>
                gameTypeCall(GameType
                    .Online), //TODO in the future there has to be the index taken in account (not here tho)
          ),
        ),
      ],
    );
  }

  Widget _offlineSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: Text("Local Game"),
          onPressed: () => gameTypeCall(GameType.Local),
        ),
        ElevatedButton(
          child: Text("Analyze Game"),
          onPressed: () => gameTypeCall(GameType.Analyze),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Games')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _onlineSelector(),
          _offlineSelector(),
        ],
      ),
    );
  }
}
