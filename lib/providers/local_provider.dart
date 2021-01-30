import 'package:flutter/foundation.dart';

import '../models/game.dart';


class LocalProvider with ChangeNotifier {
  List<Game> localGames = [];
  List<Game> analyzeGames = [];
}