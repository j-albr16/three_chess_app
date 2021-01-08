import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/board/Tiles.dart';
import 'package:three_chess/data/board_data.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/models/player.dart';
import 'package:three_chess/models/request.dart';
import 'package:three_chess/providers/board_state_manager.dart';
import 'package:three_chess/screens/board_subscreens/game_board_screen.dart';
import 'package:three_chess/widgets/board_state_selector.dart';
import '../models/enums.dart';
import 'package:three_chess/providers/scroll_provider.dart';
import 'package:three_chess/widgets/accept_table_action.dart';
import 'package:three_chess/widgets/move_table.dart';

import '../models/chess_move.dart';
import '../widgets/board_boarding_widgets.dart';
import '../providers/game_provider.dart';
import '../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';
import 'dart:math';

import 'board_subscreens/game_board_subscreens/game_board_board_subscreen.dart';
import 'board_subscreens/game_board_subscreens/game_chat_board_subscreen.dart';
import 'board_subscreens/game_board_subscreens/game_table_board_subscreen.dart';


class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  GameType chosenScreen;
  ScrollController controller;
  int indexOfOnlineGameSelection = 0;

  @override
  initState(){
    super.initState();
  }

  Function _chooseScreen(context){
    return (GameType newGameType) {
      setState(() {
        Provider.of<BoardStateManager>(context, listen: false).gameType = newGameType;
      });
    };
  }

  _buildSelectedScreen(){
    return GameBoardScreen();
  }

  _buildChooseScreen(){
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
          GameProvider gameProvider = Provider.of<GameProvider>(context);
          return BoardStateSelector(
            controller: controller,
            width: screenWidth,
            height: screenHeight,
            currentGames: gameProvider.game != null ? [gameProvider.game] : [],
            gameTypeCall: _chooseScreen(context),
            selectedOnlineGame: indexOfOnlineGameSelection,
            selectOnlineGameCall: (newIndex) => setState(() => indexOfOnlineGameSelection = newIndex),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provider.of<BoardStateManager>(context).gameType == null ? _buildChooseScreen() : _buildSelectedScreen(),
    );
  }
}

