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

import '../models/chess_move.dart';
import '../widgets/board_boarding_widgets.dart';
import '../providers/game_provider.dart';
import '../widgets/three_chess_board.dart';
import 'package:relative_scale/relative_scale.dart';
import 'dart:math';

import 'board_subscreens/board_board_subscreen.dart';
import 'board_subscreens/chat_board_subscreen.dart';
import 'board_subscreens/table_board_subscreen.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  ThreeChessBoard threeChessBoard;
  BoardState boardState;
  bool didload = false;
  ScrollController controller;
  double iconBarFractionOfTable = 0.1;
  double gameTableHeightFraction = 0.7;
  final int _subSectionnCount  = 4;

  @override
  void initState() {
    boardState = BoardState();
    controller = ScrollController();

    // threeChessBoard = ThreeChessBoard(
    //     boardState: BoardState.newGame(), height: 1000, width: 1000);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double sectionHeight({@required int section, @required double screenHeight}){
    assert(section <= _subSectionnCount); //screen section is 1 more then subScreens because TableSubScreen has 2 sections
    if(section == 0 || section == 1){
      return screenHeight;
    }
    else if(section == 2){
      return  gameTableHeightFraction * screenHeight * iconBarFractionOfTable;
    }
    //if section == 3
    return(gameTableHeightFraction * screenHeight * (1/iconBarFractionOfTable));
  }

  List<double> _sectionStarts(double screenHeight){
    return [
      0,
      (screenHeight * gameTableHeightFraction * iconBarFractionOfTable) + 30, // (20 max dot size, 5 +5 edgeInsets)30 should be the grey bar at the bottom
      (screenHeight*gameTableHeightFraction)
    ];
  }

  List<Widget> _subScreens;

  _itemBuilder(BuildContext context, int index){
    return _subScreens[index];
  }

  _goToNearestSubScreen(double screenHeight){
    controller.animateTo(_sectionStarts(screenHeight)[_nearestIndexOf(controller.offset, _sectionStarts(screenHeight))],
    curve: Curves.bounceIn, duration: Duration(milliseconds: 200));
      //curve: Curves.bounceIn, duration: Duration(milliseconds: 200
  } //_sectionStarts(screenHeight)[_nearestIndexOf(controller.offset, _sectionStarts(screenHeight))]
  
  int _nearestIndexOf(double input, List<double> list){
    assert (list != null && list.isNotEmpty);

    double difference = (list[0] - input).abs();
    int index = 0;
   //print("input: $input");
    for( int i = 1; i < list.length;i++){
      if((list[i] - input).abs() < difference){
        difference = (list[i]-input).abs();
        index = i;
      }
    }
    //print("index: $index");
    return index;
  }

  bool _onEndNotification(ScrollEndNotification scrollNotification, double screenHeight){
    if(scrollNotification is ScrollEndNotification){
      Future.delayed(Duration.zero).then((_) =>
          _goToNearestSubScreen(screenHeight));
      print("i tried, this scroll just ended");
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {

    bool isLocked = Provider.of<ScrollProvider>(context).isLocked;
    switchIsLocked(){
      Provider.of<ScrollProvider>(context, listen: false).isLocked = !isLocked;
    }

    double unusableHeight = MediaQuery.of(context).padding.top + kToolbarHeight;


    return RelativeBuilder(

        builder: (context, screenHeight, screenWidth, sy, sx)
      {
        double usableHeight = screenHeight - unusableHeight;
        _subScreens = [
          ChatBoardSubScreen(
              height: gameTableHeightFraction * screenHeight,
              iconBarFraction: iconBarFractionOfTable),
          BoardBoardSubScreen(
            boardState: boardState,),
          TableBoardSubScreen(
            boardState: boardState,
            controller: ScrollController(),
            height: gameTableHeightFraction * screenHeight,),
        ];

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
              icon: Icon(!isLocked ? Icons.lock_open : Icons.lock_clock),
              onPressed: () => switchIsLocked(),),
            ],
          ),
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (scrollNotification) => _onEndNotification(scrollNotification, screenHeight),
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _subScreens,
              ),
            ),
          ),
        );},
    );
        }
}

