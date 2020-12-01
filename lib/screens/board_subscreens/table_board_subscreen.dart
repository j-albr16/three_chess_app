import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/providers/scroll_provider.dart';
import 'package:three_chess/screens/board_subscreens/board_board_subscreen.dart';
import 'package:three_chess/screens/board_subscreens/chat_board_subscreen.dart';
import 'package:three_chess/widgets/move_table.dart';

import '../../models/chess_move.dart';
import '../../widgets/board_boarding_widgets.dart';
import '../../providers/game_provider.dart';
import '../../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';

class TableBoardSubScreen extends StatefulWidget {
  final BoardState boardState;
  final ScrollController controller;
  double height;

  TableBoardSubScreen({this.boardState, this.controller, this.height});
  @override
  _TableBoardSubScreenState createState() => _TableBoardSubScreenState();
}

class _TableBoardSubScreenState extends State<TableBoardSubScreen> {

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx)
    {
      return GameTable(
        boardState: widget.boardState,
        size: Size(screenWidth * 0.8, widget.height),
        controller: widget.controller,
        confirmation: confirmation,
        onConfirmation: (tableAction) {
          setState(() {
            confirmation = tableAction;
          });
        },
        onConfirmationCancel: () => setState(() => confirmation = null),
        onRequest: (tableAction) {
          print("i demand a $tableAction");
          setState(() {
            pendingActions.add(tableAction);
            confirmation = null;
          });
        },
        onRequestCancel: (cancelPending) {
          print("I demand to stop the vote!");
          setState(() {
            pendingActions.remove(cancelPending);
          });
        },
        pendingActions: pendingActions,
      );
    });
}
TableAction confirmation;
List<TableAction> pendingActions = [];
  }

