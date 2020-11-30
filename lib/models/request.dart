import 'package:flutter/material.dart';

import '../models/enums.dart';

class Request {
  RequestType requestType;
  Map<ResponseRole, PlayerColor> playerResponse;
  int moveIndex;

  Request({
    this.requestType,
    this.playerResponse,
    this.moveIndex,
  });
}
