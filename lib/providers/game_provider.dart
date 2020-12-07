import 'dart:convert';
import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/game.dart';
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
const printjoinGame = true;
const printFetchGame = true;
const printFetchGames = false;
const printGameSocket = true;
const printGameMove = true;

class GameProvider with ChangeNotifier {
  String _userId = constUserId;

  Player _player = new Player(
    user: new User(
      email: 'jan.albrecht2000@gmail.com',
    ),
  );

  Player get player {
    PlayerColor yourPlayerColor;
    if (_game != null) {
      yourPlayerColor = _game?.player
          ?.firstWhere((e) => e?.user?.id == _userId, orElse: () => null)
          ?.playerColor;
    }
    return new Player(
      playerColor: yourPlayerColor,
      user: _player.user,
    );
  }

  List<Game> _games = [];
  Game _game;
  ServerProvider _serverProvider;

  bool _didInitLobby = false;
// updated vlaues from ProxyProvider:
  void update({ServerProvider serverProvider, Game game, List<Game> games}) {
    _games = games;
    _game = game;
    _serverProvider = serverProvider;
    if (!_didInitLobby) {
      subscribeToLobbychannel();
      _didInitLobby = true;
    }
    notifyListeners();
  }

// providing game data for screen
  Game get game {
    return _game;
  }

// providing games data for lobby
  List<Game> get games {
    return [..._games];
  }

  Future<void> fetchAll() async {
    print('start fetching games');
    await fetchGame();
    await fetchGames();
    GameConversion.printEverything(_game, player, _games);
  }

// TODO
  _startGame() {
    _games.remove(_game);
    print('=================================');
    print('3 players are i the Game');
    print('Game can start');
    print('=================================');
  }

  void subscribeToGameLobbyChannel() {
    _serverProvider.subscribeToGameLobbyChannel(
      gameId: _game.id,
      moveMadeCallback: (moveData) => _handleMoveData(moveData),
      playerJoinedLobbyCallback: (gameData) =>
          _handlePlayerJoinedLobbyData(gameData),
      remiAcceptCallback: (userId) => _handleRemiAccept(userId),
      remiDeclineCallback: (userId) => _handleRemiDecline(userId),
      remiRequestCallback: (userId, chessMove) =>
          _handleRemiRequest(userId, chessMove),
      surrenderDeclineCallback: (userId) => _handleSurrenderDecline(userId),
      surrenderRequestCallback: (userId, chessMove) =>
          _handleSurrenderRequest(userId, chessMove),
      takeBackAcceptCallback: (userId) => _handleTakeBackAccept(userId),
      takeBackDeclineCallback: (userId) => _handleTakeBackDecline(userId),
      takeBackRequestCallback: (userId, chessMove) =>
          _handleTakeBackRequest(userId, chessMove),
      takenBackCallback: (userId, chessMove) =>
          _handleTakenBack(userId, chessMove),
      gameFinishedcallback: (data) => _handleGameFinished(data),
      surrenderFailedCallback: () => _handleSurrenderFailed(),
      playerIsOnlineCallback: (userId) => _handlePlayerIsOnline(userId),
      playerIsOfflineCallback: (userId, expiryDate) => _handlePlayerIsOffline(userId, expiryDate),
    );
  }

  void subscribeToLobbychannel() {
    // disposing all previous Listeners to Lobby. In  case something went wrong with quit listening
    // _serverProvider.unSubscribeToLobbyChannel();
    // Subscribe to Lobby Channel
    _serverProvider.subscribeToLobbyChannel(
      newGameCallback: (gameData) => _handleNewGameData(gameData),
      playerJoinedCallback: (gameData) => _handlePlayerJoinedData(gameData),
    );
  }
  

  Future<void> createGame(
      {bool isPublic,
      bool isRated,
      int increment,
      List<String> invitations,
      int time,
      bool allowPremades,
      int negDeviation,
      int posDeviation}) async {
    try {
      final Map<String, dynamic> data = await _serverProvider.createGame(
        allowPremades : allowPremades,
        isPublic: isPublic,
        increment: increment,
        isRated: isRated,
        invitations : invitations,
        negDeviation: negDeviation,
        posDeviation: posDeviation,
        time: time,
      );
      // rebasing the whole Game. COnverting JSON to Game Model Data. See Methode below
      _game = GameConversion.rebaseWholeGame(data['gameData']);
      print('successfully created game');
      // printing whole game if option to print it is set on true. Look on top ... at imports.. there printout options are defined
      if (printCreateGame) {
        GameConversion.printEverything(_game, player, _games);
      }
      // ToDO : Remove line below
      if (_game == null) {
        throw ('No Game Saved as _game!!');
      }
      subscribeToGameLobbyChannel();
      // stop listen to lobby channel
      // _serverProvider.unSubscribeToLobbyChannel();
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While creating Game', error);
    }
  }

  Future<void> joinGame(String gameId) async {
    try {
      // http request
      final Map<String, dynamic> data = await _serverProvider.joinGame(gameId);
      _game = GameConversion.rebaseWholeGame(data['gameData']);
      // starts game If didStart is true => 3 Player are in the Game now and the server noticed that
      if (_game.didStart) {
        _startGame();
      }
      // print whole game Provider Data if option is set on true
      if (printjoinGame) {
        GameConversion.printEverything(_game, player, _games);
      }
      if (_game == null) {
        throw ('Error _game caught on Null after joining a game');
      }
      subscribeToGameLobbyChannel();
      // stop listenng to lobby Channel
      // _serverProvider.unSubscribeToLobbyChannel();
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error while joining Game', error);
    }
  }

  void leaveGame() {
    // _serverProvider.unSubscribeToGameLobbyChannel(_game.id);
    _game = null;
  }

  Future<void> sendMove(ChessMove chessMove) async {
    try {
      await _serverProvider.sendMove(chessMove);
    } catch (error) {
      _serverProvider.handleError('Error While creating Game', error);
    }
  }

  Future<void> fetchGame() async {
    // input: VOID
    // output: sends a fetch Game request to Server. Will Receive a JSON Game. return a Game Model
    try {
      // make http request
      final Map<String, dynamic> data = await _serverProvider.fetchGame();
      _game = GameConversion.rebaseWholeGame(data['gameData']);
      // starts listening to Game Lobby Websoket (Message on player who joined Game or made a Chess move etc....)
      // prints all Data if option is set on true
      if (printFetchGame) {
        GameConversion.printEverything(_game, player, _games);
      }
      if (_game != null) {
        _serverProvider.subscribeToGameLobbyChannel(
          gameId: _game.id,
          moveMadeCallback: (moveData) => _handleMoveData(moveData),
          playerJoinedLobbyCallback: (gameData) =>
              _handlePlayerJoinedLobbyData(gameData),
        );
        _serverProvider.subscribeToLobbyChannel();
      }
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error whileFetching Game', error);
    }
  }

  Future<void> fetchGames() async {
    // input: VOID
    // output: sends fetch Games request to Server. Receives all Lobby Games a JSON From Server. Returns List of Lobby Games
    try {
      // make http request
      final Map<String, dynamic> data = await _serverProvider.fetchGames();
      _games = [];
      // Convert Data to existing Models
      data['gameData']['games'].forEach((game) {
        final playerData = data['gameData']['player'].firstWhere((player) => player['gameId'] == game['_id'], orElse: () => null);
        final userData= data['gameData']['user'].firstWhere((user) =>user['gameId'] == game['_id'], orElse: () => null);
_games.add(GameConversion.rebaseLobbyGame(
            gameData: game,
            playerData: playerData,
            userData: userData,
          ));
      } );
      notifyListeners();
      // printsa all game Provider Data if option is set on true
      if (printFetchGames) {
        GameConversion.printEverything(_game, player, _games);
      }
    } catch (error) {
      _serverProvider.handleError('error While fetching Games', error);
    }
  }

  Future<void> requestSurrender() async {
    try {
      await _serverProvider.requestSurrender();
    } catch (error) {
      _serverProvider.handleError('Error While Requesting Surrender', error);
    }
  }

  Future<void> acceptSurrender() async {
    try {
      await _serverProvider.acceptSurrender();
    } catch (error) {
      _serverProvider.handleError('Error while Accepting Surrender', error);
    }
  }

  Future<void> declineSurrender() async {
    try {
      await _serverProvider.declineSurrender();
    } catch (error) {
      _serverProvider.handleError('Error while Decline Surrender', error);
    }
  }

  Future<void> requestRemi() async {
    try {
      await _serverProvider.requestRemi();
    } catch (error) {
      _serverProvider.handleError('Error while Requesting Remi', error);
    }
  }

  Future<void> acceptRemi() async {
    try {
      await _serverProvider.acceptRemi();
    } catch (error) {
      _serverProvider.handleError('Error while Accepting Remi', error);
    }
  }

  Future<void> declineRemi() async {
    try {
      await _serverProvider.declineRemi();
    } catch (error) {
      _serverProvider.handleError('Error while declining Remi', error);
    }
  }

  Future<void> requestTakeBack() async {
    try {
      await _serverProvider.requestTakeBack();
    } catch (error) {
      _serverProvider.handleError('Error while Declining Take Back', error);
    }
  }

  Future<void> acceptTakeBack() async {
    try {
      await _serverProvider.acceptTakeBack();
    } catch (error) {
      _serverProvider.handleError('Error while accepting Take Back', error);
    }
  }

  Future<void> declineTakeBack() async {
    try {
      await _serverProvider.declineTakeBack();
    } catch (error) {
      _serverProvider.handleError('Error while declining Take Back', error);
    }
  }

  // TODO Remove
  Future<void> createTestGame() async {
    try{
      await _serverProvider.createTestGame();
    }catch(error){
      _serverProvider.handleError('Error while declining Take Bakc', error);
    }
  }
   

  // only with scores
  void _handleNewGameData(Map<String, dynamic> gameData) {
    _games.add(GameConversion.rebaseLobbyGame(
      gameData: gameData,
      playerData: gameData['player'],
      userData: gameData['user'],
    ));
    // print all Game Data if option is set on true
    if (printGameSocket) {
      GameConversion.printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handlePlayerIsOnline(String userId){
    Player player = _game.player.firstWhere((player) => player.user.id == userId, orElse: () => null);
    player?.isOnline = true;
    notifyListeners();
  }
  void _handlePlayerIsOffline(String userId , String expiryDate){
    Player player = _game.player.firstWhere((player) => player.user.id == userId, orElse: () => null );
    player?.isOnline = false;
    _game.endGameExpiry = DateTime.parse(expiryDate);
    notifyListeners();
  }

  void _handlePlayerJoinedData(Map<String, dynamic> gameData) {
    final int gameIndex = _games.indexWhere((e) => e.id == gameData['_id']);
    // adds the converted Player to the Game with the given gameId in _games
    _games[gameIndex].player.add(GameConversion.rebaseOnePlayer(
          playerData: gameData['player'],
          userData: gameData['user'],
        ));
    if (printGameSocket) {
      GameConversion.printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handlePlayerJoinedLobbyData(Map<String, dynamic> gameData) {
    _game.player.add(GameConversion.rebaseOnePlayer(
      playerData: gameData['player'],
      userData: gameData['user'],
    ));
    // if did Start is true start game
    if (gameData['didStart']) {
      _game.didStart = true;
      _startGame();
    }
    // print all game provider Data if option is set ot true
    if (printGameSocket) {
      GameConversion.printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handleMoveData(Map<String, dynamic> moveData) {
    print(moveData);
    _game.chessMoves.add(GameConversion.rebaseOneMove(moveData));
    // print all Game Provider Data if optin was set to true
    if (printGameSocket) {
      GameConversion.printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handleSurrenderRequest(String userId, int chessMove) {
    Map<ResponseRole, PlayerColor> playerResponse;
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId, _game);
    playerResponse[ResponseRole.Create] = playerColor;
    _game.requests.add(new Request(
      moveIndex: chessMove,
      playerResponse: playerResponse,
      requestType: RequestType.Surrender,
    ));
    notifyListeners();
  }

  void _handleSurrenderDecline(String userId) {
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId, _game);
    GameConversion.getRequestFromRequestType(RequestType.Surrender, _game)
        .playerResponse[ResponseRole.Decline] = playerColor;
    notifyListeners();
  }

  void _handleSurrenderFailed() {
    _game.requests
        .removeWhere((request) => request.requestType == RequestType.Surrender);
    notifyListeners();
  }

  void _handleRemiRequest(String userId, int chessMove) {
    Map<ResponseRole, PlayerColor> playerResponse;
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId,_game);
    playerResponse[ResponseRole.Create] = playerColor;
    _game.requests.add(new Request(
      moveIndex: chessMove,
      playerResponse: playerResponse,
      requestType: RequestType.Remi,
    ));
    notifyListeners();
  }

  void _handleRemiAccept(String userId) {
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId,_game);
    GameConversion.getRequestFromRequestType(RequestType.Remi, _game)
        .playerResponse[ResponseRole.Accept] = playerColor;
    notifyListeners();
  }

  void _handleRemiDecline(String userId) {
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId,_game);
    GameConversion.getRequestFromRequestType(RequestType.Remi, _game)
        .playerResponse[ResponseRole.Decline] = playerColor;
    _game.requests
        .removeWhere((request) => request.requestType == RequestType.Remi);
    notifyListeners();
  }

  void _handleTakeBackRequest(String userId, int chessMove) {
    Map<ResponseRole, PlayerColor> playerResponse;
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId,_game);
    playerResponse[ResponseRole.Create] = playerColor;
    _game.requests.add(new Request(
      moveIndex: chessMove,
      playerResponse: playerResponse,
      requestType: RequestType.TakeBack,
    ));
    notifyListeners();
  }

  void _handleTakeBackAccept(String userId) {
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId,_game);
    GameConversion.getRequestFromRequestType(RequestType.TakeBack, _game)
        .playerResponse[ResponseRole.Accept] = playerColor;
    notifyListeners();
  }

  void _handleTakeBackDecline(String userId) {
    PlayerColor playerColor = GameConversion.getPlayerColorFromUserId(userId,_game);
    GameConversion.getRequestFromRequestType(RequestType.TakeBack, _game)
        .playerResponse[ResponseRole.Decline] = playerColor;
    _game.requests
        .removeWhere((request) => request.requestType == RequestType.TakeBack);
    notifyListeners();
  }

  void _handleTakenBack(String userId, int chessMove) {
    _game.chessMoves.removeRange(chessMove, _game.chessMoves.length);
    _game.requests
        .removeWhere((request) => request.requestType == RequestType.TakeBack);
    notifyListeners();
  }

  void _handleGameFinished(Map<String, dynamic> data) {
    PlayerColor winnerPlayerColor = GameConversion.getPlayerColorFromUserId(data['winnerId'],_game);
    List<Map<String, dynamic>>  convertedPlayer = data['convertedPlayer'];
    Map finishedGameData = {
      'winner': winnerPlayerColor,
    };
    convertedPlayer.forEach((convPlayer) {
      _game.finishedGameData[PlayerColor.values[convPlayer['playerColor']]] =
          convPlayer['scoreAfter'];
    });
    finishedGameData['howGameEnded'] =
        HowGameEnded.values[data['howGameEnded']];
    _game.finishedGameData = finishedGameData;
    notifyListeners();
  }
}
