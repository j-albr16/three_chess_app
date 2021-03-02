import 'package:flutter/foundation.dart';
import '../models/enums.dart';

import './user.dart';

class Player {
  PlayerColor playerColor;
  User user;
  int remainingTime; // secs
  bool isOnline;
  bool isActive;
  bool isReady;
  bool isPlaying;

  Player(
      {this.playerColor,
        this.isPlaying,
      this.isReady = true,
      this.isActive = true,
      this.user,
      this.remainingTime,
      this.isOnline});

  bool get isAfk {
    return isOnline && !isActive;
  }
}
