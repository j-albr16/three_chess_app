import '../models/enums.dart';

class Message {
  final String text;
  final String userName;
  final String userId;
  final DateTime timeStamp;
  final MessageOwner owner;

  Message({
    this.text,
    this.owner,
    this.timeStamp,
    this.userId,
    this.userName,
  });
}
