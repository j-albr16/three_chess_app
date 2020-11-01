import 'package:flutter/foundation.dart';
import '../models/enums.dart';

import './user.dart';

class Player {
  String id;
  PlayerColor playerColor;
  User user;
  int remainingTime; // secs
  

  Player({this.playerColor, this.user, this.remainingTime, this.id});
}
