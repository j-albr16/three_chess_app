
import '../models/game.dart';
import '../models/player.dart';
import '../models/request.dart';
import '../models/user.dart';
import '../models/friend.dart';


class FriendConversion {
 static Friend matchChatIdAndFriend(Map<String, dynamic> friendData, chatData) {
    final chat = chatData.firstWhere(
        (c) => c['user'].contains(friendData['_id']) as bool,
        orElse: () => throw ('Chat and Friend Dont Match'));
    return rebaseOneFriend(friendData, chat['_id']);
  }

static  Friend rebaseOneFriend(Map<String, dynamic> friendData, String chatId) {
    bool isPlaying = friendData['gameId'] != null;
    return new Friend(
      isPlaying: isPlaying,
      isOnline: friendData['isOnline'],
      chatId: chatId,
      user: new User(
        id: friendData['_id'],
        score: friendData['score'],
        userName: friendData['userName'],
      ),
    );
  }
}