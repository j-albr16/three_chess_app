import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart';

import '../models/online_game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';
import '../providers/server_provider.dart';
import '../models/enums.dart';
import '../conversion/game_conversion.dart';
import '../models/request.dart';
import '../data/server.dart';
import '../helpers/user_acc.dart';

const String SERVER_URL = SERVER_ADRESS;

const printCreateGame = true;
const printJoinGame = true;
const printFetchGame = true;
const printFetchGameRawData = true;
const printFetchGames = false;
const printGameSocket = true;
const printGameMove = true;

class GameProvider with ChangeNotifier {
  String _userId = constUserId;
  bool _wasInit = false;

  Player get player {
    Player player;
    if (onlineGame != null) {
      player = onlineGame?.player
          ?.firstWhere((e) => e?.user?.id == _userId, orElse: () => null);
    }
    return player;
  }

  List<OnlineGame> _onlineGames = [];
  ServerProvider _serverProvider;

  void update({
    ServerProvider serverProvider,
    GameProvider gameProvider,
  }) {
    _onlineGames = gameProvider.onlineGames;
    _serverProvider = serverProvider;
    if (!_wasInit) {
      _subscribeToAuthUserChannel2();
    }
    notifyListeners();
  }

// providing game data for screen
  List<OnlineGame> get onlineGames {
    return [..._onlineGames];
  }

  bool hasPopup = false;
  bool hasMessage = false;
  String popUpMessage;
  String currentGameId;

  bool get hasGame {
    return currentGameId != null;
  }

  OnlineGame get onlineGame {
    if (currentGameId != null && _onlineGames.isNotEmpty) {
      return _onlineGames.firstWhere((game) => game.id == currentGameId,
          orElse: () => null);
    } else {
      print('No GameId or No online Games Availbale');
      return null;
    }
  }

  void setChatId(String gameId, String chatId) {
    _onlineGames[getGameIndex(gameId)].chatId = chatId;
    notifyListeners();
  }

  void _subscribeToAuthUserChannel2() {
    print('Did Subscribe to Auth User Channel 2');
    _serverProvider.subscribeToAuthUserChannel2(
        gameStartsCallback: (gameData) => _handleGameStarts(gameData));
  }

  void subscribeToGameChannel() {
    print('Did Subscribe to OnlineGame Lobby Channel');
    _serverProvider.subscribeToGameChannel(
      gameId: onlineGame.id,
      // TODO
      moveMadeCallback: (moveData, gameId) => _handleMoveData(moveData, gameId),
      requestCancelledCallback: (data, gameId) =>
          _handleRequestCancelled(data, gameId),
      remiAcceptCallback: (userId, gameId) => _handleRemiAccept(userId, gameId),
      remiDeclineCallback: (userId, gameId) =>
          _handleRemiDecline(userId, gameId),
      remiRequestCallback: (userId, chessMove, gameId) =>
          _handleRemiRequest(userId, chessMove, gameId),
      surrenderDeclineCallback: (userId, gameId) =>
          _handleSurrenderDecline(userId, gameId),
      surrenderRequestCallback: (userId, chessMove, gameId) =>
          _handleSurrenderRequest(userId, chessMove, gameId),
      takeBackAcceptCallback: (userId, gameId) =>
          _handleTakeBackAccept(userId, gameId),
      takeBackDeclineCallback: (userId, gameId) =>
          _handleTakeBackDecline(userId, gameId),
      takeBackRequestCallback: (userId, chessMove, gameId) =>
          _handleTakeBackRequest(userId, chessMove, gameId),
      takenBackCallback: (userId, chessMove, gameId) =>
          _handleTakenBack(userId, chessMove, gameId),
      gameFinishedCallback: (data, gameId) => _handleGameFinished(data, gameId),
      surrenderFailedCallback: (gameId) => _handleSurrenderFailed(gameId),
      playerIsOnlineCallback: (userId) => _handlePlayerIsOnline(userId),
      playerIsOfflineCallback: (userId, expiryDate) =>
          _handlePlayerIsOffline(userId, expiryDate),
    );
  }

  void setGameId(String gameId, {bool notify}) {
    currentGameId = gameId;
    if (notify) {
      notifyListeners();
    }
  }

  void removeGame() {
    _onlineGames.remove(onlineGame);
    notifyListeners();
  }

  void leaveGame(String gameId) {
    _onlineGames.removeWhere((game) => game.id == gameId);
    notifyListeners();
  }

  Future<bool> sendMove(ChessMove chessMove) async {
    try {
      final data = await _serverProvider.sendMove(chessMove, currentGameId);
      return data['moveValid'];
    } catch (error) {
      _serverProvider.handleError('Error While creating OnlineGame', error);
      return false;
    }
  }

  Future<void> fetchOnlineGame() async {
    try {
      // make http request
      final Map<String, dynamic> data =
          await _serverProvider.fetchOnlineGame(currentGameId);
      // Logic Starts
      _onlineGames.removeWhere((game) => game.id == data['gameData']['_id']);
      _onlineGames.add(GameConversion.rebaseOnlineGame(data['gameData'],
          data['gameData']['player'], data['gameData']['user']));
      if (_onlineGames.last.id == data['gameData']['_id']) {
        subscribeToGameChannel();
      }
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error whileFetching OnlineGame', error);
    }
  }

  Future<void> fetchOnlineGames() async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.fetchOnlineGames();
      _onlineGames = GameConversion.rebaseOnlineGames(data);
    } catch (error) {
      _serverProvider.handleError('Error While Fetching Online Games', error);
    }
  }

  Future<void> requestSurrender() async {
    String message = 'Could not send Surrender Request';
    try {
      message = await _serverProvider.requestSurrender(currentGameId);
    } catch (error) {
      _serverProvider.handleError('Error While Requesting Surrender', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> acceptSurrender() async {
    String message = 'Could not Accept Surrender';
    try {
      print('Accept Surrender ');
      message = await _serverProvider.acceptSurrender(currentGameId);
    } catch (error) {
      _serverProvider.handleError('Error while Accepting Surrender', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> declineSurrender() async {
    String message = 'Could not Decline Surrender';
    try {
      print('Decline Surrender');
      Map<String, dynamic> data =
          await _serverProvider.declineSurrender(currentGameId);
      message = data['message'];
    } catch (error) {
      _serverProvider.handleError('Error while Decline Surrender', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> requestRemi() async {
    String message = 'Could not send Remi Request';
    try {
      message = await _serverProvider.requestRemi(currentGameId);
    } catch (error) {
      _serverProvider.handleError('Error while Requesting Remi', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> acceptRemi() async {
    String message = 'Could not Accept Remi';
    try {
      print('Accept Remi');
      message = await _serverProvider.acceptRemi(currentGameId);
    } catch (error) {
      _serverProvider.handleError('Error while Accepting Remi', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> declineRemi() async {
    String message = 'Could not Decline Remi';
    try {
      print('Decline Remi');
      Map<String, dynamic> data =
          await _serverProvider.declineRemi(currentGameId);
      message = data['message'];
    } catch (error) {
      _serverProvider.handleError('Error while declining Remi', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> requestTakeBack() async {
    String message = 'Could not send Take Back Request';
    try {
      message = await _serverProvider.requestTakeBack(currentGameId);
    } catch (error) {
      _serverProvider.handleError('Error while Declining Take Back', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> acceptTakeBack() async {
    String message = 'Could not Accept Take Back';
    try {
      print('Accept Take Back');
      message = await _serverProvider.acceptTakeBack(currentGameId);
    } catch (error) {
      _serverProvider.handleError('Error while accepting Take Back', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  Future<void> declineTakeBack() async {
    String message = 'Could not Decline Take Back';
    try {
      print('Decline Take Back');
      Map<String, dynamic> data =
          await _serverProvider.declineTakeBack(currentGameId);
      message = data['message'];
    } catch (error) {
      _serverProvider.handleError('Error while declining Take Back', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  // TODO Remove
  Future<void> createTestGame() async {
    try {
      await _serverProvider.createTestGame();
    } catch (error) {
      _serverProvider.handleError('Error while declining Take Bakc', error);
    }
  }

  Future<void> cancelRequest(RequestType requestType) async {
    String message = 'Could not Cancel Request';
    try {
      Map<String, dynamic> data =
          await _serverProvider.cancelRequest(requestType.index, currentGameId);
      message = data['message'];
      print(message);
      if (data['didRemove']) {
        _onlineGames[getGameIndex(currentGameId)].requests.removeWhere(
            (request) =>
                request.requestType == requestType &&
                request.playerResponse[ResponseRole.Create] ==
                    player?.playerColor);
      }
    } catch (error) {
      _serverProvider.handleError(
          'Error while Canceling Request of request Type $requestType', error);
    } finally {
      hasMessage = true;
      popUpMessage = message;
      notifyListeners();
    }
  }

  void _handlePlayerIsOnline(String userId) {
    _onlineGames.forEach((game) {
      Player player = game.player
          .firstWhere((player) => player.user.id == userId, orElse: () => null);
      player?.isOnline = true;
    });
    notifyListeners();
  }

  void _handlePlayerIsOffline(String userId, String expiryDate) {
    _onlineGames.forEach((game) {
      Player player = game.player
          .firstWhere((player) => player.user.id == userId, orElse: () => null);
      player?.isOnline = false;
      // game.endGameExpiry = DateTime.parse(expiryDate);
    });
    notifyListeners();
  }

  void _handleMoveData(Map<String, dynamic> moveData, String gameId) {
    print('Socket Handling New Move');
    OnlineGame onlineGame = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        PlayerColor.values[onlineGame.chessMoves.length % 3];
    moveData['playerColor'] = playerColor;
    onlineGame.chessMoves.add(GameConversion.rebaseOneMove(moveData));
    // print all OnlineGame Provider Data if optin was set to true
    if (moveData['emptyMove']) {
      onlineGame.chessMoves.add(new ChessMove(
        initialTile: '',
        nextTile: '',
        remainingTime: onlineGame
            .chessMoves[onlineGame.chessMoves.length - 4].remainingTime,
      ));
    }
    notifyListeners();
  }

  void _handleSurrenderRequest(String userId, int chessMove, String gameId) {
    print('Socket Handling Surrender Request');
    Map<ResponseRole, PlayerColor> playerResponse = {};
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    playerResponse[ResponseRole.Create] = playerColor;
    game.requests.add(new Request(
      moveIndex: chessMove,
      playerResponse: playerResponse,
      requestType: RequestType.Surrender,
    ));
    popUpMessage = 'Surrender Request was Made';
    hasMessage = true;
    notifyListeners();
  }

  void _handleSurrenderDecline(String userId, String gameId) {
    print('Socket Handling Surrender Decline');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    GameConversion.getRequestFromRequestType(RequestType.Surrender, game)
        .playerResponse[ResponseRole.Decline] = playerColor;
    notifyListeners();
  }

  void _handleSurrenderFailed(String gameId) {
    print('Socket Handling Surrender Failed');
    _onlineGames[getGameIndex(gameId)]
        .requests
        .removeWhere((request) => request.requestType == RequestType.Surrender);
    notifyListeners();
  }

  void _handleRemiRequest(String userId, int chessMove, String gameId) {
    print('Socket Handle Remi Request');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    Map<ResponseRole, PlayerColor> playerResponse = {};
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player) ??
            PlayerColor.none;
    playerResponse[ResponseRole.Create] = playerColor;
    print(playerResponse[ResponseRole.Create]);
    game.requests.add(new Request(
      moveIndex: chessMove,
      playerResponse: playerResponse,
      requestType: RequestType.Remi,
    ));
    popUpMessage = 'Remi Request was Made';
    hasMessage = true;
    notifyListeners();
  }

  void _handleRemiAccept(String userId, String gameId) {
    print('Socket Handling Remi Accept');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    GameConversion.getRequestFromRequestType(RequestType.Remi, game)
        .playerResponse[ResponseRole.Accept] = playerColor;
    notifyListeners();
  }

  void _handleRemiDecline(String userId, String gameId) {
    print('Socket Handling Remi Decline');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    GameConversion.getRequestFromRequestType(RequestType.Remi, game)
        .playerResponse[ResponseRole.Decline] = playerColor;
    game.requests
        .removeWhere((request) => request.requestType == RequestType.Remi);
    notifyListeners();
  }

  void _handleTakeBackRequest(String userId, int chessMove, String gameId) {
    print('Socket Handling Take Back Request');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    Map<ResponseRole, PlayerColor> playerResponse = {};
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    playerResponse[ResponseRole.Create] = playerColor;
    game.requests.add(new Request(
      moveIndex: chessMove,
      playerResponse: playerResponse,
      requestType: RequestType.TakeBack,
    ));
    popUpMessage = 'Take Back Request was Made';
    hasMessage = true;
    notifyListeners();
  }

  void _handleTakeBackAccept(String userId, String gameId) {
    print('Socket Handle Take Back Accept');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    GameConversion.getRequestFromRequestType(RequestType.TakeBack, game)
        .playerResponse[ResponseRole.Accept] = playerColor;
    notifyListeners();
  }

  void _handleTakeBackDecline(String userId, String gameId) {
    print('Socket Handle Take Back Decline');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor playerColor =
        GameConversion.getPlayerColorFromUserId(userId, game.player);
    GameConversion.getRequestFromRequestType(RequestType.TakeBack, game)
        .playerResponse[ResponseRole.Decline] = playerColor;
    game.requests
        .removeWhere((request) => request.requestType == RequestType.TakeBack);
    notifyListeners();
  }

  void _handleTakenBack(String userId, int chessMove, String gameId) {
    print('Socket Handle Taken Back');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    game.chessMoves.removeRange(chessMove, game.chessMoves.length);
    game.requests
        .removeWhere((request) => request.requestType == RequestType.TakeBack);
    notifyListeners();
  }

  void _handleGameFinished(Map<String, dynamic> data, String gameId) {
    print('Socket Handle OnlineGame Finished');
    OnlineGame game = _onlineGames[getGameIndex(gameId)];
    PlayerColor winnerPlayerColor =
        GameConversion.getPlayerColorFromUserId(data['winnerId'], game.player);
    print(winnerPlayerColor);
    List<dynamic> newUsers = data['newUsers'];
    Map finishedGameData = {
      'winner': winnerPlayerColor,
    };
    game.finishedGameData = {};
    newUsers.forEach((newUser) {
      PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(
              newUser['_id'], game.player) ??
          PlayerColor.none;
      print(playerColor);
      print(newUser);
      finishedGameData.putIfAbsent(playerColor, () => newUser['score']);
    });
    finishedGameData['howGameEnded'] =
        HowGameEnded.values[data['howGameEnded']];
    print(finishedGameData);
    game.finishedGameData = finishedGameData;
    hasPopup = true;
    notifyListeners();
  }

  void _handleRequestCancelled(Map<String, dynamic> data, String gameId) {
    print('Socket Handle Request Cancelled');
    if (data['userId'] != _userId) {
      String message = 'Could not get Message';
      _onlineGames[getGameIndex(gameId)].requests.removeWhere(
          (request) => request.requestType.index == data['requestType']);
      popUpMessage = data['message'] ?? message;
      hasMessage = true;
      notifyListeners();
    }
  }

  void _handleGameStarts(Map<String, dynamic> gameData) {}

  //#########################################################################
// helper Functions
  int getGameIndex(String gameId) {
    int gameIndex = _onlineGames.indexWhere((game) => game.id == gameId);
    if (gameIndex != -1) {
      return gameIndex;
    }
    print('Did not Find OnlineGame with the Given OnlineGame Id');
    return 0;
  }
}
