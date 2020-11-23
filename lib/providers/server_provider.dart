import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../data/server.dart';
import '../providers/chat_provider.dart';
import '../providers/friends_provider.dart';
import '../providers/user_provider.dart';
import '../models/chess_move.dart';
import '../helpers/user_acc.dart';
import '../models/user.dart';
import '../providers/game_provider.dart';

class ServerProvider with ChangeNotifier {
  IO.Socket _socket = IO.io(SERVER_ADRESS);

  String _token = constToken;
  String _userId = constUserId;

  String get _authString {
    return '?auth=$_token&userId=$_userId';
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  // TODO : Find a Better to make this User available
  User get user {
    return new User(
      id: _userId,
      score: 1000,
    );
  }

  void update({token, userId}) {
    _token = token;
    _userId = userId;
    notifyListeners();
  }

  //#########################################################################################################
// Subscribe to Socket Channels ---------------------------------------------------------------------------
  void subscribeToAuthUserChannel(
      {messageCallback,
      friendRequestCallback,
      friendAcceptedCallback,
      friendDeclinedCallback}) {
    _socket.on(_userId, (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      _handleAuthUserChannelSocketData(
          data,
          messageCallback,
          friendRequestCallback,
          friendAcceptedCallback,
          friendDeclinedCallback);
    });
  }

  void subscribeToLobbyChannel({newGameCallback, playerJoinedCallback}) {
    _socket.on('lobby', (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      _handleLobbyChannelData(data, newGameCallback, playerJoinedCallback);
    });
  }

  void subscribeToGameLobbyChannel(
      {String gameId, moveMadeCallback, playerJoinedLobbyCallback}) {
    _socket.on(gameId, (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      _handleGameLobbyChannelData(
          data, moveMadeCallback, playerJoinedLobbyCallback);
    });
  }
  //#########################################################################################################

  //#########################################################################################################
// unSubscribe to Socket Channel --------------------------------------------------------------------------
  void unSubscribeToAuthUserChannel() {
    _socket.off(_userId);
  }

  void unSubscribeToLobbyChannel() {
    _socket.off('lobby');
  }

  void unSubscribeToGameLobbyChannel(String gameId) {
    _socket.off(gameId);
  }
  //#########################################################################################################

  //#########################################################################################################
// Handle Socket Messages of different Channels -----------------------------------------------------------
  void _handleAuthUserChannelSocketData(
      Map<String, dynamic> data,
      Function messageCallback,
      Function friendRequestCallback,
      Function friendAcceptedCallback,
      Function friendDeclinedCallback) {
    switch (data['action']) {
      case 'message':
        _handleSocketServerMessage(data['action'], data['message']);
        messageCallback(data['messageData']);
        break;
      case 'friend-request':
        _handleSocketServerMessage(data['action'], data['message']);
        friendRequestCallback(data['friendData'], data['chatId']);
        break;
      case 'friend-accepted':
        _handleSocketServerMessage(data['action'], data['message']);
        friendAcceptedCallback(data['userId']);
        break;
      case 'friend-declined':
        _handleSocketServerMessage(data['action'], data['message']);
        friendDeclinedCallback(data['userId']);
        break;
    }
  }

  void _handleLobbyChannelData(Map<String, dynamic> data,
      Function newGameCallback, Function playerJoinedCallback) {
    switch (data['action']) {
      case 'new-game':
        _handleSocketServerMessage(data['action'], data['message']);
        newGameCallback(data['gameData']);
        break;
      case 'player-joined':
        _handleSocketServerMessage(data['action'], data['message']);
        playerJoinedCallback(data['gameData']);
        break;
    }
  }

  void _handleGameLobbyChannelData(Map<String, dynamic> data,
      Function moveMadeCallback, Function playerJoinedLobbyCallback) {
    switch (data['action']) {
      case 'move-made':
        _handleSocketServerMessage(data['action'], data['message']);
        moveMadeCallback(data['chessMove']);
        break;
      case 'player-joined-lobby':
        _handleSocketServerMessage(data['action'], data['message']);
        playerJoinedLobbyCallback(data['gameData']);
        break;
    }
  }
  //#########################################################################################################

  //#########################################################################################################
  // Friend Provider ---------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> sendFriendRequest(String userName) async {
    final String url = SERVER_ADRESS + 'friend-request' + _authString;
    // making http request
    final encodedResponse = await http.post(url,
        body: json.encode({'userName': userName}),
        headers: {'Content-Type': 'application/json'});
// decode Data
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
// Validation
    _validation(data);
    return data;
  }

  Future<Map<String, dynamic>> fetchFriends() async {
    final String url = SERVER_ADRESS + 'fetch-friends' + _authString;
    // http get request
    final encodedResponse = await http.get(url);
    print(encodedResponse.body);
    // decoding
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // validation
    _validation(data);
    return data;
  }

  Future<Map<String, dynamic>> acceptFriend(String userId) async {
    final String url = SERVER_ADRESS + 'accept-friend' + _authString;
    // http requets
    final encodedResponse = await http.post(url,
        body: json.encode({'userId': userId}),
        headers: {'Content-Type': 'application/json'});
    // decoding
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // validation
    _validation(data);
    return data;
  }

  Future<Map<String, dynamic>> friendDecline(String userId) async {
    final String url = SERVER_ADRESS + 'decline-friend' + _authString;
    // Make post http request
    final encodedData = await http.post(url,
        body: json.encode({'userId': userId}),
        headers: {'Content-Type': 'application/json'});
    // decode
    final Map<String, dynamic> data = json.decode(encodedData.body);
    _printRawData(data);
    // validation
    _validation(data);
    return data;
  }
  //#########################################################################################################

  //#########################################################################################################
  // Chat Provider -----------------------------------------------------------------------------------------
  Future<void> sendMessage(String text, String chatId) async {
    final url = SERVER_ADRESS + 'send-message' + _authString;
    await http.post(url,
        body: json.encode({'text': text, 'chatId': chatId}),
        headers: {'Content-Type': 'application/json'});
  }

  Future<Map<String, dynamic>> fetchChat(bool isGameChat, String id) async {
    final url = SERVER_ADRESS + 'fetch-chat' + _authString + '&id=$id';
    final encodedResponse = await http.get(url);
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // validation
    _validation(data);
    return data;
  }
  //#########################################################################################################

  //#########################################################################################################
  // Game Provider -----------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> createGame(
      {bool isPublic,
      bool isRated,
      int increment,
      int time,
      int negDeviation,
      int posDeviation}) async {
    // input: Takes all game Options as input
    // output: send a game-create req to server and receives a whole Game as JSON which will be converted into Game Model
    final int negRatingRange = user.score + negDeviation;
    final int posRatingRange = user.score + posDeviation;
    // defining url for Server post request.token and userId are used for authentification purposes
    final url = SERVER_URL + 'create-game' + _authString;
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
    // decode Data
    final Map<String, dynamic> data = json.decode(response.body);
    _printRawData(data);
    // validate Data
    _validation(data);
    // return data
    return data;
  }

  Future<Map<String, dynamic>> joinGame(String gameId) async {
    // input: takes a gameId as Inout the Auth User Wants to ioyn
    // output: Sends a Req to Server with the gven gameId. Then returns a whole Game
    // defining url : ioyn-game -> Server Keyword, token and userId queries for authentificaton on Server
    final url = SERVER_URL + 'join-game' + _authString;
    // sends the join game post req to Server
    // gameId is encoded in the req. body
    final encodedResponse = await http.post(
      url,
      body: json.encode({
        'gameId': gameId,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    // decode the Json Response
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // validate data
    _validation(data);
    // return data
    return data;
  }

  Future<void> sendMove(ChessMove chessMove) async {
    // input: receives a ChessMove as Input
    // output: sends chess move to server. Server validates and saves chess Move in Lobby of the Auth User. Then returns a json and socket response
    // chess Move will be saved in Game Model of all Player in Lobby
    // defines url: chess-move -> Server Keyword, auth and token for Server Side Authentification
    final url = SERVER_URL + 'chess-move' + _authString;
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
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // Now Validation
    _validation(data);
    // You are also lstening becuause you created Or joined a Game
    // print everything depending on abogh set Options
  }

  Future<Map<String, dynamic>> fetchGame() async {
    // input: Nothing
    // output: sends a fetch Game request to Server. Will Receive a JSON Game. return a Game Model
    print('Start fetching Game');
    // defining url for Server: fetch-game ->  Server Keyword. userId and token for authentification on Serveer
    final url = SERVER_URL + 'fetch-game' + _authString;
    // sending get request to server
    final encodedResponse = await http.get(url);
    // decoding JSON
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // validation
    _validation(data);
    return data;
  }

  Future<Map<String, dynamic>> fetchGames() async {
    // input:nothing
    // output: sends fetch Games request to Server. Receives all Lobby Games a JSON From Server. Returns List of Lobby Games
    print('start fetching games');
    // defining url for Server req: fetch-games -> Server Keyword. token and userId for Server authentification
    final url = SERVER_URL + 'fetch-games' + _authString;
    // sending async get request with given url to Server
    final encodedResponse = await http.get(url);
    // decodes received Data
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    _printRawData(data);
    // validates Data
    _validation(data);
    // Game Provider Fetch Games
    return data;
  }
  //#########################################################################################################

  void _validation(Map<String, dynamic> data) {
    if (data == null) {
      throw ('No Data was Received. Data is null');
    }
    if (!data['valid']) {
      throw ('Data is not Valid. This is the Message sent from Server:   ' +
          data['message']);
    }
  }

//############################################################################################################
// Helper Functions -----------------------------------------------------------------------------------------
  void handleError(String errorText, dynamic error) {
    print(
        '-----------------------------------------------------------------------------------------------');
    print(
        'An Error Occured ------------------------------------------------------------------------------');
    print(errorText);
    print(
        'this is the thrown Error ----------------------------------------------------------------------');
    print(error);
    print(
        '------------------------------------------------------------------------------------------------');
  }
}

void _handleSocketServerMessage(String action, String message) {
  print(
      '-------------------------------------------------------------------------------------------------');
  print(
      'Received Socket Data------------------------------------------------------------------------------');
  print(
      'Socket Message ... :   ---------------------------------------------------------------------------');
  print('$message   ');
  print(
      'Action Key String   ------------------------------------------------------------------------------');
  print(action);
  print(
      '-------------------------------------------------------------------------------------------------');
}

void _printRawData(dynamic data) {
  print(
      '-------------------------------------------------------------------------------------------------');
  print(
      'RAW DATA     ------------------------------------------------------------------------------------');
  print(data);
  print(
      '-------------------------------------------------------------------------------------------------');
}