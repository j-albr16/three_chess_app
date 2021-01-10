import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/enums.dart';

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



  BoardStateSelector(
      {
        this.controller,
        this.selectOnlineGameCall,
        this.gameTypeCall,
      this.currentGames = const [],
      this.selectedOnlineGame,
      this.width,
      this.height});

  Widget _selectedGameTile(Game game){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedColor,
          width: height * (selectorHeightFraction - gameTileSquareFraction) * 0.9,
        )
      ),
      child: _onlineGameTile(game),
    );
  }

  Widget selectableTile(Widget child, int index){
    return GestureDetector(
      onTap: selectOnlineGameCall(index),
      child: child,
    );
  }

  Widget _onlineGameTile(Game game){
    return SizedBox(
      height: height * gameTileSquareFraction,
      width: height * gameTileSquareFraction,
      child: FittedBox(
        child: Row(
          children: [
            Text("Time: ${game.time}"),
            Text("Increment: ${game.increment}"),
            Text("It's ${playerColorString[PlayerColor.values[game.chessMoves.length%3]]}"),
          ],
        ),
      ),
    );
  }

  Widget _onlineSelector(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(
          color: Colors.white, //Theme Border color?
      ),),
        height: height * selectorHeightFraction,
        width: width * selectorWidthFraction,
        child: currentGames.length > 0 ? SingleChildScrollView(
          controller: controller,
          child: Column(
            children: currentGames.map((game) {
              if(game == currentGames[selectedOnlineGame]){
                return _selectedGameTile(game);
              }
              return selectableTile(_onlineGameTile(game), currentGames.indexOf(game));
            }).toList(),
          ),
        ) : Text("No current Games, swipe left to join one in the lobby or go for local :D"),
      );
  }

  Widget _offlineSelector(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          child: Text("Local Game"),
          onPressed: gameTypeCall(GameType.Local),
        ),
        ElevatedButton(
          child: Text("Analyze Game"),
          onPressed: gameTypeCall(GameType.Analyze),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Column(
        children: [
          _onlineSelector(),
          _offlineSelector(),
        ],
      ),
    );
  }
}
