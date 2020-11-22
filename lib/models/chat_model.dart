
import '../models/user.dart';
import '../models/message.dart';

class Chat {
  String id;
  List<User> user;
  List<Message> messages;
  int newMessages;

  Chat({this.user,this.newMessages, this.messages, this.id});

  getChatName(String yourId){
  if(user.length == 2){
    return user.firstWhere((e) => e.id != yourId).userName;
  }
  return user[0].userName + 's Game chat';
}
  }
