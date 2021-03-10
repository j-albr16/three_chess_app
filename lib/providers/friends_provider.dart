import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:three_chess/models/enums.dart';

import '../models/friend.dart';
import '../models/online_game.dart';
import '../providers/server_provider.dart';
import '../conversion/game_conversion.dart';
import '../providers/popup_provider.dart';
import '../providers/chat_provider.dart';
import '../conversion/friend_conversion.dart';

typedef void PlayerStatusListener(
    String userId, bool isOnline, bool isActive, bool isPlaying);

class FriendsProvider with ChangeNotifier {
  List<Friend> _friends = [];
  List<Friend> _pendingFriends = [];

  ServerProvider _serverProvider;
  ChatProvider _chatProvider;
  bool _didSubscribe = false;
  PopupProvider _popUpProvider;

  List<Friend> get friends {
    return [..._friends];
  }

  List<Friend> get pendingFriends {
    return [..._pendingFriends];
  }

  List<OnlineGame> _invitations = [];

  List<OnlineGame> get invitations {
    return [..._invitations];
  }

  void update(
      {friends,
      ServerProvider serverProvider,
      ChatProvider chatProvider,
      PopupProvider popUpProvider}) {
    print('Update');
    _friends = friends;
    _popUpProvider = popUpProvider;
    _serverProvider = serverProvider;
    _chatProvider = chatProvider;
    if (!_didSubscribe) {
      try {
        subscribeToAuthUserChannel();
        _didSubscribe = true;
      } catch (error) {
        print('Failed to Connect TO Socekt');
      }
    }
    notifyListeners();
  }

  void subscribeToAuthUserChannel() {
    print('Did Subscribe to Auth User Channel');
    _chatProvider.subscribeToAuthUserChannel(
      friendRemovedCallback: (userId, message) =>
          _handleFriendRemove(userId, message),
      friendDeclinedCallback: (message) => _handleFriendDeclined(message),
      friendAcceptedCallback: (data) =>
          _handleFriendAccepted(data['user'], data['chatId'], data['message']),
      friendRequestCallback: (friendData, message) =>
          _handleFriendRequest(friendData, message),
      increaseNewMessageCounterCallback: (userId) => _handleNewMessage(userId),
      friendStatusUpdateCallback: (userId, isOnline, isActive, isPlaying) =>
          _handleFriendStatusUpdate(userId, isOnline, isActive, isPlaying),
      gameInvitationCallback: (gameData) => _handleGameInvitation(gameData),
    );
  }

  Future<void> fetchFriends() async {
    try {
      _friends = [];
      _pendingFriends = [];
      final Map<String, dynamic> data = await _serverProvider.fetchFriends();
      // distinguish between friends who are accepted and those who are not
      data['friends'].forEach((friend) => _friends
          .add(FriendConversion.matchChatIdAndFriend(friend, data['chats'])));
      data['pendingFriends'].forEach((pendingFriend) =>
          _pendingFriends.add(FriendConversion.rebaseOneFriend(pendingFriend)));
      print('YOu have ${_friends.length} Friends');
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('error While fetching Friends', error);
    }
  }

  Future<void> fetchInvitations() async {
    print('Fetching Invitations');
    try {
      final Map<String, dynamic> data =
          await _serverProvider.fetchInvitations();

      data['games'].forEach((gameData) {
        final playerData = data['player']
            ?.where((player) => player['gameId'] == gameData['_id']);
        print(playerData);
        final userData =
            data['user']?.where((user) => user['gameId'] == gameData['_id']);
        print(userData);
        _invitations.add(GameConversion.rebaseLobbyGame(
            gameData: gameData, playerData: playerData, userData: userData));
        notifyListeners();
      });
    } catch (error) {
      _serverProvider.handleError('Error while fetching Invitations', error);
    }
    ;
  }

  Future<void> makeFriendRequest(String userName) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.sendFriendRequest(userName);
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error while Making Friend Request', error);
    }
  }

  Future<void> acceptFriend(String userId) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.acceptFriend(userId);
      _friends.add(FriendConversion.rebaseOneFriend(data['friend'],
          chatId: data['chatId']));
      _pendingFriends
          .removeWhere((pFriend) => pFriend.user.id == data['friend']['_id']);
    } catch (error) {
      _serverProvider.handleError('Error while Accepting Friend', error);
    }
  }

  Future<void> declineFriend(String userId) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.friendDecline(userId);
      if (data['valid']) {
        _pendingFriends
            .removeWhere((friend) => friend.user.id == data['userId']);
      }
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While declining Friend', error);
    }
  }

  Future<void> removeFriend(String userId) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.friendRemove(userId);
      if (data['valid']) {
        _friends.removeWhere((friend) => friend.user.id == userId);
      }
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While Removing Friend', error);
    }
  }

  Future<void> declineInvitation({String gameId, bool all = false}) async {
    String message = 'Could not  decline Invitation(s)';
    try {
      final bool didDecline =
          await _serverProvider.declineInvitation(gameId, all);
      if (didDecline) {
        _invitations
            .removeWhere((invitation) => gameId.contains(invitation.id));
        message = 'Invitation was declined';
      }
    } catch (error) {
      _serverProvider.handleError('Error While Declining Invitation', error);
    } finally {
      _popUpProvider.makePopUp[PopUpType.SnackBar](message);
    }
  }

  void _handleGameInvitation(Map<String, dynamic> gameData) {
    print('Handling OnlineGame Invitation');
    OnlineGame newGame = GameConversion.rebaseOnlineGame(
        gameData: gameData,
        playerData: gameData['player'],
        userData: gameData['user']);
    _invitations.add(newGame);
    _popUpProvider.makePopUp[PopUpType.Invitation](newGame);
    notifyListeners();
  }

  void _handleFriendRequest(Map<String, dynamic> friendData, String message) {
    // add new Friend to _friends
    _pendingFriends.add(FriendConversion.rebaseOneFriend(friendData));
    _popUpProvider.makePopUp[PopUpType.SnackBar](message);
    notifyListeners();
  }

  void _handleFriendAccepted(
      Map<String, dynamic> userData, String chatId, String message) {
    print(message);
    _friends.add(FriendConversion.rebaseOneFriend(userData, chatId: chatId));
    _popUpProvider.makePopUp[PopUpType.SnackBar](message);
    notifyListeners();
  }

  void _handleFriendDeclined(String message) {
    print(message);
    _popUpProvider.makePopUp[PopUpType.SnackBar](message);
    notifyListeners();
  }

  void _handleFriendRemove(String userId, String message) {
    _friends.removeWhere((friend) => friend.user.id == userId);
    print(message);
    _popUpProvider.makePopUp[PopUpType.SnackBar](message);
    notifyListeners();
  }

  void resetNewMessages(String chatId) {
    Friend friend = _friends.firstWhere((friend) => friend.chatId == chatId,
        orElse: () => null);
    if (friend != null) {
      friend.newMessages = 0;
      notifyListeners();
    }
  }

  void _handleNewMessage(String userId) {
    Friend friend = _friends.firstWhere((friend) => friend.user.id == userId,
        orElse: () => null);
    if (friend != null) {
      friend.newMessages++;
      notifyListeners();
    }
  }

  void _handleFriendStatusUpdate(
      String userId, bool isOnline, bool isActive, bool isPlaying) {
    Friend friend =
        _friends.firstWhere((f) => f.user.id == userId, orElse: () => null);
    if (friend != null) {
      friend.isOnline = isOnline;
      friend.isActive = isActive;
      friend.isPlaying = isPlaying;
      notifyListeners();
    }
    notifyPlayerStatusListener(userId, isOnline, isActive, isPlaying);
  }

  Map<String, PlayerStatusListener> _playerStatusListener = {};

  void notifyPlayerStatusListener(
      String userId, bool isOnline, bool isActive, bool isPlaying) {
    _playerStatusListener.forEach(
        (gameId, listener) => listener(userId, isOnline, isActive, isPlaying));
  }

  void addPlayerStatusListener(
      String gameId, PlayerStatusListener playerStatusListener) {
    _playerStatusListener[gameId] = playerStatusListener;
  }

  void removePlayerStatusListener(String gameId) {
    _playerStatusListener.remove(gameId);
  }
}
