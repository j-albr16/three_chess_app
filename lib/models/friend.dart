import './user.dart';

class Friend{
  bool isPlaying;
  bool isOnline;
  bool isAfk;
  User user; 
  String chatId;

  Friend({
    this.chatId,
    this.isPlaying,
    this.isAfk,
    this.isOnline,
    this.user,
  });
}