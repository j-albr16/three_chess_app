import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../board/client_game.dart';
import '../providers/ClientGameProvider.dart';
import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';
import '../models/enums.dart';

typedef void RequestAction(RequestType requestType);

class GameTable extends StatelessWidget {
  final double width;
  final double bodyHeight;
  final List<RequestType> pendingActions;
  final RequestType confirmation;
  final RequestAction onConfirmation;
  final Function onConfirmationCancel;
  final RequestAction onRequest;
  final RequestAction onRequestCancel;
  final ScrollController controller;
  final double iconBarHeight;

  GameTable(
      {this.iconBarHeight,
      this.onRequestCancel,
      this.onConfirmation,
      this.onConfirmationCancel,
      this.onRequest,
      this.width,
        this.bodyHeight,
      this.controller,
      this.pendingActions,
      this.confirmation});

  @override
  Widget build(BuildContext context) {
    ClientGame clientGame = Provider.of<ClientGameProvider>(context).clientGame;
    return Container(
      width: width,
      height: bodyHeight + iconBarHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.black54,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          iconBar(),
          Stack(children: [

            moveTable(clientGame.chessMoves),
            if (pendingActions != null && pendingActions.isNotEmpty)
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children:pendingActions.map((pendingAction) =>  Align(
                  alignment: Alignment.topCenter,
                  child: pendingBox(
                      height: (bodyHeight + iconBarHeight) * 0.1, pendingAction: pendingAction))).toList()
             ),
          ]),
        ],
      ),
    );
  }

  final Map<RequestType, String> pendingMessage = {
    RequestType.Remi: "Draw offer pending ..",
    RequestType.Surrender: "Surrender request pending ..",
    RequestType.TakeBack: "Takeback request pending..",
  };

  Widget pendingBox({double height, RequestType pendingAction}) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey[30],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(pendingMessage[pendingAction]),
          Container(
           // alignment: Alignment.centerRight,
            child: IconButton(
              icon: Text("X", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
              onPressed: () {
                onRequestCancel(pendingAction);
                print("i want to cancel $pendingAction");
              },
            ),
          )

        ]),
    );
  }

  Widget moveTable(List<ChessMove> chessMoves) {
   // print(boardState.chessMoves.length);
    return Container(
      // height: size.height * 0.8,
      child: GridView.count(
        shrinkWrap: true,
        controller: controller,
        padding: EdgeInsets.all(5),
        crossAxisCount: 3,
        children: [
          ...chessMoves.map((e) {
            return tableTile(e);
          }).toList()
        ],
      ),
    );
  }

  Widget tableTile(ChessMove chessMove) {
    // return Padding(
    //   padding: EdgeInsets.all(2),
    return Container(
      // width: 100,
      // height: 100,
      child: FittedBox(
        // fit: BoxFit.contain,
        child: Center(
          child: Text(
            chessMove.nextTile,
            style: TextStyle(
              color: Colors.white,
              fontSize: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  
  Widget _noPressWrapper({Widget child, RequestType requestType}){
    return pendingActions?.contains(RequestType) ?? false ? IgnorePointer(
      child:Stack(children: [
        child,
      Positioned.fill(
        child: Container(
            color: Colors.black26, ),
      ),]),) :
    child;
  }
  
  List<Widget> _confirmationBar(RequestType requestType) {
    List<Widget> result = [];
    Widget iconButtonTake = _noPressWrapper(
        requestType: RequestType.TakeBack,
        child: Container(
        color: Colors.orangeAccent,
        child: IconButton(
      padding: EdgeInsets.all(5),
      onPressed: () => onRequest(RequestType.TakeBack),
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.white,
      ),
    )));
    Widget iconButtonDraw = _noPressWrapper(
        requestType: RequestType.Remi,
        child: Container(
        color: Colors.orangeAccent,
        child: IconButton(
      padding: EdgeInsets.all(5),
      onPressed: () => onRequest(RequestType.Remi),
      icon: Text(
        '1/2',
        style: TextStyle(color: Colors.white),
      ),
    )));
    Widget iconButtonSurr = _noPressWrapper(
        requestType: RequestType.Surrender,
        child: Container(
        color: Colors.orangeAccent,
        child: IconButton(
          padding: EdgeInsets.all(5),
          onPressed: () => onRequest(RequestType.Surrender),
          icon: Icon(
            Icons.flag,
            color: Colors.black,
          ),
        )));
    Widget cancel = Container(
      color: Colors.deepOrange[40],
      child: IconButton(
        padding: EdgeInsets.all(5),
        color: Colors.grey,
        onPressed: () => onConfirmationCancel(),
        icon: Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
      ),
    );
    Widget emptySpace = Padding(
      padding: EdgeInsets.all(5),
      child: Icon(
        Icons.error,
        color: Colors.transparent,
      ),
    );
    switch (requestType) {
      case RequestType.TakeBack:
        result = [iconButtonTake, cancel, emptySpace];
        break;
      case RequestType.Remi:
        result = [emptySpace, iconButtonDraw, cancel];
        break;
      case RequestType.Surrender:
        result = [emptySpace, cancel, iconButtonSurr];
        break;
    }

    return result;
  }

  Widget iconBar() {
    // return Padding(
    //   padding: EdgeInsets.all(10),
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white),
        ),
      ),
      width: width,
      height: iconBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: confirmation != null
            ? _confirmationBar(confirmation)
            : [
                _noPressWrapper(
                    requestType: RequestType.TakeBack,
                    child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () => onConfirmation(RequestType.TakeBack),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                )),
          _noPressWrapper(
              requestType: RequestType.Remi,
              child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () => onConfirmation(RequestType.Remi),
                  icon: Text(
                    '1/2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          _noPressWrapper(
              requestType: RequestType.Surrender,
              child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () => onConfirmation(RequestType.Surrender),
                  icon: Icon(Icons.flag, color: Colors.white),
                )),
              ],
      ),
    );
  }

  Widget playerBar(List<Player> player) {
    // return Padding(
    //   padding: EdgeInsets.all(10),
    return Container(
        // decoration: BoxDecoration(
        //   border: Border(
        //     top: BorderSide(color: Colors.white),
        //   ),
        // ),
        // width: size.width,
        // height: size.height * 0.1,
        // child: Row(
        //   children:
        //   player.map((e) => playerItem(e.user.userName, e.isOnline)).toList(),
        // ),
        );
  }

  Widget playerItem(String userName, bool isOnline) {
    // return Padding(
    //   padding: EdgeInsets.all(3),
    return Flexible(
      flex: 1,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
