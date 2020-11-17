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
  String socketMessage;
  IO.Socket _socket = IO.io(SERVER_URL);

  String _userId = constUserId;
  String _token = constToken;
  int _userScore = 1000;

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

  GameProvider() {
    // try {
    _socket.on('games', (encodedData) {
      print(encodedData);
      final  data = json.decode(encodedData);
      if (data == null) {
        throw ('Couldnt read socket data!');
      }
      print('RECEIVED SOCKET MESSAGE');
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

  Future<void> createGame(
      // input: Takes all game Options as input
      // output: send a game-create req to server and receives a whole Game as JSON which will be converted into Game Model
      {bool isPublic,
      bool isRated,
      int increment,
      int time,
      int negDeviation,
      int posDeviation}) async {
    final int negRatingRange = _userScore + negDeviation;
    final int posRatingRange = _userScore + posDeviation;
    try {
      // defining url for Server post request.token and userId are used for authentification purposes
      final url = SERVER_URL + '/create-game?auth=$_token&id=$_userId';
      // sending async post request to server. Game options are encoded n req Body
      final response = await http.post(
        url,
        body: json.encode({
          'isPublic': isPublic,
          'isRated': isRated,
          'increment': increment,
          'time': time,
          'negRatingRange': negRatingRange,
          'posRatingRange': posRatingRange,
        }),
        // setting json/application as Content header so Server exects JSON format body. CORS error willbe handled Serverside in req headers
        headers: {'Content-Type': 'application/json'},
      );
      // rebasing the whole Game. COnverting JSON to Game Model Data. See Methode below
      _game = _rebaseWholeGame(response);
      print('successfully created game');
      // listening to now created Game lobby... Receives Lobby Data if another player joines
      _socket.on(_game.id, (encodedData) {
        final  data = json.decode(encodedData);
        if (!data['action']) {
          throw ('Error: No Action Key from Websocket!');
        }
        // handling socket Data. Look at Methode bellow. Different Action and Conversion will be excecuted depending on the ACTION keyword
        _handleSocketMessage(data);
      });
      // printing whole game if option to print it is set on true. Look on top ... at imports.. there printout options are defined
      if (printCreateGame) {
        _printEverything(_game, player, _games);
      }
      // ToDO : Remove line below
      if(_game != null){
      notifyListeners();
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> joinGame(String gameId) async {
    // input: takes a gameId as Inout the Auth User Wants to ioyn
    // output: Sends a Req to Server with the gven gameId. Then returns a whole Game
    try {
      // defining url : ioyn-game -> Server Keyword, token and userId queries for authentificaton on Server
      final url = SERVER_URL + '/join-game?auth=$_token&id=$_userId';
      // sends the join game post req to Server
      // gameId is encoded in the req. body
      final encodedResponse = await http.post(
        url,
        body: json.encode({
          'gameId': gameId,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      // validates received response and converts JSON Data to exisitng Game Model
      _game = _rebaseWholeGame(encodedResponse);
      // starts game If didStart is true => 3 Player are in the Game now and the server noticed that
      if (_game.didStart) {
        _startGame();
      }
      // print whole game Provider Data if option is set on true
        if (printjoinGame) {
      _printEverything(_game, player, _games);
        }
        if(_game != null){
        notifyListeners();
        }
      print('join Game user--- not soket');
      print('successfully created game');
      // listening to socket Game Lobby room
      // Potential Data that will be received via soket is id a player joined or a chess Move was made etc....
      _socket.on(_game.id, (encodedData) {
        final data = json.decode(encodedData);
        if (data['action'] == null) {
          throw ('Error: No Action Key from Websocket!');
        }
        // handling socket Data Depending on the Action Keyword
          _handleSocketMessage(data);
      });
    } catch (error) {
      throw ('An error occured while joining game:' + error);
    }
  }

  Future<void> sendMove(ChessMove chessMove) async {
    // input: receives a ChessMove as Input
    // output: sends chess move to server. Server validates and saves chess Move in Lobby of the Auth User. Then returns a json and socket response
    // chess Move will be saved in Game Model of all Player in Lobby
    try {
      // defines url: chess-move -> Server Keyword, auth and token for Server Side Authentification
      final url = SERVER_URL + '/chess-move?auth=$_token&id=$_userId';
      // sends Chess Move as encoded Map and as post Request to server
      // game Id will received by Server automatically cause gameId of auth User is saved in DB
     final encodedResponse = await http.post(
        url,
        body: json.encode({
          'initialTile': chessMove.initialTile,
          'nextTile': chessMove.nextTile,
          'remainingTime': chessMove.remainingTime,
        }),
        // set applicaton/json header so server expects JSON DATA
        headers: {'Content-Type': 'application/json'},
      );
      //using encodedResponse just for validation purposes
      final data = json.decode(encodedResponse.body);
      // Now Validation
      _validation(data);
      // You are also lstening becuause you created Or joined a Game
      // print everything depending on abogh set Options
    } catch (error) {
      print(error);
    }
  }

  Future<bool> sendTakeBackRequest() {}

  Future<bool> sendRemiOffer() {}

  surrender() {}

  Future<void> fetchGame() async {
    // input: VOID
    // output: sends a fetch Game request to Server. Will Receive a JSON Game. return a Game Model
    print('Start fetching Game');
    try {
      // defining url for Server: fetch-game ->  Server Keyword. userId and token for authentification on Serveer
      final url = SERVER_URL + '/fetch-game?auth=$_token&id=$_userId';
      // sending get request to server
      final encodedResponse = await http.get(url);
      print(encodedResponse.body);
      // convertes encoded Response from JSON to exisitng Game Model
      _game = _rebaseWholeGame(encodedResponse);
      // starts listening to Game Lobby Websoket (Message on player who joined Game or made a Chess move etc....)
      _socket.on(_game.id, (encodedData) {
        final data = json.decode(encodedData);
        if (data['valid'] == false) {
          throw ('Error: No Action Key from Websocket!');
        }
        _handleSocketMessage(data);
      });
      // prints all Data if option is set on true
      if (printFetchGame) {
        _printEverything(_game, player, _games);
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchGames() async {
    // input: VOID
    // output: sends fetch Games request to Server. Receives all Lobby Games a JSON From Server. Returns List of Lobby Games
    _games = [];
    print('start fetching games');
    try {
      // defining url for Server req: fetch-games -> Server Keyword. token and userId for Server authentification
      final url = SERVER_URL+ '/fetch-games?auth=$_token&id=$_userId';
      // sending async get request with given url to Server
      final encodedResponse = await http.get(url);
      // decodes received Data
      final data =json.decode(encodedResponse.body);
      // TODO : Delete Printout
      print(data);
      // validates Data
      _validation(data);
      // for each element in Lobby games Array rebase this Lobby Game:
      // Convert JSON Game Data toexisting Game Model
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
      print(error.toString());
    }
  }
  // only with scores

  _handleSocketMessage(data) {
    // input: receives Websocket Data That was send From Server
// output: depending on ACtion Keyword handles different types of Data and returns different Types of data..Chelc out Cases
    switch (data['action']) {
      case 'new-game':
      // input:message after Listening to Player Lobby
      // output: Adds a LObby Games ot _games Array
        print('socket: message...:  ' + data['message']);
        // rebaseing whole Lobby Game... Convertng JSON Data to exisitng Gaem Model
        _games.add(_rebaseLobbyGame(
          gameData: data['gameData'],
          playerData: data['gameData']['player'],
          userData: data['gameData']['user'],
        ));
        // print all Game Data if option is set on true
        if (printGameSocket) {
          _printEverything(_game, player, _games);
        }
        print('Finished adding new Lobby game to games');
        notifyListeners();
        break;
      case 'player-joined':
      // input: after listening to  player Lobby
      // output: receives a JSON Player and Adds a Player Model to existing Game in _games
        print('socket: message...:  ' + data['message']);
        // case for all players that player joined a game in the lobby
        print(data.toString());
        // retrieves the Index of the Game with the given gameId
        final int gameIndex =
            _games.indexWhere((e) => e.id == data['gameData']['_id']);
        print('index:   ' + gameIndex.toString());
        print(gameIndex);
        // adds the converted Player to the Game with the given gameId in _games
        _games[gameIndex]
            .player
            .add(_rebaseOnePlayer(
              playerData: data['gameData']['player'],
              userData: data['gameData']['user'],
            ));
        print('found game socket:   ' + _games[gameIndex].player.toString());
        print('player joined A game... socket');
        // if option is set on true print all gameProvider data
        if (printGameSocket) {
          _printEverything(_game, player, _games);
        }
        notifyListeners();
        break;
      case 'player-joined-lobby':
      // input: Message on Game Lobby Socket Message
      // output: receives a JSON Player Model and adds this as Player Model to exsting Game
        print('socket: message...:  ' + data['message']);
        // case handles the action for a user in a lobby who witnesses a join
        print(socketMessage);
        //add game to games
        _game.player.add(_rebaseOnePlayer(
          playerData: data['gameData']['player'],
          userData: data['gameData']['user'],
        ));
        // if did Start is true start game
        if (data['gameData']['didStart']) {
          _game.didStart = true;
          _startGame();
        }
        // print all game provider Data if option is set ot true
        if (printGameSocket) {
          _printEverything(_game, player, _games);
        }
        notifyListeners();
        break;
      case 'move-made':
      // input: Message on Player who Made Chess Move in Game Lobby
      // output: receives JSON Move Data. Adds ChessMove Model to existing Game
        print('socket: message...:  ' + data['message']);
        // rebases JSON Chess Move and adds it to existing game
        print('Received a Chess Move');
        //TODO : remove Printout
        print(data['chessMove']);
        _game.chessMoves.add(_rebaseOneMove(data['chessMove']));
        // print all Game Provider Data if optin was set to true
        // if (printGameSocket) {
          _printEverything(_game, player, _games);
        // }
        notifyListeners();
        break;
    }
  }
}



Game _rebaseWholeGame(encodedResponse) {
  // input: takes a encoded response from Server , where GameData in JSON is encoeded
  // output: Returns a game Model
  // here received Response is decoded
  final data = json.decode(encodedResponse.body);
  // TODO :remove data prin t
  print(data);
  // validation of the received Data. Look Methode below
  _validation(data);
  // extracting gameData, from JSON Response
  final gameData = data['gameData'];
  // convert Chess moves and add them to exisitng Chess Move Class
  List<ChessMove> chessMoves = [];
  // TODO : Delete
  print('Move Data');
  print(gameData['chessMoves']);
  gameData['chessMoves'].forEach(( e) => chessMoves.add(_rebaseOneMove(e)));
  // convert player List and add them to existing player class
  List<Player> convPlayer =
      _connectUserPlayerData(
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
  List<Player> convPlayer =
      _connectUserPlayerData(
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

List<Player> _connectUserPlayerData({ users, player}) {
  // input: get a Player JSON Object and a User JSON Object
  // output: return a Player model where User and Player are asigned
  List<Player> convPlayer = [];
  player.forEach((p) {
    print(p);
    final user = users?.firstWhere((u) =>p['userId'] == u['_id'], orElse: () => null);
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

