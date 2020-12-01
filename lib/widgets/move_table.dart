import 'package:flutter/material.dart';
import 'package:three_chess/board/BoardState.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/user.dart';
import '../models/chess_move.dart';

enum TableAction { DrawOffer, TakebackRequest, SurrenderRequest }

typedef void RequestAction(TableAction tableAction);

class GameTable extends StatelessWidget {
  final BoardState boardState;
  final Size size;
  final List<TableAction> pendingActions;
  final TableAction confirmation;
  final RequestAction onConfirmation;
  final Function onConfirmationCancel;
  final RequestAction onRequest;
  final RequestAction onRequestCancel;
  final ScrollController controller;

  GameTable(
      {this.boardState,
      this.onRequestCancel,
      this.onConfirmation,
      this.onConfirmationCancel,
      this.onRequest,
      this.size,
      this.controller,
      this.pendingActions,
      this.confirmation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.black38,
        border: Border.all(
          color: Colors.white,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          iconBar(),
          Stack(children: [

            moveTable(boardState),
            if (pendingActions != null && pendingActions.isNotEmpty)
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children:pendingActions.map((pendingAction) =>  Align(
                  alignment: Alignment.topCenter,
                  child: pendingBox(
                      height: size.height * 0.1, pendingAction: pendingAction))).toList()
             ),
          ]),
        ],
      ),
    );
  }

  final Map<TableAction, String> pendingMessage = {
    TableAction.DrawOffer: "Draw offer pending ..",
    TableAction.SurrenderRequest: "Surrender request pending ..",
    TableAction.TakebackRequest: "Takeback request pending..",
  };

  Widget pendingBox({double height, TableAction pendingAction}) {
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

  Widget moveTable(BoardState boardState) {
    print(boardState.chessMoves.length);
    return Container(
      // height: size.height * 0.8,
      child: GridView.count(
        shrinkWrap: true,
        controller: controller,
        padding: EdgeInsets.all(5),
        crossAxisCount: 3,
        children: [
          ...boardState.chessMoves.map((e) {
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
  
  Widget _noPressWrapper({Widget child, TableAction tableAction}){
    return pendingActions?.contains(tableAction) ?? false ? IgnorePointer(
      child:Stack(children: [
        child,
      Positioned.fill(
        child: Container(
            color: Colors.black26, ),
      ),]),) :
    child;
  }
  
  List<Widget> _confirmationBar(TableAction tableAction) {
    List<Widget> result = [];

    
    Widget iconButtonTake = _noPressWrapper(
        tableAction: TableAction.TakebackRequest,
        child: Container(
        color: Colors.orangeAccent,
        child: IconButton(
      padding: EdgeInsets.all(5),
      onPressed: () => onRequest(TableAction.TakebackRequest),
      icon: Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.white,
      ),
    )));
    Widget iconButtonDraw = _noPressWrapper(
        tableAction: TableAction.DrawOffer,
        child: Container(
        color: Colors.orangeAccent,
        child: IconButton(
      padding: EdgeInsets.all(5),
      onPressed: () => onRequest(TableAction.DrawOffer),
      icon: Text(
        '1/2',
        style: TextStyle(color: Colors.white),
      ),
    )));
    Widget iconButtonSurr = _noPressWrapper(
        tableAction: TableAction.SurrenderRequest,
        child: Container(
        color: Colors.orangeAccent,
        child: IconButton(
          padding: EdgeInsets.all(5),
          onPressed: () => onRequest(TableAction.SurrenderRequest),
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
    switch (tableAction) {
      case TableAction.TakebackRequest:
        result = [iconButtonTake, cancel, emptySpace];
        break;
      case TableAction.DrawOffer:
        result = [emptySpace, iconButtonDraw, cancel];
        break;
      case TableAction.SurrenderRequest:
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
      width: size.width,
      height: size.height * 0.1, //TODO Should inherit IconBarFraction of BoardScreen
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: confirmation != null
            ? _confirmationBar(confirmation)
            : [
                _noPressWrapper(
                    tableAction: TableAction.TakebackRequest,
                    child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () => onConfirmation(TableAction.TakebackRequest),
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                  ),
                )),
          _noPressWrapper(
              tableAction: TableAction.DrawOffer,
              child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () => onConfirmation(TableAction.DrawOffer),
                  icon: Text(
                    '1/2',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          _noPressWrapper(
              tableAction: TableAction.SurrenderRequest,
              child: IconButton(
                  padding: EdgeInsets.all(5),
                  onPressed: () => onConfirmation(TableAction.SurrenderRequest),
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
