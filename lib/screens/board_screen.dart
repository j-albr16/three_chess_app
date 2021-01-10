import 'package:relative_scale/relative_scale.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/enums.dart';
import '../screens/board_subscreens/game_board_screen.dart';
import '../widgets/board_state_selector.dart';
import '../models/enums.dart';

import '../providers/game_provider.dart';

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

  _choseScreen(GameType gameType){

  }

  _buildSelectedScreen(){
    return GameBoardScreen(gameType: chosenScreen); // MAYBE manage gameType diffrently
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
            gameTypeCall: _choseScreen,
            selectedOnlineGame: indexOfOnlineGameSelection,
            selectOnlineGameCall: (newIndex) => setState(() => indexOfOnlineGameSelection = newIndex),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: chosenScreen == null ? _buildChooseScreen() : _buildSelectedScreen(),
    );
  }
}

