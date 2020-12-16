import 'package:flutter/material.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';

enum GameType { Local, Analyze, Online }
typedef GameTypeCall(GameType gameType);
typedef OnlineGameSelect(int selectedGameIndex);

class BoardStateSelector extends StatefulWidget {
  final List<Game> currentGames;
  final GameTypeCall gameTypeCall;
  final int selectedOnlineGame;
  final OnlineGameSelect selectOnlineGameCall;
  final double height;
  final double width;


  BoardStateSelector(
      {
        this.selectOnlineGameCall,
        this.gameTypeCall,
      this.currentGames = const [],
      this.selectedOnlineGame,
      this.width,
      this.height});

  @override
  _BoardStateSelectorState createState() => _BoardStateSelectorState();
}

class _BoardStateSelectorState extends State<BoardStateSelector> {
  final double selectorHeightFraction = 0.3;

  final double gameTileSquareFraction = 0.25;

  final double selectorWidthFraction = 0.8;

  final selectedColor = Colors.orange;

  Widget _selectedGameTile(Game game){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: selectedColor,
          width: widget.height * (selectorHeightFraction - gameTileSquareFraction) * 0.9,
        )
      ),
      child: _onlineGameTile(game),
    );
  }

  Widget selectableTile(Widget child, int index){
    return GestureDetector(
      onTap: widget.selectOnlineGameCall(index),
      child: child,
    );
  }

  Widget _onlineGameTile(Game game){
    return SizedBox(
      height: widget.height * gameTileSquareFraction,
      width: widget.height * gameTileSquareFraction,
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
        height: widget.height * selectorHeightFraction,
        width: widget.width * selectorWidthFraction,
        child: widget.currentGames.length > 0 ? Column(
          children: widget.currentGames.map((game) {
            if(game == widget.currentGames[widget.selectedOnlineGame]){
              return _selectedGameTile(game);
            }
            return selectableTile(_onlineGameTile(game), widget.currentGames.indexOf(game));
          }).toList(),
        ) : Text("No current Games, swipe left to join one in the lobby or go for local :D"),
      );
  }

  Widget _offlineSelector(){
    return Row(
      children: [
        ElevatedButton(
          child: Text("Local Game"),
          onPressed: widget.gameTypeCall(GameType.Local),
        ),
        ElevatedButton(
          child: Text("Analyze Game"),
          onPressed: widget.gameTypeCall(GameType.Analyze),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: Column(
        children: [
          _onlineSelector(),
          _offlineSelector(),
        ],
      ),
    );
  }
}
