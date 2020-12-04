import './user.dart';

class Friend{
  bool isPlaying = false;
  bool isOnline = false;
  User user; 
  String chatId;
  int newMessages;

  Friend({
    this.newMessages,
    this.chatId,
    this.isPlaying,
    this.isOnline,
    this.user,
  });
}