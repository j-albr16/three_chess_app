import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/providers/scroll_provider.dart';
import 'package:three_chess/widgets/move_table.dart';

import '../../../models/chess_move.dart';
import '../../../widgets/board_boarding_widgets.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';

class ChatBoardSubScreen extends StatelessWidget {
  double height;
  double iconBarFraction;

  ChatBoardSubScreen({this.height});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
