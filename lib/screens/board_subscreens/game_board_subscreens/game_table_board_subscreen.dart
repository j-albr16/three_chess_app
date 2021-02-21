import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';


import '../../../board/client_game.dart';
import '../../../providers/ClientGameProvider.dart';
import '../../../models/enums.dart';
import '../../../widgets/move_table.dart';

class TableBoardSubScreen extends StatefulWidget {
  final ScrollController controller;
  final double bodyHeight;
  final double iconBarHeight;
  final Function(RequestType) onRequest;

  TableBoardSubScreen(
      {this.controller,
      this.bodyHeight,
      this.iconBarHeight,
      this.onRequest});

  @override
  _TableBoardSubScreenState createState() => _TableBoardSubScreenState();
}

class _TableBoardSubScreenState extends State<TableBoardSubScreen> {
  RequestType confirmation;
  List<RequestType> pendingActions = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
          ClientGame clientGame = Provider.of<ClientGameProvider>(context).clientGame;
      return GameTable(
        iconBarHeight: widget.iconBarHeight,
        width: screenWidth * 0.8,
        bodyHeight: widget.bodyHeight,
        controller: widget.controller,
        confirmation: confirmation,
        onConfirmation: (requestType) {
          setState(() {
            confirmation = requestType;
          });
        },
        onConfirmationCancel: () => setState(() => confirmation = null),
        onRequest: (requestType) {
          //print("i demand a $requestType");
          setState(() {
            if (clientGame.gameType == GameType.Online) {
              pendingActions.add(requestType);
            }
            confirmation = null;
            widget.onRequest(requestType)();
          });
        },
        onRequestCancel: (cancelPending) {
          //print("I demand to stop the vote!");
          setState(() {
            pendingActions.remove(cancelPending);
          });
        },
        pendingActions: !(clientGame.gameType == GameType.Online) ? [] : pendingActions,
      );
    });
  }
}
