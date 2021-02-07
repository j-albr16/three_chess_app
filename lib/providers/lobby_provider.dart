import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../models/online_game.dart';
import '../providers/server_provider.dart';
import '../conversion/game_conversion.dart';
import '../models/enums.dart';
import '../screens/game_lobby_screen.dart';
import '../providers/popup_provider.dart';

class LobbyProvider with ChangeNotifier {
  List<OnlineGame> _pendingGames = [];
  List<OnlineGame> _lobbyGames = [];
  ServerProvider _serverProvider;
  PopupProvider _popupProvider;

  List<OnlineGame> get lobbyGames {
    return [..._lobbyGames];
  }

  List<OnlineGame> get pendingGames {
    return [..._pendingGames];
  }

  String currentPendingGame;

  OnlineGame get pendingGame {
    if (_pendingGames.isNotEmpty && currentPendingGame != null) {
      return _pendingGames.firstWhere(
          (lobbyGame) => lobbyGame.id == currentPendingGame,
          orElse: () => null);
    } else {
      print('No Lobby Games Or No Current Lobby OnlineGame Picked');
      return null;
    }
  }

  bool _isInit = false;

  void update(ServerProvider serverProvider, LobbyProvider lobbyProvider,
      PopupProvider popUpProvider) {
    _pendingGames = lobbyProvider.pendingGames;
    _lobbyGames = lobbyProvider.lobbyGames;
    _popupProvider = popUpProvider;
    _serverProvider = serverProvider;
    if (!_isInit) {
      subscribeToLobbyChannel();
    }
    notifyListeners();
  }

  void setAndNavigateToGameLobby(BuildContext context, String gameId) {
    Navigator.of(context).pop();
    currentPendingGame = gameId;
    Navigator.of(context).pushNamed(GameLobbyScreen.routeName);
  }

  void setChatId(String gameId, String chatId) {
    OnlineGame game = getPendingGame(gameId);
    game.chatId = chatId;
    notifyListeners();
  }

  void addRemoveGameListener(String gameId) {
    _serverProvider.addGameListener(
        gameId,
        (String gameId) =>
            _pendingGames.removeWhere((game) => game.id == gameId));
  }

  Future<void> leaveLobby(String gameId) async {
    final Map<String, dynamic> data = await _serverProvider.leaveLobby(gameId);
  }

  Future<void> fetchLobbyGames() async {
    print('Start fetching Lobby Games');
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
    // try {
    final Map<String, dynamic> data = await _serverProvider.fetchPendingGames();
    _pendingGames = GameConversion.rebaseLobbyGames(data);
    // adding game starts listener for Each OnlineGame
    _pendingGames.forEach((game) {
      addRemoveGameListener(game.id);
    });
    // } catch (error) {
    //   _serverProvider.handleError('Error while Fetching Pending Games', error);
    // }
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
      _serverProvider.handleError(
          'Error While Finding A OnlineGame Like', error);
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
      print('Trying to Create a OnlineGame');
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
      final Map<String, dynamic> gameData = data['gameData'];
      final List playerData = gameData['player'];
      final List userData = gameData['user'];
      _pendingGames.add(GameConversion.rebaseOnlineGame(
          gameData: gameData, playerData: playerData, userData: userData));
      addRemoveGameListener(data['gameData']['_id']);
      print('successfully created game');
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While creating OnlineGame', error);
    }
  }

  Future<bool> joinGame(String gameId) async {
    print('Try to Start Joining OnlineGame');
    try {
      // http request
      final Map<String, dynamic> data = await _serverProvider.joinGame(gameId);
      final Map gameData = data['gameData'];
      String gId = gameData['_id'];
      final List playerData = gameData['player'];
      final List userData = gameData['user'];
      _pendingGames.add(GameConversion.rebaseOnlineGame(
          userData: userData, playerData: playerData, gameData: gameData));
      addRemoveGameListener(gId);
      _lobbyGames.removeWhere((game) => game.id == gId);
      print('Successfully Joined OnlineGame');
      // starts game If didStart is true => 3 Player are in the OnlineGame now and the server noticed that
      return data['valid'] as bool;
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error while joining OnlineGame', error);
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
    print('Socket Handle New OnlineGame Data');
    // TODO unite filter somewhere specific
    if (_lobbyGames.map((game) => game.id).toList().contains(gameData['_id'])) {
      _lobbyGames.add(GameConversion.rebaseLobbyGame(
        gameData: gameData,
        playerData: gameData['player'],
        userData: gameData['user'],
      ));
      // print all OnlineGame Data if option is set on true
      notifyListeners();
    }
  }

  void _handlePlayerJoinedGameData(Map<String, dynamic> gameData) {
    print('Socket Handle Player Joined Lobby');
    String id = gameData['_id'];
    bool yourGame = _lobbyGames.map((game) => game.id).toList().contains(id);
    if (gameData['didStart']) {
      print('Received OnlineGame has 3 Players already and will Start');
      print('trying to remove Pending OnlineGame / Lobby OnlineGame');
      return yourGame
          ? _pendingGames.removeWhere((game) => game.id == id)
          : _lobbyGames.removeWhere((game) => game.id == id);
    }
    if (gameData['user']['_id'] == _serverProvider.userId) {
      return;
    }
    if (gameData['isPublic'] || yourGame) {
      OnlineGame game = yourGame ? getPendingGame(id) : getLobbyGame(id);
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
  OnlineGame getPendingGame(String gameId) {
    return _pendingGames.firstWhere((game) => game.id == gameId,
        orElse: () => null);
  }

  OnlineGame getLobbyGame(String gameId) {
    return _lobbyGames.firstWhere((game) => game.id == gameId,
        orElse: () => null);
  }
}
