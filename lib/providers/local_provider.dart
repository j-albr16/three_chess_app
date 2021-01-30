import 'package:flutter/foundation.dart';

import '../models/local_game.dart';


class LocalProvider with ChangeNotifier {
  List<LocalGame> localGames = [];
  List<LocalGame> analyzeGames = [];
}