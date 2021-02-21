import 'package:flutter/foundation.dart';

import '../models/local_game.dart';

//Testing only
import '../board/BoardStateBone.dart';


class LocalProvider with ChangeNotifier {
  List<LocalGame> localGames = [
    //testing only
    LocalGame(
    id: "1",
    didStart: true,
    startingBoard: BoardStateBone().pieces.values.toList(),
    chessMoves: [],
      followPlaying: false,
  )];
  List<LocalGame> finishedLocalGames = [];
  List<LocalGame> analyzeGames = [];

  LocalProvider();

  update(){
    // TODO Not implemented
  }

  fetchCurrentGamesFromDisk(){

  }

  fetchFinishedGamesFromDisk(){

  }

  //Saves a LocalGame or FinishedLocalGame to the disk
  saveToDisk(LocalGame game){

  }

  //Compares Current and Finished Games with the server
  //to synchronise both to the newest version of each Game
  //(That is why FinishedGames must be managed to, as they clearly indicate
  // what games are played to end)
  syncDiskToServer(){

  }
}