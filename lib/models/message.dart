

class Message{
  final String text;
  final String userName;
  final String userId;
  final DateTime timeStamp;
  final bool isYours;

  Message({this.text, this.timeStamp, this.userId, this.userName, this.isYours});
}