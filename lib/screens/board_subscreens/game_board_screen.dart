import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../board/client_game.dart';
import '../../board/OnlineClientGame.dart';
import '../../helpers/scroll_sections.dart';
import '../../models/enums.dart';
import '../../models/request.dart';
import '../../models/game.dart';
import '../../models/online_game.dart';
import '../../providers/ClientGameProvider.dart';
import '../../providers/scroll_provider.dart';
import '../../widgets/accept_table_action.dart';
import '../../widgets/three_chess_board.dart';
import 'game_board_subscreens/game_board_board_subscreen.dart';
import 'game_board_subscreens/game_chat_board_subscreen.dart';
import 'game_board_subscreens/game_table_board_subscreen.dart';

class GameBoardScreen extends StatefulWidget {
  final Game game;

  GameBoardScreen({@required this.game});

  @override
  _GameBoardScreenState createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> with ScrollSections{
  ThreeChessBoard threeChessBoard;
  ScrollController controller;
  ClientGameProvider clientGameProvider;
  final double iconBarFractionOfTable = 0.1;
  final double gameTableHeightFraction = 0.7;
  final double voteHeightFraction = 0.1;
  final double bottomSpace = 30; //This is the grey dot Bar of the mainPage PageViewer -- should kinda be dependent on the state (when you navigator pop you want this to be 0

  double tableIconBarHeight(double screenHeight){
    return iconBarFractionOfTable * screenHeight;
  }

  double tableBodyHeight(double screenHeight){
    return gameTableHeightFraction * screenHeight - iconBarFractionOfTable;
  }

  double chatScreenHeight(double screenHeight){
    return screenHeight-bottomSpace;
  }

  @override
  void initState() {
    controller = ScrollController();
    Future.delayed(Duration.zero).then((_) {
      clientGameProvider = Provider.of<ClientGameProvider>(context, listen:false);
      sections = _createSections(MediaQuery.of(context).size.height);
    });

    super.initState();
  }

  @override
  void dispose() {
    clientGameProvider.setClientGame(null);
    controller.dispose();
    super.dispose();
  }



  List<ScrollSection> _createSections(double screenHeight){
    return [
      if(clientGameProvider.clientGame.hasChat)
        ScrollSection(name: "Chat", height: chatScreenHeight(screenHeight), isAnchorTop: true),
      ScrollSection(name: "Board", height: screenHeight, isAnchorTop: true),
      ScrollSection(name: "Requests", height: 0, isAnchorTop: false),
      ScrollSection(name: "IconBar", height: tableIconBarHeight(screenHeight), isAnchorTop: false),
      ScrollSection(name: "Table", height: tableBodyHeight(screenHeight), isAnchorTop: false),
    ];
  }


  @override
  Widget build(BuildContext context) {
    ClientGame clientGame =
        Provider.of<ClientGameProvider>(context, listen: false).clientGame;

    bool isLocked = Provider.of<ScrollProvider>(context).isLockedHorizontal;

    switchIsLocked() {
      Provider.of<ScrollProvider>(context, listen: false).isLockedHorizontal =
          !isLocked;
    }

    double unusableHeight = MediaQuery.of(context).padding.top + kToolbarHeight;


    return RelativeBuilder(
      builder: (context, screenHeight, screenWidth, sy, sx) {

        List<Request> requests = [];
        List<Widget> votes = [];

        if(widget.game.runtimeType is OnlineGame){
          OnlineClientGame onlineGameClientDo =Provider.of<ClientGameProvider>(context).clientGame as OnlineClientGame;
          OnlineGame onlineGame = Provider.of<ClientGameProvider>(context).clientGame.game as OnlineGame;

          requests = onlineGame.requests;

          updateHeightOf(sectionIndex: 2, height: (requests.length * (screenHeight * voteHeightFraction)));

          requests.forEach((request) {
            votes.add(AcceptRequestType(
              height: screenHeight * voteHeightFraction,
              requestType: request.requestType,
              whosAsking: request.playerResponse[ResponseRole.Create],
              onAccept: () => onlineGameClientDo.getOnAccept(request.requestType),
              onDecline: () => onlineGameClientDo.getOnDecline(request.requestType),
              movesLeftToVote: 3 -
                  ((clientGame.chessMoves.length % 3) -
                      ((request.playerResponse[ResponseRole.Create].index +
                          2) %
                          3))
                      .abs(),
            ));
          });

        }

        List<Widget> _subScreens = [
          if(clientGame.hasChat)
            ChatBoardSubScreen(
            height: chatScreenHeight(screenHeight),
          ),
          BoardBoardSubScreen(bottomSpace: bottomSpace,),
          ...votes,
          TableBoardSubScreen(
              controller: ScrollController(),
              onRequest: clientGame.doActionButton,
              bodyHeight: tableBodyHeight(screenHeight),
              iconBarHeight: tableIconBarHeight(screenHeight)),
        ];

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(!isLocked ? Icons.lock_open : Icons.lock_clock),
                onPressed: () => switchIsLocked(),
              ),
            ],
          ),
          body: NotificationListener<ScrollEndNotification>(
            onNotification: (scrollNotification) => onEndNotification(
                scrollNotification: scrollNotification, screenHeight: screenHeight),
            child: SingleChildScrollView(
              physics: Provider.of<ScrollProvider>(context).isMakeAMoveLock
                  ? NeverScrollableScrollPhysics()
                  : AlwaysScrollableScrollPhysics(),
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _subScreens,
              ),
            ),
          ),
        );
      },
    );
  }
}
