import 'package:flutter/material.dart';
import 'package:three_chess/models/game.dart';

enum GameType { Local, Analyze, Online }
typedef GameTypeCall(GameType gameType);

class BoardStateSelector extends StatelessWidget {
  final List<Game> currentGames;
  final GameTypeCall gameTypeCall;
  final int selectedOnlineGame;
  final double height;
  final double width;

  final double selectorHeightFraction = 0.3;
  final double gameTileSquareFraction = 0.25;
  final double selectorWidthFraction = 0.8;



  BoardStateSelector(
      {this.gameTypeCall,
      this.currentGames,
      this.selectedOnlineGame,
      this.width,
      this.height});

  Widget _selectedGameTile(Game game){
    return Container();
  }

  Widget _onlineGameTile(Game game){
    return Container();
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
        child: Column(
          children: currentGames.map((game) {
            if(game == currentGames[selectedOnlineGame]){
              return _selectedGameTile(game);
            }
            return _onlineGameTile(game);
          }).toList(),
        ),
      );
  }

  Widget _offlineSelector(){
    return Container();
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
