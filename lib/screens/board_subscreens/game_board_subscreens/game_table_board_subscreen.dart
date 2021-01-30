import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';

import '../../../board/BoardState.dart';
import '../../../models/enums.dart';
import '../../../widgets/move_table.dart';
import '../../../providers/game_provider.dart';

class TableBoardSubScreen extends StatefulWidget {
  final BoardState boardStateListen;
  final ScrollController controller;
  final double bodyHeight;
  final double iconBarHeight;
  final Function(RequestType) onRequest;
  final bool isLocal;

  TableBoardSubScreen(
      {this.boardStateListen,
      this.controller,
      this.bodyHeight,
      this.iconBarHeight,
      this.onRequest,
      this.isLocal});

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
    Future.delayed(Duration.zero).then((_) =>
        gameProvider = Provider.of<GameProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    return RelativeBuilder(
        builder: (context, screenHeight, screenWidth, sy, sx) {
      return GameTable(
        iconBarHeight: widget.iconBarHeight,
        boardStateListen: widget.boardStateListen,
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
          print("i demand a $requestType");
          setState(() {
            if (!widget.isLocal) {
              pendingActions.add(requestType);
            }
            confirmation = null;
            widget.onRequest(requestType)();
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
