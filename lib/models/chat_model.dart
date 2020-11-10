
import '../models/user.dart';
import '../models/message.dart';

class Chat {
  String id;
  User you;
  List<User> chatPartner;
  List<Message> messages;

get chatName{
  if(chatPartner.length == 2){
    return chatPartner.firstWhere((e) => e.id != you.id).userName;
  }
  return chatPartner[0].userName + 's Game chat';
}

  Chat({this.chatPartner, this.messages, this.you, this.id});
}