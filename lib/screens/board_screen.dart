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
  ScrollController controller;
  double iconBarFractionOfTable = 0.1;
  double gameTableHeightFraction = 0.7;
  double chatScreenHeight = 0;
  double voteHeightFraction = 0.1;
  GameProvider gameProvider;
  Tiles tileKeeper;

  @override
  void initState() {
    boardState = BoardState();
    controller = ScrollController();
    tileKeeper = Tiles();
    Future.delayed(Duration.zero).then((_) => gameProvider = Provider.of(context, listen: false));

    // threeChessBoard = ThreeChessBoard(
    //     boardState: BoardState.newGame(), height: 1000, width: 1000);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  
  List<double> _sectionStarts(double screenHeight, int requestsLength){
    double chatHeight = chatScreenHeight ?? screenHeight;
    double requestsHeight = (screenHeight * voteHeightFraction) * requestsLength;

    return [
      0,
      chatHeight,
      chatHeight + requestsHeight + 30*(requestsHeight == 0 ? 0 : 1),
      chatHeight + requestsHeight +(screenHeight * gameTableHeightFraction * iconBarFractionOfTable) + 30, // (20 max dot size, 5 +5 edgeInsets)30 should be the grey bar at the bottom
    chatHeight + requestsHeight + (screenHeight*gameTableHeightFraction),
    ];
  }

  List<Widget> _subScreens;
  
  _goToNearestSubScreen(double screenHeight, int requestsLength){
    controller.animateTo(_sectionStarts(screenHeight, requestsLength)[_nearestIndexOf(controller.offset, _sectionStarts(screenHeight, requestsLength))],
    curve: Curves.linear, duration: Duration(milliseconds: 200));
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

  bool _onEndNotification(ScrollEndNotification scrollNotification, double screenHeight, int requestsLength){
    if(scrollNotification is ScrollEndNotification){
      Future.delayed(Duration.zero).then((_) =>
          _goToNearestSubScreen(screenHeight, requestsLength));
      //print("i tried, this scroll just ended");
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {

    bool isLocked = Provider.of<ScrollProvider>(context).isLockedHorizontal;

    switchIsLocked(){
      Provider.of<ScrollProvider>(context, listen: false).isLockedHorizontal = !isLocked;
    }

    double unusableHeight = MediaQuery.of(context).padding.top + kToolbarHeight;


Function getOnAccept(RequestType requestType){
  Map<RequestType, Function> onAccept = {
    RequestType.Surrender :() =>  gameProvider.acceptSurrender(),
    RequestType.Remi : ()  => gameProvider.acceptRemi(),
    RequestType.TakeBack : () => gameProvider.acceptTakeBack(),
  };
  return onAccept[requestType];
}
Function getOnDecline(RequestType requestType){
  Map<RequestType, Function> onDecline= {
    RequestType.Surrender : () => gameProvider.declineSurrender(),
    RequestType.Remi : ()  => gameProvider.declineRemi(),
    RequestType.TakeBack : ()  => gameProvider.declineTakeBack(),
  };
  return onDecline[requestType];
}

    Map<RequestType, Function> onRequest = {
      RequestType.Surrender : () => gameProvider.requestSurrender(),
      RequestType.Remi :() =>  gameProvider.requestRemi(),
      RequestType.TakeBack :() =>  gameProvider.requestTakeBack(),
    };

    Map<RequestType, Function> onLocalRequest = {
      RequestType.Surrender : () =>setState( () => boardState = BoardState()), //TODO TESTING PHASE ONLY
      RequestType.Remi :() => setState( () => boardState = BoardState()),  //TODO TESTING PHASE ONLY
      RequestType.TakeBack :() =>  setState( () {

        if (boardState.chessMoves.length != null && boardState.chessMoves.length > 1) {
          boardState.transformTo(boardState.chessMoves.sublist(0, boardState.chessMoves.length-1));
        }
      }),
    };

    return RelativeBuilder(
      

        builder: (context, screenHeight, screenWidth, sy, sx)
      {
        double usableHeight = screenHeight - unusableHeight;
        List<Request> requests = []; //Needs to be Not Null ! //TODO JAN ADD REQUEST FROM PROVIDER

        /* Example Request:

        Request(
          moveIndex: 0,
          playerResponse: {
            ResponseRole.Create: PlayerColor.black,
            ResponseRole.Decline: null,
            ResponseRole.Accept: null,
          },
          requestType: RequestType.Surrender,
        )

         */
        List<Widget> votes = [];
        requests.forEach((request) { votes.add(AcceptRequestType(
          height: screenHeight * voteHeightFraction,
          requestType: request.requestType,
          whosAsking: request.playerResponse[ResponseRole.Create],
          onAccept: () => getOnAccept(request.requestType),
          onDecline: () => getOnDecline(request.requestType),
          movesLeftToVote: 3-((boardState.chessMoves.length % 3 )- ((request.playerResponse[ResponseRole.Create].index + 2) % 3)).abs(),
        ));});
        bool isLocal = Provider.of<GameProvider>(context)?.game != null; // TODO FOR TESTING PHASE, Local should be decided not just on game == null
        _subScreens = [
          ChatBoardSubScreen(
              height: chatScreenHeight ?? screenHeight,),
          BoardBoardSubScreen(
            boardState: Provider.of<BoardState>(context, listen:false),
            boardStateListen: Provider.of<BoardState>(context),
          tileKeeper: tileKeeper,),
          ...votes,
          TableBoardSubScreen(
            boardStateListen: Provider.of<BoardState>(context),
            controller: ScrollController(),
            isLocal: isLocal,
            onRequest:  isLocal ? onRequest : onLocalRequest, // TODO FOR TESTING PHASE, Local should be decided not just on game == null
            height: gameTableHeightFraction * screenHeight,
              iconBarFraction: iconBarFractionOfTable),
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
              onNotification: (scrollNotification) => _onEndNotification(scrollNotification, screenHeight, requests.length),
              child: SingleChildScrollView(
                physics: Provider.of<ScrollProvider>(context).isMakeAMoveLock ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
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

