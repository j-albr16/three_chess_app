import 'dart:convert';
import 'dart:async';
import 'dart:html';

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
  String _playerId;
  int _userScore = 1000;

  List<Game> _games = [];
  Game _game;

  GameProvider() {
    // try {
    _socket.on('games', (encodedData) {
      print(encodedData);
      final data = json.decode(encodedData.toString());
      if (!data) {
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

  startGame() {}

  Future<void> createGame({bool isPublic, bool isRated, int increment, int time, int negDeviation, int posDeviation}) async {
    final int negRatingRange = _userScore + negDeviation;
    final int posRatingRange = _userScore + posDeviation;
    try {
      const url = SERVER_URL + '/create-game';
      final response = await http.post(
        url,
        body: json.encode({
          'token': _token,
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
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      // if (!decodedResponse['valid']) {
      //   final String errorMessage = decodedResponse['message'].toString();
      //   throw (errorMessage);
      // }
      // final gameData = decodedResponse['gameData'];
      // final player = gameData['player'];
      // final List<Player> convPlayer = player
      //     .map((e) => Player(
      //         playerColor: PlayerColor.values[data['playerColor']],
      //         remainingTime: e['remainingTime'],
      //         user: User(
      //           userName: e['user']['userName'],
      //           score: e['user']['score'],
      //           id: e['user']['userId'],
      //         )))
      //     .toList();
      // _playerId = gameData['playerId'];
      // _game = new Game(
      //   negRatingRange: gameData['options']['negRatingRange'],
      //   posRatingRange: gameData['options']['posRatingRange'],
      //   isPublic: gameData['options']['isPublic'],
      //   isRated: gameData['options']['isRated'],
      //   increment: gameData['options']['increment'],
      //   time: gameData['options']['time'],
      //   chessMoves: [],
      //   // startingBoard: gameData['startingBoard'],
      //   didStart: false,
      //   id: gameData['id'],
      //   player: convPlayer,
      // );
    } catch (error) {
      print(error.toString());
    }
    // finally {
    //   try {
    //     print('successfully created game');
    //     _socket.on('/${_game.id}', (encodedData) {
    //       dynamic data = json.decode(encodedData);
    //       if (!data['action']) {
    //         throw ('Error: No Action Key from Websocket!');
    //       }
    //       _handleSocketMessage(data);
    //     });
    //   } catch (error) {
    //     print(error);
    //     // throw (error.toString());
    //   }
  }

  Future<void> joynGame(String gameId) async {
    try {
      const url = SERVER_URL + '/joyn-game';
      final encodedResponse = await http.post(
        url,
        body: json.encode({'userId': _userId, 'gameId': gameId}),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(encodedResponse.body);
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
      _playerId = gameData['playerId'];
      _game = new Game(
        negRatingRange: gameData['options']['negRatingRange'],
        posRatingRange: gameData['options']['posRatingRange'],
        isPublic: gameData['options']['isPublic'],
        isRated: gameData['options']['isRated'],
        increment: gameData['options']['increment'],
        time: gameData['options']['time'],
        chessMoves: [],
        // startingBoard: gameData['startingBoard'],
        // currentPlayer: PlayerColor.white,
        didStart: gameData['didStart'],
        id: gameData['id'],
        player: convPlayer,
      );
      if (gameData['didStart']) {
        // startGame();
      }
    } catch (error) {
      throw ('An error occured while joyning game:' + error);
    } finally {
      try {
        print('successfully created game');
        _socket.on('/${_game.id}', (encodedData) {
          dynamic data = json.decode(encodedData);
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
      const url = SERVER_URL + '/chess-move';
      final encodedResponse = await http.post(
        url,
        body: json.encode({
          'playerId': _playerId,
          'initialTile': chessMove.initialTile,
          'nextTile': chessMove.nextTile,
          'gameId': _game.id,
          'remainingTime': chessMove.remainingTime,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      final data = json.decode(encodedResponse.body);
      if (!data) {
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
    try {
      final url = SERVER_URL + '/fetch-game/$_userId';
      final encodedResponse = await http.get(url);
      final data = json.decode(encodedResponse.body);
      if (!data) {
        throw ('fetch Game... No response from Server');
      }
      if (!data['valid']) {
        print(data['message']);
        throw ('send Data. Data wasnt valid');
      }
      print(data['message']);
      final gameData = data['gameData'];
      final chessMoves = gameData['chessMoves'].map((e) {
        return ChessMove(
          initialTile: e['initialTile'],
          nextTile: e['nextTile'],
          remainingTime: e['remainingTime'],
        );
      }).toList();
      final List<Player> convPlayer = gameData['player']
          .map((e) => Player(
              playerColor: PlayerColor.values[data['playerColor']],
              remainingTime: e['remainingTime'],
              user: User(
                userName: e['user']['userName'],
                score: e['user']['score'],
                id: e['user']['userId'],
              )))
          .toList();
      _playerId = gameData['playerId'];
      _game = new Game(
        negRatingRange: gameData['options']['negRatingRange'],
        posRatingRange: gameData['options']['posRatingRange'],
        isPublic: gameData['options']['isPublic'],
        isRated: gameData['options']['isRated'],
        increment: gameData['options']['increment'],
        time: gameData['options']['time'],
        chessMoves: chessMoves,
        // startingBoard: gameData['startingBoard'],
        didStart: gameData['didStart'],
        id: gameData['id'],
        player: convPlayer,
      );
      _socket.on('/${_game.id}', (encodedData) {
        dynamic data = json.decode(encodedData);
        if (!data['action']) {
          throw ('Error: No Action Key from Websocket!');
        }
        _handleSocketMessage(data);
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchGames() async {
    try {
      final url = SERVER_URL + '/fetch-games/$_userId';
      final encodedResponse = await http.get(url);
      final data = json.decode(encodedResponse.body);
      if (!data) {
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
    } catch (error) {
      print(error.toString());
    }
  }
  // only with scores

  _handleSocketMessage(dynamic data) {
    switch (data['action']) {
      case 'new-game':
        print(data['message']);
        _games.add(new Game(
            isRated: data['isRated'],
            negRatingRange: data['negRatingRange'],
            posRatingRange: data['posRatingRange'],
            didStart: false,
            id: data['id'],
            increment: data['increment'],
            time: data['time'],
            player: [
              new Player(
                playerColor: PlayerColor.values[data['playerColor']],
                remainingTime: data['time'],
                user: User(
                  id: data['userId'],
                  score: data['score'],
                  userName: data['userName'],
                ),
              ),
            ]));
        break;
      case 'player-joyned':
        // case for all players that player joyned a game in the lobby
        print(data['message']);
        final game = _games.firstWhere((e) => e.id == data['id']);
        game.player.add(
          new Player(
            remainingTime: data['time'],
            user: User(
              id: data['userId'],
              score: data['score'],
              userName: data['userName'],
            ),
          ),
        );
        break;
      case 'player-joyned-Lobby':
        // case handles the action for a user in a lobby who witnesses a joyn
        print(data['message']);
        socketMessage = 'Player' + data['userName'] + 'joyned the Game';
        final game = _games.firstWhere((e) => e.id == data['id']);
        //add game to games
        game.player.add(
          new Player(
            remainingTime: data['time'],
            playerColor: PlayerColor.values[data['playerColor']],
            user: User(
              id: data['userId'],
              score: data['score'],
              userName: data['userName'],
            ),
          ),
        );
        if (data['didStart']) {
          _game.didStart = true;
          startGame();
        }
        break;
      case 'move-made':
        print(data['message']);
        _game.chessMoves.add(new ChessMove(
          initialTile: data['initialTile'],
          nextTile: data['nextTile'],
          remainingTime: data['remainingTime'],
        ));
    }
  }
}
