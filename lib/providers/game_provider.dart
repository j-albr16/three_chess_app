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
import '../models/chess-move.dart';
import '../models/enums.dart';

const String SERVER_URL = 'http://localhost:3000';

class GameProvider with ChangeNotifier {
  String socketMessage;
  IO.Socket _socket = IO.io(SERVER_URL);
  String _userId;
  String _token;
  String _playerId;

  List<Game> _games = [];
  Game _game = Game(
    player: [
      Player(
        playerColor: PlayerColor.white,
        user: User(
          userName: 'jan',
        ),
      ),
      Player(
        playerColor: PlayerColor.black,
        user: User(
          userName: 'leo',
        ),
      ),
      Player(
        playerColor: PlayerColor.red,
        user: User(
          userName: 'david',
        ),
      ),
    ],
    chessMoves: [
      {
        PlayerColor.white: ChessMove(
          initialTile: 'B2',
          nextTile: 'B4',
          piece: PieceType.Pawn,
        ),
        PlayerColor.black: ChessMove(
          initialTile: 'K7',
          nextTile: 'K5',
          piece: PieceType.Pawn,
        ),
        PlayerColor.red: ChessMove(
          initialTile: 'I11',
          nextTile: 'I9',
          piece: PieceType.Pawn,
        ),
      },
      {
        PlayerColor.white: ChessMove(
          initialTile: 'B4',
          nextTile: 'B5',
          piece: PieceType.Pawn,
        ),
        PlayerColor.black: ChessMove(
          initialTile: 'K5',
          nextTile: 'K4',
          piece: PieceType.Pawn,
        ),
        PlayerColor.red: ChessMove(
          initialTile: 'I9',
          nextTile: 'I8',
          piece: PieceType.Pawn,
        ),
      }
    ],
  );

  GameProvider() {
    try {
      _socket.on('games', (encodedData) {
        dynamic data = json.decode(encodedData);
        if (!data) {
          throw ('Couldnt read socket data!');
        }
        _handleSocketMessage(data);
      });
    } catch (error) {
      print(error);
    }
  }

  void update(String userId, String token, Game game, List<Game> games) {
    _userId = userId;
    _token = token;
    _games = games;
    _game = game;
  }

  get game {
    return _game;
  }

  get games {
    return [..._games];
  }

  Future<void> createGame(
      {bool isPublic,
      bool isRated,
      int increment,
      double time,
      int negRatingRange,
      int posRatingRange}) async {
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
      if (!decodedResponse['valid']) {
        final String errorMessage = decodedResponse['message'].toString();
        throw (errorMessage);
      }
      final gameData = decodedResponse['gameData'];
      final player = gameData['player'];
      final List<Player> convPlayer = player
          .map((e) => Player(
              playerColor: _getCurrentPlayer(e['playerColor']),
              remainingTime: e['remainingTime'],
              user: User(
                userName: e['user']['userName'],
                score: e['user']['score'],
                id: e['user']['userId'],
              )))
          .toList();
      _game = new Game(
        increment: gameData['options']['increment'],
        time: gameData['options']['time'],
        chessMoves: gameData['chessMoves'],
        startingBoard: gameData['startingBoard'],
        currentBoard: gameData['startingBoard'],
        currentPlayer: PlayerColor.white,
        didStart: false,
        id: gameData['id'],
        player: convPlayer,
      );
    } catch (error) {
      throw error.toString();
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

  Future<void> joynGame(String gameId) async {
    try {
      const url = SERVER_URL + '/joyn-game';
      final encodedResponse = await http.post(
        url,
        body: json.encode({'userId': _userId, 'gameId': gameId}),
      );
      final data = json.decode(encodedResponse.body);
      if (!data['valid']) {
        throw ('An error occured while joyning game. response Data wasnt true:' +
            data['message']);
      }
      final gameData = data['gameData'];
      final player = gameData['player'];
      final List<Player> convPlayer = player
          .map((e) => Player(
                playerColor: _getCurrentPlayer(e['playerColor']),
                remainingTime: e['remainingTime'],
                user: User(
                  id: e['user']['id'],
                  score: e['user']['score'],
                  userName: e['user']['userName'],
                ),
              ))
          .toList();
      _game = new Game(
        increment: gameData['options']['increment'],
        time: gameData['options']['time'],
        chessMoves: gameData['chessMoves'],
        currentBoard: gameData['startingBoard'],
        startingBoard: gameData['startingBoard'],
        currentPlayer: PlayerColor.white,
        didStart: false,
        id: gameData['id'],
        player: convPlayer,
      );
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

  _handleSocketMessage(dynamic data) {
    switch (data['action']) {
      case 'new-game':
        print(data['message']);
        _games.add(new Game(
            didStart: false,
            id: data['id'],
            increment: data['increment'],
            time: data['time'],
            player: [
              new Player(
                remainingTime: data['time'],
                user: User(
                  score: data['score'],
                  userName: data['userName'],
                ),
              ),
            ]));
        break;
      case 'player-joyned':
        print(data['message']);
        final game = _games.firstWhere((e) => e.id == data['id']);
        game.player.add(
          new Player(
            remainingTime: data['time'],
            user: User(
              score: data['score'],
              userName: data['userName'],
            ),
          ),
        );
        break;
      case 'player-joyned-Lobby':
        print(data['message']);
        socketMessage = 'Player' + data['userName'] + 'joyned the Game';
        _game.player.add(
          new Player(
            remainingTime: data['time'],
            playerColor: _getCurrentPlayer(data['playerColor']),
            user: User(
              id: data['id'],
              score: data['score'],
              userName: data['userName'],
            ),
          ),
        );
        break;
    }
  }
}

PlayerColor _getCurrentPlayer(int intData) {
  if (intData == 1) {
    return PlayerColor.white;
  } else if (intData == 2) {
    return PlayerColor.black;
  } else if (intData == 3) {
    return PlayerColor.red;
  }
  throw ('Error No current Player... data wasnt fetched properly propably xD');
}
