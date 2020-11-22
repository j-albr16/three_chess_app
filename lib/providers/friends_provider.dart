import 'package:provider/provider.dart';
import '../models/friend.dart';
import 'package:flutter/foundation.dart';
import '../providers/server_provider.dart';
import '../models/user.dart';
import '../providers/chat_provider.dart';

class FriendsProvider with ChangeNotifier{

FriendsProvider(){
  subscribeToAuthUserChannel();
}

  List<Friend> _friends = [];
  List<Friend> _pendingFriends = [];

ServerProvider _serverProvider;
ChatProvider _chatProvider;

  List<Friend> get friends {
    return [..._friends];
  }
  List<Friend> get pendingFriends{
    return [..._pendingFriends];
  }

  void update ({friends, serverProvider, chatProvider}){
    _friends = friends;
    notifyListeners();
    _serverProvider = serverProvider;
    _chatProvider = chatProvider;
    notifyListeners();
  }
  
  void subscribeToAuthUserChannel(){
    _chatProvider.subsribeToAuthUserChannel(
      friendDeclinedCallback: (userId) => _handleFriendDeclined(userId),
      friendAcceptedCallback: (userId) => _handleFriendAccepted(userId),
      friendRequestCallback: (friendData, chatId) => _handleFriendRequest(friendData, chatId),
    );
  }

  Future<void> fetchFriends() async {
    try{
      final Map<String, dynamic> data = await _serverProvider.fetchFriends();
      // destinguish between friends whoare accepted and those who are not
      data['friends'].forEach((friend) => _friends.add(_matchChatIdAndFriend(friend, data['chats'])));
      data['pendingFriends'].forEach((pendingFriend) => _pendingFriends.add(_matchChatIdAndFriend(pendingFriend, data['chats'])));
      notifyListeners();
    }catch(error){
      _serverProvider.handleError('error While fetching Friends', error);
    }
  }
  Future<void> makeFriendRequest(String userName) async {
      try{
        final Map<String, dynamic> data = await _serverProvider.sendFriendRequest(userName);
        // add _frinds =>  but until acceptance not accepted
        _pendingFriends.add(_rebaseOneFriend(data['friend'], data['chatId']));
        notifyListeners();
      }catch(error){
        _serverProvider.handleError('Erorr while Making Friend Request', error);
      }
  }
  Future<void> acceptFriend(String userId) async {
    try{
      final Map<String, dynamic> data = await _serverProvider.acceptFriend(userId);
      if(data['valid']){
       int friendIndex =_pendingFriends.indexWhere((friend) => friend.user.id == userId);
       _friends.add(_pendingFriends[friendIndex]);
       _pendingFriends.removeAt(friendIndex);
       notifyListeners();
      }
      throw('Accept Request was not successfull');
    }catch(error){
      _serverProvider.handleError('Error whle Accepting Friend', error);
    }
  }
  Future<void> declineFriend(String userId) async {
    try{
      _serverProvider.friendDecline(userId);
      _pendingFriends.removeWhere((friend) => friend.user.id == userId);
      notifyListeners();
    }catch(error){
      _serverProvider.handleError('Error While declining Friend', error);
    }
  }
  
  void _handleFriendRequest(Map<String, dynamic> friendData, String chatId){
    // add new Friend to _friends
    _pendingFriends.add(_rebaseOneFriend(friendData, chatId));
    notifyListeners();
  }
  void _handleFriendAccepted(String userId){
    int friendIndex =_pendingFriends.indexWhere((friend) => friend.user.id == userId);
    _friends.add(_pendingFriends[friendIndex]);
    _pendingFriends.removeAt(friendIndex);
    notifyListeners();
  }
  void _handleFriendDeclined(String userId){
    _pendingFriends.removeWhere((friend) => friend.user.id == userId);
    notifyListeners();
  }
  Friend _matchChatIdAndFriend(Map<String, dynamic> friendData, List<Map<String, dynamic>> chatData){
    chatData.forEach((chat) { 
    List<String> userIds = chat['user'];
      if(userIds.contains(friendData['_id'])){
        return _rebaseOneFriend(friendData, chat['_id']);
      }
    });
  }

  Friend _rebaseOneFriend(Map<String, dynamic> friendData, String chatId){
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