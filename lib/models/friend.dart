import './user.dart';

class Friend{
  bool isPlaying;
  bool isOnline;
  bool isAfk;
  User user; 
  String chatId;
  int newMessages;

  Friend({
    this.newMessages,
    this.chatId,
    this.isPlaying,
    this.isAfk,
    this.isOnline,
    this.user,
  });
}