import 'package:provider/provider.dart';
import '../models/friend.dart';
import 'package:flutter/foundation.dart';
import '../providers/server_provider.dart';
import '../models/user.dart';
import '../providers/chat_provider.dart';

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

  void update({friends, serverProvider, chatProvider}) {
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
    );
  }

  Future<void> fetchFriends() async {
    try {
      _friends = [];
      _pendingFriends = [];
      final Map<String, dynamic> data = await _serverProvider.fetchFriends();
      // destinguish between friends whoare accepted and those who are not
      data['friends'].forEach((friend) =>
          _friends.add(_matchChatIdAndFriend(friend, data['chats'])));
      data['pendingFriends'].forEach((pendingFriend) => _pendingFriends
          .add(_matchChatIdAndFriend(pendingFriend, data['chats'])));
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('error While fetching Friends', error);
    }
  }

  Future<void> makeFriendRequest(String userName) async {
    try {
      final Map<String, dynamic> data =
          await _serverProvider.sendFriendRequest(userName);
      // add _frinds =>  but until acceptance not accepted
      _pendingFriends.add(_rebaseOneFriend(data['friend'], data['chatId']));
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
      _serverProvider.friendDecline(userId);
      _pendingFriends.removeWhere((friend) => friend.user.id == userId);
      notifyListeners();
    } catch (error) {
      _serverProvider.handleError('Error While declining Friend', error);
    }
  }

  Future<void> removeFriend(String userId) async {
    try{
      final Map<String, dynamic> data = await _serverProvider.friendRemove(userId);
      _friends.removeWhere((friend) => friend.user.id == userId);
      notifyListeners();
    }catch(error){
      _serverProvider.handleError('Error While Removing Friend', error);
    }

  }

  void _handleFriendRequest(Map<String, dynamic> friendData, String chatId) {
    // add new Friend to _friends
    _pendingFriends.add(_rebaseOneFriend(friendData, chatId));
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

  void _handleNewMessage(String userId) {
    _friends.forEach((friend) {
      if (friend.user.id == userId) {
        friend.newMessages++;
      }
    });
    notifyListeners();
  }
  void _handleFriendRemove(String userId){
    _friends.removeWhere((friend) => friend.user.id == userId);
    notifyListeners();
  }

  Friend _matchChatIdAndFriend(Map<String, dynamic> friendData, chatData) {
    final chat = chatData.firstWhere(
        (c) => c['user'].contains(friendData['_id']) as bool,
        orElse: () => throw ('Chat and Friend Dont Match'));
    return _rebaseOneFriend(friendData, chat['_id']);
  }

  Friend _rebaseOneFriend(Map<String, dynamic> friendData, String chatId) {
    return new Friend(
      chatId: chatId,
      user: new User(
        id: friendData['_id'],
        score: friendData['score'],
        userName: friendData['userName'],
      ),
    );
  }
}
