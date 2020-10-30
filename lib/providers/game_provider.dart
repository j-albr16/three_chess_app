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
  IO.Socket _socket = IO.io(SERVER_URL);
  String _userId;
  String _token;
  String _playerId;
  List<Game> _games;
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

  void update(String userId, String token, Game game, List<Game> games) {
    _userId = userId;
    _token = token;
    _games = games;
    _game = game;
  }

  get game {
    // for (int i=0;  i < 14;  i++){
    //   _game.chessMoves.add(_game.chessMoves[0]);
    // }
    // print(_game.chessMoves.length);
    return _game;
  }

  get games {
    return [..._games];
  }

  Future<void> createGame({bool isPublic, bool isRated, int increment, double time, int negRatingRange, int posRatingRange}) async {
    dynamic data;
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
      final List<Map<String, dynamic>> player = gameData['player'];
      final List<Player> convPlayer = player.map((e) => Player(
        playerColor: _getCurrentPlayer(e['playerColor']),
        remainingTime: e['remainingTime'],
        user: e['userId'],
      ));
      _game = new Game(
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
        _socket.on('/${_game.id}',
            (encodedData) => {data = json.decode(encodedData)});
        if (!data['action']) {
          throw ('Error: No Action Key from Websocket!');
        }
        _handleSocketMessage(data);
      } catch (error) {
        print(error);
        throw (error.toString());
      }
    }
  }

  Future<void> joynGame(){

  }

  _handleSocketMessage(dynamic data) {
    if (data['action'] == '') {}
    if (data['action']) {}
    if (data['action']) {}
  }
}

  void _connectSocket() {
    // _socket.connect();
  }
  void _disconnectSocket() {
    // _socket.disconnect();
  }
  void _subscribeToChannel(String event) {
    // _socket.on(event, (data) {
    //   _socketData.add({
    //     event: event,
    //     data: data
    //   });
    // });
  }

PlayerColor _getCurrentPlayer(int stringData){
  if(stringData == 1){
    return PlayerColor.white;
  }
  else if(stringData == 2){
    return PlayerColor.black;
  }
  else if(stringData == 3){
    return PlayerColor.red;
  }
  throw ('Error No current Player... data wasnt fetched properly propably xD');
}
