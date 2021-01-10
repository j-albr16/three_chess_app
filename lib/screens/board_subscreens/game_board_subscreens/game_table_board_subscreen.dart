import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/providers/scroll_provider.dart';
import 'file:///G:/Programming/Github/three_chess_app_new_era/lib/screens/board_subscreens/game_board_subscreens/game_board_board_subscreen.dart';
import 'file:///G:/Programming/Github/three_chess_app_new_era/lib/screens/board_subscreens/game_board_subscreens/game_chat_board_subscreen.dart';
import 'package:three_chess/widgets/move_table.dart';

import '../../../models/chess_move.dart';
import '../../../widgets/board_boarding_widgets.dart';
import '../../../providers/game_provider.dart';
import '../../../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';
import '../../../providers/game_provider.dart';

class TableBoardSubScreen extends StatefulWidget {
  final BoardState boardStateListen;
  final ScrollController controller;
  final double height;
  final double iconBarFraction;
  final Map<RequestType, Function> onRequest;
  final bool isLocal;

  TableBoardSubScreen({this.boardStateListen, this.controller, this.height, this.iconBarFraction, this.onRequest, this.isLocal});
  @override
  _TableBoardSubScreenState createState() => _TableBoardSubScreenState();
}

class _TableBoardSubScreenState extends State<TableBoardSubScreen> {

  RequestType confirmation;
  List<RequestType> pendingActions = [];

GameProvider gameProvider;

@override
void initState() { 
  super.initState();
  Future.delayed(Duration.zero).then((_) => gameProvider = Provider.of<GameProvider>(context, listen : false));
}



  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx)
    {
      return GameTable(
        iconBarFraction: widget.iconBarFraction,
        boardStateListen: widget.boardStateListen,
        size: Size(screenWidth * 0.8, widget.height),
        controller: widget.controller,
        confirmation: confirmation,
        onConfirmation: (requestType) {
          setState(() {
            confirmation = requestType;
          });
        },
        onConfirmationCancel: () => setState(() => confirmation = null),
        onRequest: (requestType) {
          print("i demand a $requestType");
          setState(() {
            if(!widget.isLocal) {
              pendingActions.add(requestType);
            }
            confirmation = null;
            widget.onRequest[requestType]();
          });
        },
        onRequestCancel: (cancelPending) {
          print("I demand to stop the vote!");
          setState(() {
            pendingActions.remove(cancelPending);
          });
        },
        pendingActions: widget.isLocal ? [] : pendingActions,
      );
    });
  }
  }
   

