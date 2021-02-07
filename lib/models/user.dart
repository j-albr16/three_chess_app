
class User {
  String id;
  String email;
  String userName;
  int score;
  List<String> friendIds;

  User({this.userName, this.friendIds, this.email, this.id, this.score});
}
