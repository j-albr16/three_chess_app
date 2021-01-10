import 'package:flutter/foundation.dart';

import '../providers/server_provider.dart';
import '../conversion/game_conversion.dart';
import '../providers/game_provider.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier{

  User _user;
  ServerProvider _serverProvider;
  GameProvider _gameProvider;

  User get user {
    return _user;
  }

  void update({user, serverProvider, gameProvider}){
    _gameProvider = gameProvider;
    _serverProvider = serverProvider;
    _user = user;
    if(_gameProvider?.game?.finishedGameData != null){
      _user.score = _gameProvider.game.finishedGameData[_gameProvider.player.playerColor]; // new Score of Auth user with the given Player Color
    }
    notifyListeners();
  }

  Future<void> fetchUser() async {
    try{
      final data = await _serverProvider.fetchAuthUser();
  _user = GameConversion.rebaseOneUser(data['user']);
    }catch(error){
      _serverProvider.handleError('Error While Fetching user', error);
    }
  }
    
} 