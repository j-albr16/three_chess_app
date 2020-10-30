import 'dart:convert';
import 'dart:async';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_socket_io/flutter_socket_io.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess-move.dart';
import '../models/enums.dart';


const String SERVER_URL = 'http://localhost:3000';

class GameProvider with ChangeNotifier {
  String _userId;
   SocketIO socketIo;
  String _token;
   String _playerId;
  List<Game> _games;
  Game _game = Game(
  player:  [
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


  void update(String userId, String token, Game game, List<Game> games){
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
  get games{
    return [..._games];
  }
 
  Future<void> createGame() async{
    try{
       const url  = SERVER_URL + '/create-game';
    final response = await http.post(url, body: json.encode({
      'token': _token,
      'userId': _userId,
    }), headers: {'Content-Type': 'application/json'},);
    final decodedResponse = json.decode(response.body);
    if(!decodedResponse['valid']){
      final String errorMessage = decodedResponse['message'].toString();
      throw(errorMessage);
    }
    }catch(error){
      throw error.toString();
    }finally{

    }
  }
 
  void _connectSocket(){
  socketIo = SocketIOManager().createSocketIO(SERVER_URL, '/game/${_game.id}');
  socketIo.init();
  socketIo.subscribe('', (info) => {
    print(info)
  });
  socketIo.connect();
}

 _subscribe (String event){
  if(socketIo != null){
    socketIo.subscribe(event, (dynamic message){
      print(message);
      return message;
    });
  }
}

_sendChatMessage(String event, message){
  if(socketIo != null){
    String jsonData = json.encode(message);
    socketIo.sendMessage(event, jsonData, (cbMessage) {
      print(cbMessage);
      return cbMessage;
    });
  }
}

void _destroySocket (){
  if(socketIo != null){
    SocketIOManager().destroySocket(socketIo);
  }
}



}

