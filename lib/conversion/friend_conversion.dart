import '../models/user.dart';
import '../models/friend.dart';

class FriendConversion {
  static Friend matchChatIdAndFriend(
      Map<String, dynamic> friendData, chatData) {
    final chat = chatData.firstWhere(
        (c) => c['user'].contains(friendData['_id']) as bool,
        orElse: () => throw ('Chat and Friend do not Match'));
    return rebaseOneFriend(friendData, chatId: chat['_id']);
  }

  static Friend rebaseOneFriend(Map<String, dynamic> friendData,
      {String chatId = 'not given'}) {
    return new Friend(
      isActive: friendData['status']['isActive'] ?? true,
      isPlaying: friendData['status']['isPlaying'] ?? true,
      isOnline: friendData['status']['isOnline'] ?? true,
      chatId: chatId,
      user: new User(
        id: friendData['_id'],
        score: friendData['score'],
        userName: friendData['userName'],
      ),
    );
  }
}
