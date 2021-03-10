import 'package:flutter/foundation.dart';

import 'package:three_chess/providers/server_provider.dart';
import '../models/local_game.dart';
import '../helpers/json_file.dart';

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
    )
  ];
  List<LocalGame> finishedLocalGames = [];
  List<LocalGame> analyzeGames = [];

  ServerProvider _serverProvider;

  update({ServerProvider serverProvider}) {
    _serverProvider = serverProvider;
    // TODO Not implemented
  }

  Future<void> fetchLocalGames() async {
    try {
      if (kIsWeb) {
        await fetchLocalGameFromServer();
      } else {
        await fetchLocalGamesFromDisk();
      }
    } catch (error) {
      _serverProvider.handleError('Error while Fetching Local and Analyze Games', error);
    }
  }

  Future<void> fetchLocalGameFromServer() async {
    try {
      Map<String, dynamic> data = await _serverProvider.fetchLocalGames();
    } catch (error) {
      _serverProvider.handleError('Error While Fetching Local Games', error);
    }
  }

  Future<void> fetchLocalGamesFromDisk() async {
    try {
      Map analyzeGameData =
      await JsonFile(fileKey: JsonFiles.AnalyzeGame).jsonMap;
      Map localGameData = await JsonFile(fileKey: JsonFiles.LocalGame).jsonMap;
    } catch (error) {
      print(error);
    }
  }

  fetchFinishedGamesFromDisk() {}

  //Saves a LocalGame or FinishedLocalGame to the disk
  saveToDisk(LocalGame game) {}

  //Compares Current and Finished Games with the server
  //to synchronise both to the newest version of each Game
  //(That is why FinishedGames must be managed to, as they clearly indicate
  // what games are played to end)
  syncDiskToServer() {}
}
