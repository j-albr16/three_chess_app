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
    playerColor: PlayerColor.white,
    user: new User(
      email: 'jan.albrecht2000@gmail.com',
    ),
  );

  Player get player {
    return _player;
  }

  List<Game> _games = [];
  Game game = Game(chessMoves: [],
      isRated: true,
      isPublic: true,
      player: [],
      time: 40,
      increment: 2,
      didStart: true);

  GameProvider() {

  }

// updated vlaues from ProxyProvider:
  void update(String userId, String token, Game game, List<Game> games) {

  }

// providing game data for screen
// provding games data for lobby
  get games {
    return [..._games];
  }

  Future<void> fetchAll() async {
    //print('start fetching games');
    await fetchGame();
    await fetchGames();
    //printEverything(_game, player, _games);
  }

  startGame() {
    // print('=================================');
    // print('3 players are i the Game');
    // print('Game can start');
    // print('=================================');
  }

  Future<void> createGame({bool isPublic,
    bool isRated,
    int increment,
    int time,
    int negDeviation,
    int posDeviation}) async {

  }

  Future<void> joynGame(String gameId) async {

  }

  Future<void> sendMove(ChessMove chessMove) async {

  }

  Future<bool> sendTakeBackRequest() {}

  Future<bool> sendRemiOffer() {}

  surrender() {}

  Future<void> fetchGame() async {

  }

  Future<void> fetchGames() async {

  }

  // only with scores

  _handleSocketMessage(dynamic data) {

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
      });
    }
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
    gameData['chessMoves'].forEach((e) =>
        chessMoves.add(new ChessMove(
          initialTile: gameData['initialTile'],
          nextTile: gameData['nextTile'],
          remainingTime: gameData['remainingTime'],
        )));
    // convert player List and add them to existing player class
    List<Player> convPlayer = [];
    gameData['player'].forEach((e) =>
        convPlayer.add(new Player(
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
    gameData['player'].forEach((e) {
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
}