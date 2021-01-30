import 'package:flutter/foundation.dart';

import '../models/game.dart';
import '../providers/server_provider.dart';
import '../conversion/game_conversion.dart';
import '../models/enums.dart';

class LobbyProvider with ChangeNotifier {
  List<Game> _pendingGames = [];
  List<Game> _lobbyGames = [];
  ServerProvider _serverProvider;

  List<Game> get lobbyGames {
    return [..._lobbyGames];
  }

  List<Game> get pendingGames {
    return [..._pendingGames];
  }

  String lobbyGameId;

  Game get lobbyGame {
    if (_lobbyGames.isNotEmpty && lobbyGameId != null) {
      return _lobbyGames.firstWhere((lobbyGame) => lobbyGame.id == lobbyGameId,
          orElse: () => null);
    } else {
      print('No Lobby Games Or No Current Lobby Game Picked');
      return null;
    }
  }

  bool _isInit = false;

  void update(ServerProvider serverProvider, LobbyProvider lobbyProvider) {
    _pendingGames = lobbyProvider.pendingGames;
    _lobbyGames = lobbyProvider.lobbyGames;
    _serverProvider = serverProvider;
    if (!_isInit) {
      subscribeToLobbyChannel();
    }
    notifyListeners();
  }

  void setChatId(String gameId, String chatId){
    getLobbyGame(gameId).chatId = chatId;
    notifyListeners();
  }

  void addRemoveGameListener(String gameId) {
    _serverProvider.addGameListener(
        gameId,
        (String gameId) =>
            _pendingGames.removeWhere((game) => game.id == gameId));
  }

  Future<void> fetchLobbyGames() async {
    try {
      // make http request
      final data = await _serverProvider.fetchLobbyGames();
      _lobbyGames = GameConversion.rebaseLobbyGames(data);
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('error While fetching Lobby Games', error);
    }
  }

  Future<void> fetchPendingGames() async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.fetchPendingGames();
      _pendingGames = GameConversion.rebaseLobbyGames(data);
      // adding game starts listener for Each Game
      _pendingGames.forEach((game) {
        addRemoveGameListener(game.id);
      });
    } catch (error) {
      _serverProvider.handleError('Error while Fetching Pending Games', error);
    }
  }

  Future<void> quickPairing({int time, int increment}) async {
    try {
      final Map<String, dynamic> data = await _serverProvider.quickPairing();
    } catch (error) {
      _serverProvider.handleError('Error While making Quick Paring', error);
    }
  }

  Future<void> findAGameLike(
      {int time,
      int increment,
      bool isPublic,
      bool isRated,
      bool allowPremades,
      int negRatingRange,
      PlayerColor playerColor,
      int posRatingRange}) async {
    try {
      final Map<String, dynamic> settingsBody = {
        'time': time,
        'increment': increment,
        'isPublic': isPublic,
        'isRated': isRated,
        'allowPremades': allowPremades,
        'negRatingRange': negRatingRange,
        'posRatingRange': posRatingRange,
      };
      final Map<String, dynamic> data =
          await _serverProvider.findAGameLike(settingsBody);
    } catch (error) {
      _serverProvider.handleError('Error While Finding A Game Like', error);
    }
  }

  Future<void> createGame(
      {bool isPublic,
      bool isRated,
      int increment,
      List<String> invitations,
      int time,
      bool allowPremades,
      int negRatingRange,
      int posRatingRange}) async {
    try {
      print('Trying to Create a Game');
      final Map<String, dynamic> data = await _serverProvider.createGame(
        allowPremades: allowPremades,
        isPublic: isPublic,
        increment: increment,
        isRated: isRated,
        invitations: invitations,
        negRatingRange: negRatingRange,
        posRatingRange: posRatingRange,
        time: time,
      );
      _pendingGames.add(GameConversion.rebaseOnlineGame(data['gameData'],
          data['gameData']['player'], data['gameData']['user']));
      addRemoveGameListener(data['gameData']['_id']);
      print('successfully created game');
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While creating Game', error);
    }
  }

  Future<bool> joinGame(String gameId) async {
    print('Try to Start Joining Game');
    try {
      // http request
      final Map<String, dynamic> data = await _serverProvider.joinGame(gameId);
      _pendingGames.add(GameConversion.rebaseOnlineGame(data['gameData'],
          data['gameData']['player'], data['gameData']['user']));
      addRemoveGameListener(data['gameData']['_id']);
      print('Successfully Joined Game');
      // starts game If didStart is true => 3 Player are in the Game now and the server noticed that
      return data['valid'] as bool;
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error while joining Game', error);
      return false;
    }
  }

  //################################################################################
  // SOCKET
  // Subscribe to Socket Channel
  void subscribeToLobbyChannel() {
    _serverProvider.subscribeToLobbyChannel(
      newGameCallback: (gameData) => _handleNewGameData(gameData),
      playerJoinedCallback: (gameData) => _handlePlayerJoinedGameData(gameData),
    );
  }

  // only with scores
  void _handleNewGameData(Map<String, dynamic> gameData) {
    print('Socket Handle New Game Data');
    // TODO unite filter somewhere specific
    if (_lobbyGames.map((game) => game.id).toList().contains(gameData['_id'])) {
      _lobbyGames.add(GameConversion.rebaseLobbyGame(
        gameData: gameData,
        playerData: gameData['player'],
        userData: gameData['user'],
      ));
      // print all Game Data if option is set on true
      notifyListeners();
    }
  }

  void _handlePlayerJoinedGameData(Map<String, dynamic> gameData) {
    print('Socket Handle Player Joined Lobby');
    String id = gameData['_id'];
    bool yourGame = _lobbyGames.map((game) => game.id).toList().contains(id);
    if (gameData['didStart']) {
      print('Received Game has 3 Players already and will Start');
      print('trying to remove Pending Game / Lobby Game');
      return yourGame
          ? _pendingGames.removeWhere((game) => game.id == id)
          : _lobbyGames.removeWhere((game) => game.id == id);
    }
    if (gameData['isPublic'] || yourGame) {
      Game game = yourGame ? getPendingGame(id) : getLobbyGame(id);
      game.player.add(GameConversion.rebaseOnePlayer(
        playerData: gameData['player'],
        userData: gameData['user'],
      ));
    }
    // print all game provider Data if option is set ot true
    notifyListeners();
  }

  // ###########################################################################
// Helper
  Game getPendingGame(String gameId) {
    return _pendingGames.firstWhere((game) => game.id == gameId,
        orElse: () => null);
  }

  Game getLobbyGame(String gameId) {
    return _lobbyGames.firstWhere((game) => game.id == gameId,
        orElse: () => null);
  }
}
