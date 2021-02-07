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
      friendIsAfkCallback: (userId) => _handleFriendIsAfk(userId),
      friendIsOnlineCallback: (userId) => _handleFriendIsOnline(userId),
      friendIsNotPlayingCallback: (userId) => _handleFriendIsNotPlaying(userId),
      friendIsPlayingCallback: (userId) => _handleFriendIsPlaying(userId),
      gameInvitationCallback: (gameData) => _handleGameInvitation(gameData),
    );
  }

  Future<void> fetchFriends() async {
    try {
      _friends = [];
      _pendingFriends = [];
      final Map<String, dynamic> data = await _serverProvider.fetchFriends();
      // destinguish between friends whoare accepted and those who are not
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
    String message = 'An Erro Ocured. Sry';
    try {
      final Map<String, dynamic> data =
          await _serverProvider.fetchInvitations();
      if (data['games'] == null) {
        message = 'No Invitations';
      } else {
        data['games'].forEach((gameData) {
          final playerData = data['player']
              ?.where((player) => player['gameId'] == gameData['_id']);
          print(playerData);
          final userData =
              data['user']?.where((user) => user['gameId'] == gameData['_id']);
          print(userData);
          _invitations.add(GameConversion.rebaseLobbyGame(
              gameData: gameData, playerData: playerData, userData: userData));
          GameConversion.printEverything(null, null, _invitations);
          notifyListeners();
        });
      }
    } catch (error) {
      _serverProvider.handleError('Error while fetching Invitations', error);
    }
    ;
  }

  Future<String> makeFriendRequest(String userName) async {
    String message = 'An Error Occured. Sorry';
    try {
      final Map<String, dynamic> data =
          await _serverProvider.sendFriendRequest(userName);
      // add _frinds =>  but until acceptance not accepted
      notifyListeners();
      if (data['valid']) {
        message = data['message'];
      }
    } catch (error) {
      _serverProvider.handleError('Erorr while Making Friend Request', error);
    } finally {
      return message;
    }
  }

  Future<String> acceptFriend(String userId) async {
    String message = 'An Error Occured. Sorry';
    try {
      final Map<String, dynamic> data =
          await _serverProvider.acceptFriend(userId);
      _friends.add(FriendConversion.rebaseOneFriend(data['friend'],
          chatId: data['chatId']));
      _pendingFriends
          .removeWhere((pFriend) => pFriend.user.id == data['friend']['_id']);
      if (data['valid']) {
        message = data['message'];
      }
    } catch (error) {
      _serverProvider.handleError('Error whle Accepting Friend', error);
    } finally {
      notifyListeners();
      return message;
    }
  }

  Future<String> declineFriend(String userId) async {
    String message = 'An Error Occured. Sorry';
    try {
      final Map<String, dynamic> data =
          await _serverProvider.friendDecline(userId);
      if (data['valid']) {
        _pendingFriends
            .removeWhere((friend) => friend.user.id == data['userId']);
      }
      if (data['valid']) {
        message = data['message'];
      }
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While declining Friend', error);
    } finally {
      return message;
    }
  }

  Future<String> removeFriend(String userId) async {
    String message = 'An Error Occured. Sorry';
    try {
      final Map<String, dynamic> data =
          await _serverProvider.friendRemove(userId);
      if (data['valid']) {
        _friends.removeWhere((friend) => friend.user.id == userId);
      }
      if (data['valid']) {
        message = data['message'];
      }
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While Removing Friend', error);
    } finally {
      return message;
    }
  }

  Future<void> declineInvitation({String gameId, bool all = false}) async {
    String message = 'Could decline Invitation(s)';
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
    print(message);
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

  void _handleFriendIsPlaying(String userId) {
    Friend friend = _friends.firstWhere((friend) => friend.user.id == userId,
        orElse: () => null);
    friend?.isPlaying = true;
    notifyListeners();
  }

  void _handleFriendIsNotPlaying(String userId) {
    Friend friend = _friends.firstWhere((friend) => friend.user.id == userId,
        orElse: () => null);
    friend?.isPlaying = false;
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

  void _handleFriendIsOnline(String userId) {
    // print('Handling Friend is Online');
    Friend friend = _friends.firstWhere((friend) => friend.user.id == userId,
        orElse: () => null);
    if (friend != null) {
      friend.isOnline = true;
    }
    notifyListeners();
  }

  void _handleFriendIsAfk(String userId) {
    print('Handle Friend is AFK');
    Friend friend = _friends.firstWhere((friend) => friend.user.id == userId,
        orElse: () => null);
    friend.isOnline = false;
    notifyListeners();
  }
}
