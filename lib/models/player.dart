import 'package:flutter/foundation.dart';
import '../models/enums.dart';

import './user.dart';

class Player {
  PlayerColor playerColor;
  User user;
  int remainingTime; // secs
  bool isOnline;
  bool isReady;
  
  

  Player({this.playerColor,this.isReady = true, this.user, this.remainingTime, this.isOnline});
}
