import './user.dart';

class Friend{
  bool isPlaying;
  bool isOnline;
  User user; 
  String chatId;
  int newMessages;

  Friend({
    this.newMessages = 0,
    this.chatId,
    this.isPlaying = false,
    this.isOnline = false,
    this.user,
  });
}