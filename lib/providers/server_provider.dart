import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:three_chess/models/message.dart';
import 'package:three_chess/providers/popup_provider.dart';

import '../data/server.dart';
import '../models/chess_move.dart';
import '../helpers/user_acc.dart';
import '../models/user.dart';
import '../models/online_game.dart';
import '../helpers/print.dart';
import '../providers/game_provider.dart';
import '../models/enums.dart';

// Auth User Callback
typedef void Message(Map<String, dynamic> messageData);
typedef void FriendRequest(Map<String, dynamic> friendData, String message);
typedef void FriendAccept(Map<String, dynamic> data);
typedef void FriendDecline(String message);
typedef void FriendRemove(String userId, String message);
typedef void FriendStatusUpdate(
    String userId, bool isOnline, bool isActive, bool isPlaying);
typedef void GameInvitation(Map<String, dynamic> gameData);
// OnlineGame Callbacks
typedef void Move(Map<String, dynamic> chessMove, String gameId);
typedef void SurrenderRequest(String userId, int chessMove, String gameId);
typedef void SurrenderDecline(String userId, String gameId);
typedef void RemiRequest(String userId, int chessMove, String gameId);
typedef void RequestCancelled(Map<String, dynamic> data, String gameId);
typedef void RemiAccept(String userId, String gameId);
typedef void RemiDecline(String userId, String gameId);
typedef void TakeBackRequest(String userId, int chessMove, String gameId);
typedef void TakeBackAccept(String userId, String gameId);
typedef void TakenBack(String userId, int chessMove, String gameId);
typedef void TakeBackDecline(String userId, String gameId);
typedef void GameFinished(Map<String, dynamic> data, String gameId);
typedef void SurrenderFailed(String gameId);
typedef void PlayerIsOnline(String userId);
typedef void PlayerIsOffline(String userId, String expiryDate);
// Lobby Callbacks
typedef void PlayerJoined(Map<String, dynamic> gameData);
typedef void NewGame(Map<String, dynamic> gameData);
typedef void UpdateIsReadyStatus(String userId, bool isReady, String gameId);
typedef void RemoveGame(String gameId);
typedef void PlayerLeft(String gameId, String userId, bool remove);
// Auth User Channel 2
typedef void GameStarts(Map<String, dynamic> gameData);
// Listener
typedef void GameStartsListener(String gameId);

const List<Method> methodsInProcess = [
  // Method.LeaveLobby,
  // Method.HandlePlayerLeft,
  // Method.HandleNewGame,
  // Method.CreateGame,
  // Method.HandleGameStarts,
  // Method.HandlePlayerJoined,
  // Method.HandleMessage,

  // Method.FetchOnlineGames,
  Method.QuickPairing,
  Method.StopQuickPairing,
  Method.GetPossiblePairings,
];

class ServerProvider with ChangeNotifier {
  IO.Socket _socket = IO.io(SERVER_ADRESS, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  String _token = constToken;
  String _userId = constUserId;

  PopupProvider _popupProvider;

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
  // User get user {
  //   return new User(
  //     id: _userId,
  //     score: 1000,
  //   );
  // }

  void update({String token, String userId, PopupProvider popupProvider}) {
    // _token = token;
    // _userId = userId;
    _popupProvider = popupProvider;
    notifyListeners();
  }

  // ###############################################################################
  // Socket

  //#########################################################################################################
// Subscribe to Socket Channels ---------------------------------------------------------------------------
  void subscribeToAuthUserChannel2({GameStarts gameStartsCallback}) {
    print('Subscribe To Auth User Channel 2');
    _socket.on('$_userId/2', (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      data['ident'] = Method.values[data['ident']];
      _handleAuthUserChannelSocketData2(
          data: data, gameStartsCallback: gameStartsCallback);
    });
  }

  void subscribeToAuthUserChannel({
    Message messageCallback,
    FriendRequest friendRequestCallback,
    FriendAccept friendAcceptedCallback,
    FriendDecline friendDeclinedCallback,
    FriendRemove friendRemovedCallback,
    FriendStatusUpdate friendStatusUpdate,
    GameInvitation gameInvitationsCallback,
  }) {
    print('Subscribe to Auth USer Channel');
    // try {
    _socket.on(_userId, (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      data['ident'] = Method.values[data['ident']];
      _handleAuthUserChannelSocketData(
          data: data,
          messageCallback: messageCallback,
          friendRequestCallback: friendRequestCallback,
          friendAcceptedCallback: friendAcceptedCallback,
          friendDeclinedCallback: friendDeclinedCallback,
          friendRemovedCallback: friendRemovedCallback,
          friendStatusUpdateCallback: friendStatusUpdate,
          gameInvitationCallback: gameInvitationsCallback);
    });
  }

  void subscribeToLobbyChannel(
      {newGameCallback,
      playerJoinedCallback,
      updateIsReadyStatus,
      removeGameCallback,
      playerLeftCallback}) {
    print('Did Subscribe to Lobby Channel');
    _socket.on('lobby', (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      data['ident'] = Method.values[data['ident']];
      _handleLobbyChannelData(
          playerLeftCallback: playerLeftCallback,
          data: data,
          newGameCallback: newGameCallback,
          playerJoinedCallback: playerJoinedCallback,
          updateIsReadyStatusCallback: updateIsReadyStatus,
          removeGameCallback: removeGameCallback);
    });
  }

  void subscribeToGameLobbyChannel(
      {String gameId, UpdateIsReadyStatus updateIsReadyStatus}) {
    print('Did Subscribe to Game Lobby Channel');
    _socket.on('$gameId/lobby', (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      data['ident'] = Method.values[data['ident']];
      _handleGameLobbyChannel(
          data: data, updateIsReadyStatusCb: updateIsReadyStatus);
    });
  }

  void subscribeToGameChannel({
    String gameId,
    Move moveMadeCallback,
    SurrenderRequest surrenderRequestCallback,
    SurrenderDecline surrenderDeclineCallback,
    RemiRequest remiRequestCallback,
    RemiAccept remiAcceptCallback,
    RemiDecline remiDeclineCallback,
    TakeBackRequest takeBackRequestCallback,
    TakeBackAccept takeBackAcceptCallback,
    TakenBack takenBackCallback,
    TakeBackDecline takeBackDeclineCallback,
    GameFinished gameFinishedCallback,
    SurrenderFailed surrenderFailedCallback,
    PlayerIsOnline playerIsOnlineCallback,
    RequestCancelled requestCancelledCallback,
    PlayerIsOffline playerIsOfflineCallback,
  }) {
    print('Ddi Subscribe to OnlineGame Channel');
    // try {
    _socket.on(gameId, (jsonData) {
      final Map<String, dynamic> data = json.decode(jsonData);
      data['ident'] = Method.values[data['ident']];
      _handleGameChannelData(
        data: data,
        moveMadeCallback: moveMadeCallback,
        surrenderRequestCallback: surrenderRequestCallback,
        surrenderDeclineCallback: surrenderDeclineCallback,
        remiRequestCallback: remiRequestCallback,
        requestCancelledCallback: requestCancelledCallback,
        remiAcceptCallback: remiAcceptCallback,
        remiDeclineCallback: remiDeclineCallback,
        takeBackRequestCallback: takeBackRequestCallback,
        takeBackAcceptCallback: takeBackAcceptCallback,
        takenBackCallback: takenBackCallback,
        takeBackDeclineCallback: takeBackDeclineCallback,
        gameFinishedCallback: gameFinishedCallback,
        surrenderFailedCallback: surrenderFailedCallback,
        playerIsOnlineCallback: playerIsOnlineCallback,
        playerIsOfflineCallback: playerIsOfflineCallback,
      );
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
// Handatadle Socket Messages of different Channels -----------------------------------------------------------
  void _handleGameLobbyChannel(
      {data, UpdateIsReadyStatus updateIsReadyStatusCb}) {
    _handleSocketServerMessage(data['ident'], data['message'], data);
    switch (data['ident']) {
      case Method.HandleUpdateIsReadyStatus:
        updateIsReadyStatusCb(data['userId'], data['isReady'], data['gameId']);
        break;
    }
  }

  void _handleAuthUserChannelSocketData2(
      {Map<String, dynamic> data, GameStarts gameStartsCallback}) {
    _handleSocketServerMessage(data['ident'], data['message'], data);
    switch (data['ident']) {
      case Method.HandleGameStarts:
        gameStartsCallback(data['gameData']);
        break;
    }
  }

  void _handleAuthUserChannelSocketData({
    Map<String, dynamic> data,
    Message messageCallback,
    FriendRequest friendRequestCallback,
    FriendAccept friendAcceptedCallback,
    FriendDecline friendDeclinedCallback,
    FriendRemove friendRemovedCallback,
    FriendStatusUpdate friendStatusUpdateCallback,
    GameInvitation gameInvitationCallback,
  }) {
    _handleSocketServerMessage(data['ident'], data['message'], data);
    switch (data['ident']) {
      case Method.HandleMessage:
        messageCallback(data['messageData']);
        break;
      case Method.HandleFriendRequest:
        friendRequestCallback(data['friendData'], data['message']);
        break;
      case Method.HandleFriendAccept:
        friendAcceptedCallback(data);
        break;
      case Method.HandleFriendDecline:
        friendDeclinedCallback(data['message']);
        break;
      case Method.HandleFriendRemove:
        friendRemovedCallback(data['userId'], data['message']);
        break;
      case Method.HandleUserStatusUpdate:
        friendStatusUpdateCallback(data['userId'], data['isOnline'],
            data['isActive'], data['isPlaying']);
        break;
      case Method.HandleGameInvitation:
        gameInvitationCallback(data['gameData']);
        break;
    }
  }

  void _handleLobbyChannelData(
      {Map<String, dynamic> data,
      NewGame newGameCallback,
      RemoveGame removeGameCallback,
      PlayerJoined playerJoinedCallback,
      PlayerLeft playerLeftCallback,
      UpdateIsReadyStatus updateIsReadyStatusCallback}) {
    _handleSocketServerMessage(data['ident'], data['message'], data);
    switch (data['ident']) {
      case Method.HandleNewGame:
        newGameCallback(data['gameData']);
        break;
      case Method.HandlePlayerJoined:
        playerJoinedCallback(data['gameData']);
        break;
      case Method.HandleRemoveGame:
        removeGameCallback(data['gameId']);
        break;
      case Method.HandlePlayerLeft:
        playerLeftCallback(data['gameId'], data['userId'], data['remove']);
        break;
    }
  }

  void _handleGameChannelData({
    String gameId,
    Map<String, dynamic> data,
    Move moveMadeCallback,
    SurrenderRequest surrenderRequestCallback,
    SurrenderDecline surrenderDeclineCallback,
    RemiRequest remiRequestCallback,
    RemiAccept remiAcceptCallback,
    RemiDecline remiDeclineCallback,
    TakeBackRequest takeBackRequestCallback,
    TakeBackAccept takeBackAcceptCallback,
    TakenBack takenBackCallback,
    TakeBackDecline takeBackDeclineCallback,
    GameFinished gameFinishedCallback,
    SurrenderFailed surrenderFailedCallback,
    PlayerIsOnline playerIsOnlineCallback,
    PlayerIsOffline playerIsOfflineCallback,
    RequestCancelled requestCancelledCallback,
  }) {
    _handleSocketServerMessage(data['ident'], data['message'], data);
    switch (data['ident']) {
      case Method.HandleMove:
        moveMadeCallback(data['chessMove'], gameId);
        break;
      case Method.HandleSurrenderRequest:
        surrenderRequestCallback(data['userId'], data['chessMove'], gameId);
        break;
      case Method.HandleSurrenderDecline:
        surrenderDeclineCallback(data['userId'], gameId);
        break;
      case Method.HandleSurrenderFailed:
        surrenderFailedCallback(gameId);
        break;
      case Method.HandleRemiRequest:
        remiRequestCallback(data['userId'], data['chessMove'], gameId);
        break;
      case Method.HandleRemiAccept:
        remiAcceptCallback(data['userId'], gameId);
        break;
      case Method.HandleRemiDecline:
        remiDeclineCallback(data['userId'], gameId);
        break;
      case Method.HandleRequestCancelled:
        requestCancelledCallback(data, gameId);
        break;
      case Method.HandleTakeBackRequest:
        takeBackRequestCallback(data['userId'], data['chessMove'], gameId);
        break;
      case Method.HandleTakeBackAccept:
        takeBackAcceptCallback(data['userId'], gameId);
        break;
      case Method.HandleTakeBack:
        takenBackCallback(data['userId'], data['chessMove'], gameId);
        break;
      case Method.HandleTakeBackDecline:
        takeBackDeclineCallback(data['userId'], gameId);
        break;
      case Method.HandleGameFinished:
        gameFinishedCallback(data, gameId);
        break;
      case Method.HandlePlayerIsOnline:
        playerIsOnlineCallback(data['userId']);
        break;
      case Method.HandlePlayerIsOffline:
        playerIsOfflineCallback(data['userId'], data['expiryDate']);
        break;
    }
  }

  // ##################################################################################
  // Listener
  Map<String, GameStartsListener> gameStartCbs = {};

  void addGameListener(String gameId, GameStartsListener gameStartsCb) {
    gameStartCbs[gameId] = gameStartsCb;
  }

  void removeGameListener(String gameId) {
    gameStartCbs.remove(gameId);
  }

  void gameStartsNotifier(String gameId) {
    print('Notifying Game Ends Listener');
    GameStartsListener gameStartsListener = gameStartCbs[gameId];
    if (gameStartsListener != null) {
      print('Listener was found and will be executed');
      gameStartsListener(gameId);
    }
  }

// ##############################################################################################
// HTTP

  Future<Map<String, dynamic>> fetchAuthUser() async {
    try {
      return await getSkeleton(
        error: 'Fetching Auth User',
        url: SERVER_ADRESS + 'user' + _authString,
      );
    } catch (error) {
      throw (error);
    }
  }

  Future<Map<String, dynamic>> onlineStatusUpdate() async {
    final String url = SERVER_ADRESS + 'online' + _authString;
    final encodedResponse = await http.get(url);
    final Map<String, dynamic> data = json.decode(encodedResponse.body);
    return data;
  }

//#########################################################################################################
// Local Games -------------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> fetchLocalGames() async {
    return await getSkeleton(
      error: 'Fetching Local Games',
      url: SERVER_ADRESS + 'fetch-local-games' + _authString,
    );
  }

  List<Map<String, dynamic>> rebaseChessMoves(List<ChessMove> chessMoves) {
    return chessMoves
        .map((chessMove) => {
              'remainingTime': chessMove.remainingTime,
              'initialTile': chessMove.initialTile,
              'nextTile': chessMove.nextTile,
            })
        .toList();
  }

  Future<Map<String, dynamic>> saveGames(
      OnlineGame localGame, OnlineGame analyzeGame) async {
    final List<Map<String, dynamic>> analyzeChessMoves =
        rebaseChessMoves(analyzeGame.chessMoves);
    final List<Map<String, dynamic>> localChessMoves =
        rebaseChessMoves(localGame.chessMoves);
    final Map<String, dynamic> body = {
      'analyzeGame': {'chessMoves': analyzeChessMoves},
      'localGame': {
        'chessMoves': localChessMoves,
        'options': {'time': localGame.time, 'increment': localGame.increment}
      }
    };
    return await postSkeleton(
      url: SERVER_ADRESS + 'save-local-games' + _authString,
      error: 'Saving Local Games',
      body: body,
    );
  }

//#########################################################################################################
// Friend Provider ---------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> sendFriendRequest(String userName) async {
    return await postSkeleton(
      body: {'userName': userName},
      error: 'Friend Request',
      url: SERVER_ADRESS + 'friend-request' + _authString,
    );
  }

  Future<Map<String, dynamic>> fetchFriends() async {
    return await getSkeleton(
      url: SERVER_ADRESS + 'fetch-friends' + _authString,
      error: 'Fetching Friends',
    );
  }

  Future<Map<String, dynamic>> acceptFriend(String userId) async {
    return await postSkeleton(
      error: 'Accept Friend',
      url: SERVER_ADRESS + 'accept-friend' + _authString,
      body: {'userId': userId},
    );
  }

  Future<Map<String, dynamic>> friendDecline(String userId) async {
    return await postSkeleton(
      url: SERVER_ADRESS + 'decline-friend' + _authString,
      body: {'userId': userId},
      error: 'Friend Decline',
    );
  }

  Future<Map<String, dynamic>> friendRemove(String userId) async {
    return await postSkeleton(
      error: 'Friend Remove',
      body: {'userId': userId},
      url: SERVER_ADRESS + 'remove-friend' + _authString,
    );
  }

//#########################################################################################################

//#########################################################################################################
// Chat Provider -----------------------------------------------------------------------------------------
  Future<void> sendMessage(String text, String chatId) async {
    await postSkeleton(
        url: SERVER_ADRESS + 'send-message' + _authString,
        body: {'text': text, 'chatId': chatId},
        error: 'Post Message');
  }

  Future<Map<String, dynamic>> fetchChat(ChatType chatType, String id) async {
    return await getSkeleton(
        error: 'Fetch Chat',
        url: SERVER_ADRESS +
            'fetch-chat' +
            _authString +
            '&id=$id&chatType=${chatType.index}');
  }

//#########################################################################################################

//#########################################################################################################
// fetch Invitations
  Future<Map<String, dynamic>> fetchInvitations() async {
    return await getSkeleton(
      url: SERVER_ADRESS + 'invitations' + _authString,
      error: 'Fetch Invitations',
    );
  }

  Future<bool> declineInvitation(String gameId, bool all) async {
    final Map<String, dynamic> data = await postSkeleton(
        url: SERVER_ADRESS + 'decline-invitation' + _authString,
        error: 'Decline Invitation',
        body: {
          'gameIds': gameId,
          'all': all,
        });
    return data['valid'];
  }

// OnlineGame Provider #########################################################
  // Lobby Game ----------------------------------------------------------------
  Future<Map<String, dynamic>> leaveLobby(String gameId) async {
    return await getSkeleton(
      error: 'leave Lobby',
      url: SERVER_ADRESS + 'leave-lobby/$gameId' + _authString,
    );
  }

  Future<Map<String, dynamic>> updateIsReady(
      bool isReady, String gameId) async {
    return await getSkeleton(
      url: SERVER_ADRESS + 'is-ready-status/$isReady/$gameId' + _authString,
      error: 'Is Ready Status',
    );
  }

  Future<Map<String, dynamic>> quickPairing({int time, int increment}) async {
    return await getSkeleton(
      error: 'quick pairing',
      url: SERVER_ADRESS + 'quick-pairing/$time/$increment' + _authString,
    );
  }

  Future<Map<String, dynamic>> stopQuickPairing() async {
    return await getSkeleton(
      url: SERVER_ADRESS + 'stop-quick-pairing' + _authString,
      error: 'stop quick Pairing',
    );
  }

  Future<Map<String, dynamic>> getPossibleMatches(
      int time, int increment) async {
    return await getSkeleton(
      url:
          SERVER_ADRESS + 'get-possible-matches/$time/$increment' + _authString,
      error: 'Getting Possible Matches',
    );
  }

  Future<Map<String, dynamic>> findAGameLike(
      Map<String, dynamic> settings) async {
    return await postSkeleton(
      url: SERVER_ADRESS + 'find-a-game-like' + _authString,
      error: 'Find A OnlineGame Like',
      body: settings,
    );
  }

  Future<Map<String, dynamic>> createGame(
      {bool isPublic,
      bool isRated,
      int increment,
      List<String> invitations,
      int time,
      bool allowPremades,
      int negRatingRange,
      int posRatingRange}) async {
    final Map<String, dynamic> body = {
      'isPublic': isPublic,
      'isRated': isRated,
      'increment': increment,
      'invitations': invitations,
      'allowPremades': allowPremades,
      'time': time,
      'negRatingRange': negRatingRange,
      'posRatingRange': posRatingRange,
    };
    return await postSkeleton(
      body: body,
      error: 'Create OnlineGame',
      url: SERVER_URL + 'create-game' + _authString,
    );
  }

  Future<Map<String, dynamic>> joinGame(String gameId) async {
    return await postSkeleton(
        url: SERVER_URL + 'join-game' + _authString,
        error: 'Join OnlineGame',
        body: {'gameId': gameId});
  }

  Future<Map<String, dynamic>> fetchPendingGames() async {
    return await getSkeleton(
      url: SERVER_ADRESS + 'fetch-pending-games' + _authString,
      error: 'Fetch Lobbies',
    );
  }

  Future<Map<String, dynamic>> fetchLobbyGames() async {
    return await getSkeleton(
        url: SERVER_URL + 'fetch-lobby-games' + _authString,
        error: 'Fetch Lobby Games');
  }

  Future<void> createTestGame() async {
    await getSkeleton(
      error: 'Creating Test OnlineGame',
      url: SERVER_ADRESS + 'create-test-game' + _authString,
    );
  }

  // Running Game -------------------------------------------------------------

  Future<Map<String, dynamic>> sendMove(
      ChessMove chessMove, String gameId) async {
    return await postSkeleton(
      body: {
        'gameId': gameId,
        'chessMove': {
          'initialTile': chessMove.initialTile,
          'nextTile': chessMove.nextTile,
          'remainingTime': chessMove.remainingTime,
        }
      },
      error: 'Send Move',
      url: SERVER_URL + 'chess-move' + _authString,
    );
  }

  Future<Map<String, dynamic>> fetchOnlineGames() async {
    return await getSkeleton(
      error: 'Fetch Online Games',
      url: SERVER_ADRESS + 'fetch-online-games' + _authString,
    );
  }

  Future<Map<String, dynamic>> fetchOnlineGame(String gameId) async {
    return await getSkeleton(
        url: SERVER_URL + 'fetch-online-game/$gameId' + _authString,
        error: 'Fetch OnlineGame');
  }

  Future<String> requestSurrender(String gameId) async {
    final Map<String, dynamic> data = await getSkeleton(
      url: SERVER_ADRESS + 'request-surrender/$gameId' + _authString,
      error: 'Request Surrender',
    );
    return data['message'];
  }

  Future<String> acceptSurrender(String gameId) async {
    final Map<String, dynamic> data = await getSkeleton(
        url: SERVER_ADRESS + 'accept-surrender/$gameId' + _authString,
        error: 'Accept Surrender');
    return data['message'];
  }

  Future<Map<String, dynamic>> declineSurrender(String gameId) async {
    return await getSkeleton(
        url: SERVER_ADRESS + 'decline-surrender/$gameId' + _authString,
        error: 'Decline Surrender');
  }

  Future<String> requestRemi(String gameId) async {
    final Map<String, dynamic> data = await getSkeleton(
      error: 'Request Remi',
      url: SERVER_ADRESS + 'request-remi/$gameId' + _authString,
    );
    return data['message'];
  }

  Future<String> acceptRemi(String gameId) async {
    final Map<String, dynamic> data = await getSkeleton(
        url: SERVER_ADRESS + 'accept-remi/$gameId' + _authString,
        error: 'Accept Remi');
    return data['message'];
  }

  Future<Map<String, dynamic>> declineRemi(String gameId) async {
    return await getSkeleton(
        url: SERVER_ADRESS + 'decline-remi/$gameId' + _authString,
        error: 'Decline Remi');
  }

  Future<String> requestTakeBack(String gameId) async {
    final Map<String, dynamic> data = await getSkeleton(
      url: SERVER_ADRESS + 'request-takeback/$gameId' + _authString,
      error: 'Request Take Back',
    );
    return data['message'];
  }

  Future<String> acceptTakeBack(String gameId) async {
    final Map<String, dynamic> data = await getSkeleton(
        error: 'Accept Take Back',
        url: SERVER_ADRESS + 'accept-takeback/$gameId' + _authString);
    return data['message'];
  }

  Future<Map<String, dynamic>> declineTakeBack(String gameId) async {
    return await getSkeleton(
        url: SERVER_ADRESS + 'decline-takeback/$gameId' + _authString,
        error: 'Decline Take Back');
  }

  Future<Map<String, dynamic>> cancelRequest(
      int requestType, String gameId) async {
    return await postSkeleton(
        error: 'Cancel Request',
        url: SERVER_ADRESS + 'cancel-request/$gameId' + _authString,
        body: {'requestType': requestType});
  }

//########################################################################################################
  Future<Map<String, int>> getCount() async {
    final Map<String, dynamic> data = await getSkeleton(
      url: SERVER_ADRESS + 'count' + _authString,
      error: 'Get Count',
    );
    return {
      'player': data['playerCount'],
      'games': data['gamesCount'],
      'users': data['usersCount'],
    };
  }

  Future<void> sendErrorReport(String text) async {
    await postSkeleton(
        error: 'Send Error Report',
        url: SERVER_ADRESS + 'error-report' + _authString,
        body: {'error': text});
  }

//#########################################################################################################

  _validation(Map<String, dynamic> data) {
    if (data == null) {
      throw ('No Data was Received. Data is low');
    }
    if (!data['valid']) {
      if (data['errorType'] == ErrorType.Response.index) {
        dynamic errorBody = data['body'];
        displayErrorPopUp(errorBody);
      }
      // else if (data['errorType'] == ErrorType.Critical) {
      throw data['message'];
      // }
      // throw 'Valid Error';
    }
  }

  void displayErrorPopUp(errorBody) {
    if (errorBody['errorResponseType'] == ErrorResponseType.Snackbar.index) {
      _popupProvider
          .makePopUp[PopUpType.SnackBar](errorBody['responseMessage']);
    }
  }

//############################################################################################################
// Helper Functions -----------------------------------------------------------------------------------------
  Future<Map<String, dynamic>> postSkeleton(
      {String error, Map<String, dynamic> body, String url}) async {
    try {
      print('Starting to $error');
      String jsonBody = json.encode(body);
      final encodedResponse = await http.post(url,
          body: jsonBody, headers: {'Content-Type': 'application/json'});
      final Map<String, dynamic> data = await json.decode(encodedResponse.body);
      _printRawData(data);
      _validation(data);
      return data;
    } catch (error) {
      throw ('ERROR: $error');
    }
  }

  Future<Map<String, dynamic>> getSkeleton({String url, String error}) async {
    try {
      print('Starting to $error');
      final encodedResponse = await http.get(url);
      final Map<String, dynamic> data = json.decode(encodedResponse.body);
      _printRawData(data);
      _validation(data);
      return data;
    } catch (error) {
      throw (error);
    }
  }

  void handleError(String errorText, dynamic error) {
    print('-' * 35);
    print(errorText);
    print(error);
    if (error is Error) {
      print(error.stackTrace);
    }
  }

  void _handleSocketServerMessage(
      Method ident, String message, Map<String, dynamic> data) {
    if (methodsInProcess.contains(ident)) {
      print(
          'Received Socket Data------------------------------------------------------------------------------');
      // ColoredPrint.printColored(ident?.toString(), PrintColors.Red);
      print(ident);
      print('$message   ');
      print(data);
      print(
          '-------------------------------------------------------------------------------------------------');
    }
  }

  void _printRawData(dynamic data) {
    // if (data['ident'] != 'friend-online' && data['valid'] == true) {
    if (methodsInProcess.contains(Method.values[data['ident']])) {
      print(
          '-------------------------------------------------------------------------------------------------');
      // ColoredPrint.printColored(data['ident']?.toString(), PrintColors.Green);
      print(data['ident']);
      print(data['message']);
      print(data);
      print(
          '-------------------------------------------------------------------------------------------------');
    }
  }
}
