import 'package:flutter/foundation.dart';
import '../models/enums.dart';

import './user.dart';

class Player {
  PlayerColor playerColor;
  User user;
  DateTime remainingTime;


  Player({this.playerColor, this.user, this.remainingTime});
}
