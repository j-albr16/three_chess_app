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
    // TODO : Find better Work around for SocketLobby Channel Init

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
    _printEverything(_game, player, _games);
  }

// TODO
  _startGame() {
    _games.remove(_game);
    print('=================================');
    print('3 players are i the Game');
    print('Game can start');
    print('=================================');
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
      int time,
      int negDeviation,
      int posDeviation}) async {
    try {
      final Map<String, dynamic> data = await _serverProvider.createGame(
        isPublic: isPublic,
        increment: increment,
        isRated: isRated,
        negDeviation: negDeviation,
        posDeviation: posDeviation,
        time: time,
      );
      // rebasing the whole Game. COnverting JSON to Game Model Data. See Methode below
      _game = _rebaseWholeGame(data);
      print('successfully created game');
      // printing whole game if option to print it is set on true. Look on top ... at imports.. there printout options are defined
      if (printCreateGame) {
        _printEverything(_game, player, _games);
      }
      // ToDO : Remove line below
      if (_game == null) {
        throw ('No Game Saved as _game!!');
      }
      _serverProvider.subscribeToGameLobbyChannel(
        gameId: _game.id,
        moveMadeCallback: (moveData) => _handleMoveData(moveData),
        playerJoinedLobbyCallback: (gameData) =>
            _handlePlayerJoinedLobbyData(gameData),
      );
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
      _game = _rebaseWholeGame(data);
      // starts game If didStart is true => 3 Player are in the Game now and the server noticed that
      if (_game.didStart) {
        _startGame();
      }
      // print whole game Provider Data if option is set on true
      if (printjoinGame) {
        _printEverything(_game, player, _games);
      }
      if (_game == null) {
        throw ('Error _game caught on Null after joining a game');
      }
      _serverProvider.subscribeToGameLobbyChannel(
        gameId: gameId,
        moveMadeCallback: (moveData) => _handleMoveData(moveData),
        playerJoinedLobbyCallback: (gameData) =>
            _handlePlayerJoinedLobbyData(gameData),
      );
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
      _game = _rebaseWholeGame(data);
      // starts listening to Game Lobby Websoket (Message on player who joined Game or made a Chess move etc....)
      // prints all Data if option is set on true
      if (printFetchGame) {
        _printEverything(_game, player, _games);
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
      data['gameData']['games'].forEach((e) => _games.add(_rebaseLobbyGame(
            gameData: e,
            playerData: data['gameData']['player'],
            userData: data['gameData']['user'],
          )));
      notifyListeners();
      // printsa all game Provider Data if option is set on true
      if (printFetchGames) {
        _printEverything(_game, player, _games);
      }
    } catch (error) {
      _serverProvider.handleError('error While fetching Games', error);
    }
  }

  // only with scores
  void _handleNewGameData(Map<String, dynamic> gameData) {
    _games.add(_rebaseLobbyGame(
      gameData: gameData,
      playerData: gameData['player'],
      userData: gameData['user'],
    ));
    // print all Game Data if option is set on true
    if (printGameSocket) {
      _printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handlePlayerJoinedData(Map<String, dynamic> gameData) {
    final int gameIndex = _games.indexWhere((e) => e.id == gameData['_id']);
    // adds the converted Player to the Game with the given gameId in _games
    _games[gameIndex].player.add(_rebaseOnePlayer(
          playerData: gameData['player'],
          userData: gameData['user'],
        ));
    if (printGameSocket) {
      _printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handlePlayerJoinedLobbyData(Map<String, dynamic> gameData) {
    _game.player.add(_rebaseOnePlayer(
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
      _printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  void _handleMoveData(Map<String, dynamic> moveData) {
    print(moveData);
    _game.chessMoves.add(_rebaseOneMove(moveData));
    // print all Game Provider Data if optin was set to true
    if (printGameSocket) {
      _printEverything(_game, player, _games);
    }
    notifyListeners();
  }

  Game _rebaseWholeGame(Map<String, dynamic> data) {
    // input: takes a decoded response from Server , where GameData in JSON is encoeded
    // output: Returns a game Model
    // TODO :remove data prin t
    print(data);
    // extracting gameData, from JSON Response
    final gameData = data['gameData'];
    // convert Chess moves and add them to exisitng Chess Move Class
    List<ChessMove> chessMoves = [];
    // TODO : Delete
    print('Move Data');
    print(gameData['chessMoves']);
    gameData['chessMoves'].forEach((e) => chessMoves.add(_rebaseOneMove(e)));
    // convert player List and add them to existing player class
    List<Player> convPlayer = _connectUserPlayerData(
      player: gameData['player'],
      users: gameData['user'],
    );
    // TODO : Delete Printout
    print('Finished converting Player and User');
    // creates a game and sets Game options in it
    Game game = _createGameWithOptions(gameData['options']);
    // set remaining Game parameters
    game.didStart = gameData['didStart'];
    game.id = gameData['_id'];
    game.player = convPlayer;
    game.chessMoves = chessMoves;
    // returns the converted Game
    return game;
  }

  Game _rebaseLobbyGame({gameData, userData, playerData}) {
    // input: takes the decoded GameData of an JSON Response as Input
    // output: returns a converted Game that includes Lobby Game Data
    //No Chess Moves made in Lobby Games
    List<ChessMove> chessMoves = [];
    // convert player List and add them to existing player class
    List<Player> convPlayer = _connectUserPlayerData(
      player: playerData,
      users: userData,
    );
    // creates a game and sets gameOptions
    Game game = _createGameWithOptions(gameData['options']);
    // set remaining Game parameters
    game.didStart = gameData['didStart'];
    game.id = gameData['_id'];
    game.player = convPlayer;
    game.chessMoves = chessMoves;
    // returns the converted Game
    return game;
  }

  Player _rebaseOnePlayer({playerData, userData}) {
    // input: takes player Converted Data of One Player as Input
    // output: returns a Player Model with the Given Data
    return new Player(
      playerColor: PlayerColor.values[playerData['playerColor']],
      remainingTime: playerData['remainingTime'],
      user: new User(
        id: userData['_id'],
        score: userData['score'],
        userName: userData['userName'],
      ),
    );
  }

  ChessMove _rebaseOneMove(moveData) {
    // input : receive Move Data,
    // output : return Chess Move Model
    return ChessMove(
      initialTile: moveData['initialTile'],
      nextTile: moveData['nextTile'],
      remainingTime: moveData['remainingTime'],
    );
  }

  void _validation(data) {
    // input: receives a bool as decoded JSON Object __> mainly res.json(valid)
    // output : Return whether this bool is true or false
    // Checks whether Data was even recieved
    if (data == null) {
      throw ('No Data was received ... Data is equal to NULL');
    }
    // cheks whether Data is Valid. If validis not true Error was thrown on Server
    if (data['valid'] == false || data['valid'] == null) {
      throw ('validation did not succeed ... thsi is the Error Message: ...' +
          data['message']);
    }
    print('validation finished , was succesfull');
  }

  List<Player> _connectUserPlayerData({users, player}) {
    // input: get a Player JSON Object and a User JSON Object
    // output: return a Player model where User and Player are asigned
    List<Player> convPlayer = [];
    player.forEach((p) {
      print(p);
      final user =
          users?.firstWhere((u) => p['userId'] == u['_id'], orElse: () => null);
      // returns user object where player-userId and user.id are qual
      convPlayer.add(_rebaseOnePlayer(
        playerData: p,
        userData: user,
      ));
    });
    // return List of Player.
    return convPlayer;
  }

  Game _createGameWithOptions(gameOptions) {
    // input: takes JSOON Game Options as Input
    // output: returns a game Model where Game options are set already
    return new Game(
      increment: gameOptions['increment'],
      isPublic: gameOptions['isPublic'],
      isRated: gameOptions['isRated'],
      negRatingRange: gameOptions['negRatingRange'],
      posRatingRange: gameOptions['posRatingRange'],
      time: gameOptions['time'],
    );
  }

  _printEverything(Game game, Player player, List<Game> games) {
    print('###################################');
    if (game != null) {
      print('Game:----------------------------');
      print('=================================');
      print('id:         ' + game.id.toString());
      print('didStart:   ' + game.didStart.toString());
      print('----------------------------------');
      print('options: --------------------------   ');
      print(' -> increment:       ' + game.increment.toString());
      print(' -> time:            ' + game.time.toString());
      print(' -> negratingRange:  ' + game.negRatingRange.toString());
      print(' -> posRatingrange:  ' + game.posRatingRange.toString());
      print(' -> isPublic:        ' + game.isPublic.toString());
      print(' -> isRated:         ' + game.isRated.toString());
      print('---------------------------------');
      print('player:--------------------------');
      game.player.forEach((e) {
        print(' -> playerColor:     ' + e.playerColor.toString());
        print(' -> remainingTime:   ' + e.remainingTime.toString());
        print(' -> user:-----------------------');
        print('     - id:               ' + e.user.id.toString());
        print('     - userName:         ' + e.user.userName.toString());
        print('     - score:            ' + e.user.score.toString());
      });
      print('Chess Moves:-----------------------');
      game.chessMoves.forEach((m) {
        print('one move:-------------------------');
        print(' -> initialTile:     ' + m.initialTile);
        print(' -> nextTile:        ' + m.nextTile);
        print(' -> remainingTime:   ' + m.remainingTime.toString());
      });
    }
    print('==================================');
    print('This Player:----------------------');
    print('playerColor:     ' + player.playerColor.toString());
    print('remainingTime:   ' + player.remainingTime.toString());
    print('----------------------------------');
    print('user:------------------------------');
    print(' -> id:          ' + player.user.id.toString());
    print(' -> userName:    ' + player.user.userName.toString());
    print(' -> score:       ' + player.user.score.toString());
    print(' -> email:       ' + player.user.email.toString());
    print('===================================');
    if (games.isNotEmpty) {
      print('games:----------------------------');
      for (game in games) {
        print('a game:-------------------------');
        print(' -> id:        ' + game.id.toString());
        print(' -> isRated:   ' + game.isRated.toString());
        print('--------------------------------');
      }
    }
    print('#####################################');
  }
}
