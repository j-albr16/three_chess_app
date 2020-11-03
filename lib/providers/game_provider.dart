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

const String SERVER_URL = 'http://localhost:3000';

class GameProvider with ChangeNotifier {
  String socketMessage;
  IO.Socket _socket = IO.io(SERVER_URL);
  String _userId = '5f997e32b5b10b72f88f33a1';
  String _token = '97nz4l9kq83rz907tyff6ara8';
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
      final data = json.decode(encodedData) as Map<String, dynamic>;
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
  await fetchGame();
  await fetchGames();
  notifyListeners();
}

  startGame() {}

  Future<void> createGame({bool isPublic, bool isRated, int increment, int time, int negDeviation, int posDeviation}) async {
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
      print('--------------------');
      print('after post create game methode');
      print('--------------------');
      final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
      print(decodedResponse);
      print('--------------------');
      if (!decodedResponse['valid']) {
        final String errorMessage = decodedResponse['message'].toString();
        throw (errorMessage);
      }
      final gameData = decodedResponse['gameData'];
      print(gameData);
      final player = gameData['player'];
      final  List<Player> convPlayer = [];
      player.forEach((e) {
        final playerColor = PlayerColor.values[e['playerColor'] - 1];
        _player.playerColor = playerColor;
        final user = new User(
          userName: e['user']['userName'],
          score: e['user']['score'],
          id: e['user']['userId'],
        );
        _player.user = user;
        convPlayer.add(Player( remainingTime: e['remainingTime'], user: user));
      });
      print('List of converted player:  ' + convPlayer.toString());
      print('-------------------------');
      _game = new Game(
        negRatingRange: gameData['options']['negRatingRange'],
        posRatingRange: gameData['options']['posRatingRange'],
        isPublic: gameData['options']['isPublic'],
        isRated: gameData['options']['isRated'],
        increment: gameData['options']['increment'],
        time: gameData['options']['time'],
        chessMoves: [],
        // startingBoard: gameData['startingBoard'],
        didStart: false,
        id: gameData['id'],
        player: convPlayer,
      );
      print('successfully created game');
        _socket.on('/${_game.id}', (encodedData) {
          dynamic data = json.decode(encodedData) as Map<String, dynamic>;
          if (!data['action']) {
            throw ('Error: No Action Key from Websocket!');
          }
          _handleSocketMessage(data);
        });
    printEverything(_game, _player, _games);
    } catch (error) {
      print(error.toString());
    }     
    }
  

  Future<void> joynGame(String gameId) async {
    try {
      final url = SERVER_URL + '/joyn-game?auth=$_token&id=$_userId';
      final encodedResponse = await http.post(
        url,
        body: json.encode({'userId': _userId, 'gameId': gameId,}),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(encodedResponse.body) as Map<String, dynamic>;
      if (!data['valid']) {
        throw ('An error occured while joyning game. response Data wasnt true:' + data['message']);
      }
      final gameData = data['gameData'];
      final player = gameData['player'];
      final List<Player> convPlayer = player
          .map((e) => Player(
                playerColor: PlayerColor.values[data['playerColor']],
                remainingTime: e['remainingTime'],
                user: User(
                  id: e['user']['id'],
                  score: e['user']['score'],
                  userName: e['user']['userName'],
                ),
              ))
          .toList();
         final gameOptions = gameData['options'];
      _game = new Game(
        negRatingRange: gameOptions['negRatingRange'],
        posRatingRange: gameOptions['posRatingRange'],
        isPublic: gameOptions['isPublic'],
        isRated: gameOptions['isRated'],
        increment: gameOptions['increment'],
        time: gameOptions['time'],
        chessMoves: [],
        didStart: gameData['didStart'],
        id: gameData['id'],
        player: convPlayer,
      );
      if (gameData['didStart']) {
        // startGame();
      }
      print('Here ------>');
      printEverything(_game, player, _games);
    } catch (error) {
      throw ('An error occured while joyning game:' + error);
    } finally {
      try {
        print('successfully created game');
        _socket.on('/${_game.id}', (encodedData) {
          dynamic data = json.decode(encodedData) as Map<String, dynamic>;
          if (!data['action']) {
            throw ('Error: No Action Key from Websocket!');
          }
          _handleSocketMessage(data);
        });
      } catch (error) {
        print(error);
        // throw (error.toString());
      }
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
      print(data['chessMove']);
      _game.chessMoves.add(data['chessMove']);
    } catch (error) {
      print(error);
    }
  }

  Future<bool> sendTakeBackRequest() {}

  Future<bool> sendRemiOffer() {}

  surrender() {}

  Future<void> fetchGame() async {
    print('----------------------------------------------');
    print('Start fetching Game');
    print('----------------------------------------------');
    try {
      final url = SERVER_URL + '/fetch-game?auth=$_token&id=$_userId';
      final encodedResponse = await http.get(url);
      print(encodedResponse.body);
      Map<String, dynamic> data = jsonDecode(encodedResponse.body) as Map<String, dynamic>;
      if (data == null) {
        throw ('fetch Game... No response from Server');
      }
      if (!data['valid']) {
        print(data['message']);
        throw ('send Data. Data wasnt valid');
      }
      print('----------------------------------------------');
      print('message');
      print(data);
      print(data['valid']);
      print(data['message']);
      print('----------------------------------------------');
      final gameData = data['gameData'];
      print('1');
      print('gameData:   ' + gameData.toString());
      print('2');
      final List<ChessMove> chessMoves = [];
      gameData['chessMoves'].forEach((e) {
        print('3');
        chessMoves.add(ChessMove(
          initialTile: e['initialTile'],
          nextTile: e['nextTile'],
          remainingTime: e['remainingTime'],
        ));
      });
      print('4');
      print(gameData['player'].toString());
      final List<Player> convPlayer = [];
      gameData['player']
          .map((e) => convPlayer.add(Player(
              playerColor: PlayerColor.values[e['playerColor'] - 1],
              remainingTime: e['remainingTime'],
              user: User(
                userName: e['user']['userName'],
                score: e['user']['score'],
                id: e['user']['id'],
              ))));
          print('5');
      _game = new Game(
        negRatingRange: gameData['options']['negRatingRange'],
        posRatingRange: gameData['options']['posRatingRange'],
        isPublic: gameData['options']['isPublic'],
        isRated: gameData['options']['isRated'],
        increment: gameData['options']['increment'],
        time: gameData['options']['time'],
        chessMoves: chessMoves,
        didStart: gameData['didStart'],
        id: gameData['id'],
        player: convPlayer,
      );
      print('6');
      _socket.on('/${_game.id}', (encodedData) {
        dynamic data = json.decode(encodedData) as Map<String, dynamic>;
        if (!data['action']) {
          throw ('Error: No Action Key from Websocket!');
        }
        print('7');
        _handleSocketMessage(data);
      });
      printEverything(_game, player, _games);
      print('8');
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchGames() async {
    print('----------------------------------------------');
    print('Start fetching Games');
    print('----------------------------------------------');
    try {
      final url = SERVER_URL + '/fetch-games?auth=$_token&id=$_userId';
      final encodedResponse = await http.get(url);
      final data = json.decode(encodedResponse.body) as Map<String, dynamic>;
      if (data == null) {
        throw ('Fetching Games from Server did not work');
      }
      if (!data['valid']) {
        print(data['message']);
        throw ('fetching Games did not work, something went wrong in server validation....' + data['message']);
      }
      final gameData = data['gameData'];
      final convertedGames = gameData.map((el) {
        final convertedPlayer = el['player'].map((e) {
          return Player(
            playerColor: e['playerColor'],
            remainingTime: e['remainingTime'],
            user: User(
              id: e['user']['userId'],
              score: e['user']['score'],
              userName: e['user']['userName'],
            ),
          );
        }).toList();
        return new Game(
          id: el['id'],
          increment: el['increment'],
          time: el['time'],
          isRated: el['isRated'],
          negRatingRange: el['negRatingRange'],
          posRatingRange: el['posRatingRange'],
          player: convertedPlayer,
        );
      }).toList();
      _games = convertedGames;
      printEverything(_game, player, _games);
    } catch (error) {
      print(error.toString());
    }
  }
  // only with scores

  _handleSocketMessage(dynamic rawData) {
    final data = rawData['gameData'];
    switch (rawData['action']) {
      case 'new-game':
        print('socket: message...:  ' + rawData['message']);
        print('socket: data...:  ' + data.toString());
        print('playerColor:  ' + PlayerColor.values[data['playerColor'] - 1].toString());
        print('spcket: ...:  start adding game to _games');
        _games.add(new Game(
            isRated: data['isRated'] as bool,
            negRatingRange: data['negRatingRange'] as int,
            posRatingRange: data['posRatingRange'] as int,
            didStart: false,
            id: data['id'] as String,
            increment: data['increment'],
            time: data['time'] as int,
            player: [
              new Player(
                playerColor: PlayerColor.values[data['playerColor'] - 1],
                remainingTime: data['time'] as int,
                user: User(
                  id: data['userId'] as String,
                  score: data['score'] as int,
                  userName: data['userName'] as String,
                ),
              ),
            ]));
            print('socket:....   ');
            print('Did create game and saved it into games');
           printEverything(_game, player, _games);
        break;
      case 'player-joyned':
        // case for all players that player joyned a game in the lobby
        print(rawData['message']);
        print(data.toString());
        printEverything(_game, player, _games);
        final game = _games.firstWhere((e) => e.id == data['id']); //ERROR ERROR ERROR ERROR BAD ELEMENT
        game.player.add(
          new Player(
            remainingTime: data['time'] as int,
            user: User(
              id: data['userId'] as String,
              score: data['score'] as int,
              userName: data['userName'] as String,
            ),
          ),
        );
        break;
      case 'player-joyned-Lobby':
        // case handles the action for a user in a lobby who witnesses a joyn
        print(rawData['message']);
        socketMessage = 'Player' + data['userName'] + 'joyned the Game';
        print(socketMessage);
        final game = _games.firstWhere((e) => e.id == data['id']);
        //add game to games
        game.player.add(
          new Player(
            remainingTime: data['time'] as int,
            playerColor: PlayerColor.values[data['playerColor'] - 1],
            user: User(
              id: data['userId'] as String,
              score: data['score'] as int,
              userName: data['userName'] as String,
            ),
          ),
        );
        if (data['didStart']) {
          _game.didStart = true;
          startGame();
        }
        break;
      case 'move-made':
        print(rawData['message']);
        _game.chessMoves.add(new ChessMove(
          initialTile: data['initialTile'] as String,
          nextTile: data['nextTile'] as String,
          remainingTime: data['remainingTime'] as int,
        ));
    }
  }
}
printEverything(Game game, Player player, List<Game> games){
  print(game.toString());
  print(player.toString());
  print(games.toString());
  print('########################');
  if(game != null){
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
   });
   print('========================');
   print('This Player: ...');
   print('========================');
  print('id:   ' + player.id.toString());
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
  if(games.isEmpty){
    print('games: ...');
   print('========================');
   for (game in games){
     print('a game: ');
     print('  --> id:   ' + game.id.toString());
     print('  --> isRated:   ' + game.isRated.toString());
      print('-----------------------');
     }
  }
  print('########################');
}
}
