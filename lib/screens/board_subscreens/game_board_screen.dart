import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../board/client_game.dart';
import '../../helpers/scroll_sections.dart';
import '../../models/enums.dart';
import '../../models/request.dart';
import '../../providers/ClientGameProvider.dart';
import '../../providers/scroll_provider.dart';
import '../../widgets/accept_table_action.dart';
import '../../providers/game_provider.dart';
import '../../widgets/three_chess_board.dart';
import 'game_board_subscreens/game_board_board_subscreen.dart';
import 'game_board_subscreens/game_chat_board_subscreen.dart';
import 'game_board_subscreens/game_table_board_subscreen.dart';

class GameBoardScreen extends StatefulWidget {
  final GameType gameType;

  GameBoardScreen({@required this.gameType});

  @override
  _GameBoardScreenState createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends State<GameBoardScreen> with ScrollSections{
  ThreeChessBoard threeChessBoard;
  ScrollController controller;
  final double iconBarFractionOfTable = 0.1;
  final double gameTableHeightFraction = 0.7;
  final double voteHeightFraction = 0.1;
  GameProvider gameProvider;

  double tableIconBarHeight(double screenHeight){
    return iconBarFractionOfTable * screenHeight;
  }

  double tableBodyHeight(double screenHeight){
    return gameTableHeightFraction * screenHeight - iconBarFractionOfTable;
  }

  double chatScreenHeight(double screenHeight){
    return screenHeight;
  }

  @override
  void initState() {
    controller = ScrollController();
    Future.delayed(Duration.zero).then((_) {
      gameProvider = Provider.of(context, listen: false);
      sections = _createSections(MediaQuery.of(context).size.height);
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  List<ScrollSection> _createSections(double screenHeight){
    return [
      ScrollSection(name: "Chat", height: chatScreenHeight(screenHeight), isAnchorTop: true),
      ScrollSection(name: "Board", height: screenHeight, isAnchorTop: true),
      ScrollSection(name: "Requests", height: 0, isAnchorTop: false),
      ScrollSection(name: "IconBar", height: tableIconBarHeight(screenHeight), isAnchorTop: false),
      ScrollSection(name: "Table", height: tableBodyHeight(screenHeight), isAnchorTop: false),
    ];
  }


  Function getOnAccept(RequestType requestType) {
    Map<RequestType, Function> onAccept = {
      RequestType.Surrender: () => gameProvider.acceptSurrender(),
      RequestType.Remi: () => gameProvider.acceptRemi(),
      RequestType.TakeBack: () => gameProvider.acceptTakeBack(),
    };
    return onAccept[requestType];
  }

  Function getOnDecline(RequestType requestType) {
    Map<RequestType, Function> onDecline = {
      RequestType.Surrender: () => gameProvider.declineSurrender(),
      RequestType.Remi: () => gameProvider.declineRemi(),
      RequestType.TakeBack: () => gameProvider.declineTakeBack(),
    };
    return onDecline[requestType];
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
        List<Request> requests =
            []; //Needs to be Not Null ! //TODO JAN ADD REQUEST FROM PROVIDER

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

        updateHeightOf(sectionIndex: 2, height: (requests.length * (screenHeight * voteHeightFraction)));

        List<Widget> votes = [];
        requests.forEach((request) {
          votes.add(AcceptRequestType(
            height: screenHeight * voteHeightFraction,
            requestType: request.requestType,
            whosAsking: request.playerResponse[ResponseRole.Create],
            onAccept: () => getOnAccept(request.requestType),
            onDecline: () => getOnDecline(request.requestType),
            movesLeftToVote: 3 -
                ((clientGame.chessMoves.length % 3) -
                        ((request.playerResponse[ResponseRole.Create].index +
                                2) %
                            3))
                    .abs(),
          ));
        });

        List<Widget> _subScreens = [
          ChatBoardSubScreen(
            height: chatScreenHeight(screenHeight),
          ),
          BoardBoardSubScreen(),
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
