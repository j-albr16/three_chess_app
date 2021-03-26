import 'dart:async';
import 'package:flutter/foundation.dart';

import './server_provider.dart';

class OnlineProvider with ChangeNotifier {
  bool inGame;
  ServerProvider _serverProvider;
  Timer _keepOnlineTimer;
  Timer _getCountTimer;
  Timer _getPossibleMatchesTimer;
  Timer _stopWatchTimer;

  int _usersCount = 0;
  int _playerCount = 0;
  int _gamesCount = 0;

  int possibleMatches = 0;

  int _stopWatch = 0;

  int get stopWatch {
    return _stopWatch;
  }

  void setPossibleMatches(int amount) {
    possibleMatches = amount;
  }

  int get usersCount {
    return _usersCount;
  }

  int get playerCount {
    return _playerCount;
  }

  int get gamesCount {
    return _gamesCount;
  }

  void update({hasGame, server}) {
    _serverProvider = server;
    setTimer(4);
  }

  Future<void> setTimer(int seconds) async {
    print('Set Timer');
    try {
      _keepOnlineTimer?.cancel();
      _keepOnlineTimer =
          new Timer.periodic(Duration(seconds: seconds), (Timer timer) async {
        final data = await _serverProvider.onlineStatusUpdate();
      });
    } catch (error) {
      _serverProvider.handleError('Error while Setting Online Timer', error);
    }
  }

  Future<void> setGetPossibleMatchesTimer(
      int time, int increment, int defaultValue) async {
    print('Getting Possible Matches Timer');
    try {
      possibleMatches = defaultValue;
      _getPossibleMatchesTimer?.cancel();
      _getPossibleMatchesTimer =
          new Timer.periodic(Duration(seconds: 2), (Timer timer) async {
        final data = await _serverProvider.getPossibleMatches(time, increment);
        possibleMatches = data['possibleMatches'];
        notifyListeners();
      });
    } catch (e) {
      _serverProvider.handleError(
          'Error while Setting Get Possible Matches Timer', e);
    }
  }

  Future<void> setStopWatch() async {
    _stopWatchTimer?.cancel();
    _stopWatchTimer = new Timer.periodic(Duration(seconds: 1), (timer) async {
      _stopWatch++;
      notifyListeners();
    });
  }

  Future<void> stopStopWatch() async {
    _stopWatchTimer?.cancel();
    _stopWatch = 0;
  }

  void stopGetPossibleMatchesTimer() {
    _getPossibleMatchesTimer?.cancel();
  }

  Future<void> getCount() async {
    try {
      _getCountTimer?.cancel();
      _getCountTimer =
          new Timer.periodic(Duration(seconds: 3), (Timer timer) async {
        // TODO
        final data = await _serverProvider.getCount();
        _gamesCount = data['games'];
        _usersCount = data['users'];
        _playerCount = data['player'];
      });
    } catch (error) {
      _serverProvider.handleError('Error while getting Count', error);
    }
  }

  void stopCount() {
    _getCountTimer?.cancel();
  }
}
