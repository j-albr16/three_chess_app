import 'package:flutter/foundation.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/local_game.dart';
import 'package:three_chess/models/online_game.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/providers/local_provider.dart';

class CurrentGamesProvider with ChangeNotifier{
  List<OnlineGame> onlineGames;
  List<LocalGame> localGames;

  List<Game> get games{
    return [...onlineGames, ...localGames];
  }

  CurrentGamesProvider({this.onlineGames = const [], this.localGames = const []});

  update(List<OnlineGame> onlineGames, List<LocalGame>  localGames){
    this.onlineGames = onlineGames;
    this.localGames = localGames;
  }

}