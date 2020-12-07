import 'package:provider/provider.dart';
import 'package:three_chess/conversion/chat_conversion.dart';
import '../models/friend.dart';
import 'package:flutter/foundation.dart';
import '../models/game.dart';
import '../providers/server_provider.dart';
import '../models/user.dart';
import '../conversion/game_conversion.dart';
import '../providers/chat_provider.dart';
import '../conversion/friend_conversion.dart';

class FriendsProvider with ChangeNotifier {
  List<Friend> _friends = [];
  List<Friend> _pendingFriends = [];

  ServerProvider _serverProvider;
  ChatProvider _chatProvider;
  bool _didSubscibe = false;

  List<Friend> get friends {
    return [..._friends];
  }

  List<Friend> get pendingFriends {
    return [..._pendingFriends];
  }
  List<Game> _invitations = [];

  List<Game> get invitations {
    return [..._invitations];
  }



  void update({friends, serverProvider, chatProvider}) {
    print('Update');
    _friends = friends;
    _serverProvider = serverProvider;
    _chatProvider = chatProvider;
    if (!_didSubscibe) {
      subscribeToAuthUserChannel();
      _didSubscibe = true;
    }
    notifyListeners();
  }

  void subscribeToAuthUserChannel() {
    print('Did Subscribe to Auth User Channel');
    _chatProvider.subsribeToAuthUserChannel(
      friendRemovedCallback: (userId) => _handleFriendRemove(userId),
      friendDeclinedCallback: (userId) => _handleFriendDeclined(userId),
      friendAcceptedCallback: (userId) => _handleFriendAccepted(userId),
      friendRequestCallback: (friendData, chatId) =>
          _handleFriendRequest(friendData, chatId),
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
      data['friends'].forEach((friend) =>
          _friends.add(FriendConversion.matchChatIdAndFriend(friend, data['chats'])));
      data['pendingFriends'].forEach((pendingFriend) => _pendingFriends
          .add(FriendConversion.matchChatIdAndFriend(pendingFriend, data['chats'])));
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('error While fetching Friends', error);
    }
  }
Future<void> fetchInvitations() async {
    try{
      final Map<String, dynamic> data = await _serverProvider.fetchInvitations();
      data['games'].forEach((gameData) {
        final playerData = data['player'].firstWhere((player) => player['gameId'] == gameData['_id'], orElse : () => null);
        final userData = data['user'].firstWhere((user) => user['gameId'] == gameData['_id'], orElse : ()  => null);
        _invitations.add(GameConversion.rebaseLobbyGame(gameData: gameData, playerData: playerData, userData: userData));
        GameConversion.printEverything(null, null, _invitations);
        notifyListeners();
      });
    }catch(error){
      _serverProvider.handleError('Error while fetching Invitations', error);
    };
  }

  Future<void> makeFriendRequest(String userName) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.sendFriendRequest(userName);
      // add _frinds =>  but until acceptance not accepted
      _pendingFriends.add(FriendConversion.rebaseOneFriend(data['friend'], data['chatId']));
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Erorr while Making Friend Request', error);
    }
  }

  Future<void> acceptFriend(String userId) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.acceptFriend(userId);
      if (data['valid']) {
        int friendIndex =
            _pendingFriends.indexWhere((friend) => friend.user.id == userId);
        _friends.add(_pendingFriends[friendIndex]);
        _pendingFriends.removeAt(friendIndex);
        return notifyListeners();
      }
      throw ('Accept Request was not successfull');
    } catch (error) {
      _serverProvider.handleError('Error whle Accepting Friend', error);
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

  void _handleGameInvitation(Map<String, dynamic> gameData){
    _invitations.add(GameConversion.rebaseWholeGame(gameData));
    notifyListeners();
  }

  void _handleFriendRequest(Map<String, dynamic> friendData, String chatId) {
    // add new Friend to _friends
    _pendingFriends.add(FriendConversion.rebaseOneFriend(friendData, chatId));
    notifyListeners();
  }

  void _handleFriendAccepted(String userId) {
    int friendIndex =
        _pendingFriends.indexWhere((friend) => friend.user.id == userId);
    _friends.add(_pendingFriends[friendIndex]);
    _pendingFriends.removeAt(friendIndex);
    notifyListeners();
  }

  void _handleFriendDeclined(String userId) {
    _pendingFriends.removeWhere((friend) => friend.user.id == userId);
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
    friend.isOnline = true;
    notifyListeners();
  }

  void _handleFriendIsAfk(String userId) {
    print('Handle Friend is AFK');
    Friend friend = _friends.firstWhere((friend) => friend.user.id == userId,
        orElse: () => null);
    friend.isOnline = false;
    notifyListeners();
  }

  void _handleFriendRemove(String userId) {
    _friends.removeWhere((friend) => friend.user.id == userId);
    notifyListeners();
  }

}