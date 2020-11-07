import 'dart:convert';
import 'dart:async';
import 'dart:html';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';
import '../models/enums.dart';
import '../data/server.dart';

const String SERVER_URL = SERVER_ADRESS;

class GameProvider with ChangeNotifier {
  String socketMessage;
  IO.Socket _socket = IO.io(SERVER_URL);
  // String _userId = '5fa2acde10f740ca2bc1265f';
  // String _token = '079f9zqnodyq2iw43r2nl8x82';
   String _userId = '5fa2c83cbd3915ec925b2fe8';
  String _token = '414x2ntokslku3ztpgab7smb1';
  int _userScore = 1000;

  Player _player = new Player(
    user: new User(
      email: 'jan.albrecht2000@gmail.com',
    ),
  );

  Player get player {
    return _player;
  }

  List<Game> _games = [];
  Game _game;

  GameProvider() {
    // try {
    _socket.on('games', (encodedData) {
      print(encodedData);
      final Map<String, dynamic> data = json.decode(encodedData);
      if (data == null) {
        throw ('Couldnt read socket data!');
      }
      _handleSocketMessage(data);
    });
    // } catch (error) {
    //   print(error);
    // }
  }

// updated vlaues from ProxyProvider:
  void update(String userId, String token, Game game, List<Game> games) {
    _userId = userId;
    _token = token;
    _games = games;
    _game = game;
  }

// providing game data for screen
  get game {
    return _game;
  }

// providing games data for lobby
  get games {
    return [..._games];
  }

  Future<void> fetchAll() async {
    print('start fetching games');
    await fetchGame();
    await fetchGames();
    printEverything(_game, player, _games);
  }

  startGame() {
    print('=================================');
    print('3 players are i the Game');
    print('Game can start');
    print('=================================');
  }

  Future<void> createGame(
      {bool isPublic,
      bool isRated,
      int increment,
      int time,
      int negDeviation,
      int posDeviation}) async {
    final int negRatingRange = _userScore + negDeviation;
    final int posRatingRange = _userScore + posDeviation;
    try {
      final url = SERVER_URL + '/create-game?auth=$_token&id=$_userId';
      final response = await http.post(
        url,
        body: json.encode({
          'userId': _userId,
          'isPublic': isPublic,
          'isRated': isRated,
          'increment': increment,
          'time': time,
          'negRatingRange': negRatingRange,
          'posRatingRange': posRatingRange,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      _game = rebaseWholeGame(response);
      print('successfully created game');
      _socket.on('/${_game.id}', (encodedData) {
        final Map<String, dynamic> data = json.decode(encodedData);
        if (!data['action']) {
          throw ('Error: No Action Key from Websocket!');
        }
        _handleSocketMessage(data);
      });
      printEverything(_game, _player, _games);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> joynGame(String gameId) async {
    try {
      final url = SERVER_URL + '/joyn-game?auth=$_token&id=$_userId';
      final encodedResponse = await http.post(
        url,
        body: json.encode({
          'userId': _userId,
          'gameId': gameId,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      _game = rebaseWholeGame(encodedResponse);
      if (_game.didStart) {
        startGame();
      }
      print('joyn Game user--- not soket');
      printEverything(_game, player, _games);
      print('successfully created game');
        _socket.on('/${_game.id}', (encodedData) {
          Map<String, dynamic> data = json.decode(encodedData);
          if (!data['action']) {
            throw ('Error: No Action Key from Websocket!');
          }
          _handleSocketMessage(data);
          notifyListeners();
        });
    } catch (error) {
      throw ('An error occured while joyning game:' + error);
    } 
  }

  Future<void> sendMove(ChessMove chessMove) async {
    try {
      final url = SERVER_URL + '/chess-move?auth=$_token&id=$_userId';
      final encodedResponse = await http.post(
        url,
        body: json.encode({
          'initialTile': chessMove.initialTile,
          'nextTile': chessMove.nextTile,
          'gameId': _game.id,
          'remainingTime': chessMove.remainingTime,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(encodedResponse.body) as Map<String, dynamic>;
      if (data == null) {
        throw ('No data Send from Server while making a chess move');
      }
      if (!data['valid']) {
        throw ('Data send from server while making a Chess Move is not Valid');
      }
      print(data['message']);
      print(data['chessMove'].toString());
      _game.chessMoves.add(rebaseOneMove(data['chessMove']));
      printEverything(_game, player, _games);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> sendTakeBackRequest() {}

  Future<bool> sendRemiOffer() {}

  surrender() {}

  Future<void> fetchGame() async {
    try {
      final url = SERVER_URL + '/fetch-game?auth=$_token&id=$_userId';
      final encodedResponse = await http.get(url);
      print(encodedResponse.body);
      _game = rebaseWholeGame(encodedResponse);
      _socket.on('/${_game.id}', (encodedData) {
        Map<String, dynamic> data = json.decode(encodedData);
        if (!data['action']) {
          throw ('Error: No Action Key from Websocket!');
        }
        _handleSocketMessage(data);
      });
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchGames() async {
    _games = []; 
    print('start fetching games');
    try {
      final url = SERVER_URL + '/fetch-games?auth=$_token&id=$_userId';
      final encodedResponse = await http.get(url);
      final data = jsonDecode(encodedResponse.body);
      if (data == null) {
        throw ('Fetching Games from Server did not work');
      }
      print('data:  ' + data.toString());
      if (!data['valid']) {
        print(data['message']);
        throw ('fetching Games did not work, something went wrong in server validation....' +
            data['message']);
      }
      data['gameData'].forEach((e) => _games.add(rebaseLobbyGame(e)));
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
  // only with scores

  _handleSocketMessage(dynamic data) {
    switch (data['action']) {
      case 'new-game':
        print('socket: message...:  ' + data['message']);
        print('socket: data...:  ' + data.toString());
        _games.add(rebaseLobbyGame(data['gameData']));
        printEverything(_game, player, _games);
        print('Finished adding new Lobby game to games');
        break;
      case 'player-joyned':
        // case for all players that player joyned a game in the lobby
        print(data.toString());
        final gameIndex = _games.indexWhere((e) =>
            e.id ==
            data['gameData']['id']);
            print('index:   ' + gameIndex.toString());
        _games[gameIndex].player.add(rebaseOnePlayer(data['gameData']['player']));
        print('found game socket:   ' + _games[gameIndex].player.toString());
        print('player joyned A game... socket');
        printEverything(_game, player, _games);
        notifyListeners();
        break;
      case 'player-joyned-lobby':
        // case handles the action for a user in a lobby who witnesses a joyn
        print(data['message']);
        socketMessage = 'Player  ' +
            data['gameData']['player']['user']['userName'] +
            '    joyned the Game';
        print(socketMessage);
        //add game to games
        _game.player.add(rebaseOnePlayer(data['gameData']['player']));
        if (data['gameData']['didStart']) {
          _game.didStart = true;
          startGame();
        }
        printEverything(_game, player, _games);
        notifyListeners();
        break;
      case 'move-made':
        print(data['message']);
        _game.chessMoves.add(rebaseOneMove(data['chessMove']));
        printEverything(_game, player, _games);
        notifyListeners();
        break;
    }
  }
}

printEverything(Game game, Player player, List<Game> games) {
  print(game.toString());
  print(player.toString());
  print(games.toString());
  print('########################');
  if (game != null) {
    print('Game: ...');
    print('========================');
    print('id:   ' + game.id.toString());
    print('didStart:   ' + game.didStart.toString());
    print('------------------------');
    print('options: ');
    print('------------------------');
    print('  --> increment:   ' + game.increment.toString());
    print('  --> time:   ' + game.time.toString());
    print('  --> negratingRange:   ' + game.negRatingRange.toString());
    print('  --> posRatingrange:   ' + game.posRatingRange.toString());
    print('  --> isPublic:   ' + game.isPublic.toString());
    print('  --> isRated:   ' + game.isRated.toString());
    print('-----------------------');
    print('player:');
    print('-----------------------');
    game.player.forEach((e) {
      print('  --> playerColor:   ' + e.playerColor.toString());
      print('  --> remainingTime:   ' + e.remainingTime.toString());
      print('  --> user:');
      print('       - id:   ' + e.user.id.toString());
      print('       - userName:   ' + e.user.userName.toString());
      print('       - score:   ' + e.user.score.toString());
    });}
    print('========================');
    print('This Player: ...');
    print('========================');
    print('playerColor:   ' + player.playerColor.toString());
    print('remainingTime:   ' + player.remainingTime.toString());
    print('-----------------------');
    print('user:');
    print('-----------------------');
    print('  --> id:   ' + player.user.id.toString());
    print('  --> userName:   ' + player.user.userName.toString());
    print('  --> score:   ' + player.user.score.toString());
    print('  --> email:   ' + player.user.email.toString());
    print('========================');
    if (games.isNotEmpty) {
      print('games: ...');
      print('========================');
      for (game in games) {
        print('a game: ');
        print('  --> id:   ' + game.id.toString());
        print('  --> isRated:   ' + game.isRated.toString());
        print('-----------------------');
      }
    }
    print('########################');
  
}

Game rebaseWholeGame(encodedResponse) {
  final data = json.decode(encodedResponse.body);
  if (data == null) {
    throw ('fetch Game... No response from Server');
  }
  if (!data['valid']) {
    print(data['message']);
    throw ('send Data. Data was not valid');
  }
  final gameData = data['gameData'];
  // convert Chess moves and add them to exisitng Chess Move Class
  List<ChessMove> chessMoves = [];
  gameData['chessMoves'].forEach((e) => chessMoves.add(new ChessMove(
        initialTile: gameData['initialTile'],
        nextTile: gameData['nextTile'],
        remainingTime: gameData['remainingTime'],
      )));
  // convert player List and add them to existing player class
  List<Player> convPlayer = [];
  gameData['player'].forEach((e) => convPlayer.add(new Player(
        playerColor: PlayerColor.values[e['playerColor'] - 1],
        remainingTime: e['remainingTime'],
        user: new User(
          id: e['user']['id'],
          score: e['user']['score'],
          userName: e['user']['userName'],
        ),
      )));
  return new Game(
    chessMoves: chessMoves,
    didStart: gameData['didStart'],
    id: gameData['id'],
    player: convPlayer,
    increment: gameData['options']['increment'],
    isPublic: gameData['options']['isPublic'],
    isRated: gameData['options']['isRated'],
    negRatingRange: gameData['options']['negRatingRange'],
    posRatingRange: gameData['options']['posRatingRange'],
    time: gameData['options']['time'],
  );
}

Game rebaseLobbyGame(gameData) {
  //No Chess Moves made in Lobby Games
  List<ChessMove> chessMoves = [];
  // convert player List and add them to existing player class
  List<Player> convPlayer = [];
  gameData['player'].forEach((e){
    print(e.toString());
    convPlayer.add(new Player(
        playerColor: PlayerColor.values[(e['playerColor'] + 2) % 3],
        remainingTime: e['remainingTime'],
        user: new User(
          id: e['user']['id'],
          score: e['user']['score'],
          userName: e['user']['userName'],
        ),
      ));
        });

  return new Game(
    isRated: gameData['options']['isRated'],
    didStart: gameData['didStart'],
    id: gameData['id'],
    increment: gameData['options']['increment'],
    isPublic: gameData['options']['isPublic'],
    negRatingRange: gameData['options']['negRatingRange'],
    posRatingRange: gameData['options']['posRatingRange'],
    chessMoves: chessMoves,
    player: convPlayer,
    time: gameData['options']['time'],
  );
}

Player rebaseOnePlayer(playerData) {
  return new Player(
    playerColor: PlayerColor.values[(playerData['playerColor'] + 2) % 3],
    remainingTime: playerData['remainingTime'],
    user: new User(
      id: playerData['id'],
      score: playerData['score'],
      userName: playerData['userName'],
    ),
  );
}

ChessMove rebaseOneMove(moveData) {
  return ChessMove(
    initialTile: moveData['initialTile'],
    nextTile: moveData['nextTile'],
    remainingTime: moveData['remainingTime'],
  );
}
