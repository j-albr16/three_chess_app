
import '../models/enums.dart';
import '../models/message.dart';
import '../models/chat_model.dart';
import '../models/user.dart';


class ChatConversion{

 static convertChat(Map<String, dynamic> chatData, userId) {
    //converting icoming mesages and sort them into existing classes...
    // for more information look at data models in threestatic chess_app_node repo
    List<Message> messages = [];
    List<User> users = [];
    chatData['user'].forEach((userData) {
      users.add(rebaseOneUser(userData));
    });

    chatData['chat']['messages'].forEach((messageData) {
      final User user = users.firstWhere(
          (user) => user.id == messageData['userId'],
          orElse: () => null);
      messages.add(rebaseOneMessage(messageData, userId,userName: user?.userName));
    });
    return new Chat(
      user: users,
      id: chatData['chat']['_id'],
      messages: messages,
    );
  }

  static Message rebaseOneMessage(Map<String, dynamic> messageData, userId,
      {String userName}) {
    MessageOwner owner = MessageOwner.Mate;
    if (messageData['userId'] == 'server') {
      owner = MessageOwner.Server;
    } else if (messageData['userId'] == userId) {
      owner = MessageOwner.You;
    }
    return new Message(
      owner: owner,
      text: messageData['text'],
      timeStamp: DateTime.parse(messageData['date']),
      userId: messageData['userId'],
      userName: userName ?? messageData['userName'],
    );
  }

 static User rebaseOneUser(Map<String, dynamic> userData) {
    return new User(
      id: userData['_id'],
      score: userData['score'],
      userName: userData['userName'],
    );
  }

static void printWholeChat(Chat _chat) {
  if (_chat != null) {
    int playerIndex = 0;
    int messagesIndex = 0;
    print('===============================================');
    print('PRINT CHAT ------------------------------------');
    print('id:         ' + _chat?.id ?? 'null');
    print('user:------------------------------------');
    _chat?.user?.forEach((e) {
      print('player ${playerIndex + 1}-----------------------');
      print('-> id:         ' + e?.id ?? 'null');
      print('-> userName:   ' + e?.userName ?? 'null');
      print('-> score:      ' + e?.score?.toString() ?? 'null');
      playerIndex++;
    });
    print('messages----------------------------------------');
    _chat?.messages?.forEach((el) {
      print('message ${messagesIndex + 1}--------------------');
      print('-> text:       ' + el?.text ?? 'null');
      print('-> userName:   ' + el?.userName ?? 'null');
      print('-> timeStamp:  ' + el?.timeStamp?.toIso8601String() ?? 'null');
      messagesIndex++;
    });
    print('===============================================');
  }
}

}

