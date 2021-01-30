import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../board/client_game.dart';
import '../providers/ClientGameProvider.dart';
import '../board/Painter.dart';
import '../board/timeCounter.dart';
import '../models/chess_move.dart';
import '../providers/scroll_provider.dart';

typedef Future<bool> ResponseMove(ChessMove chessMove);
typedef bool OnPointer(PointerEvent details);

class ThreeChessBoard extends StatefulWidget {
  final TimeCounter timeCounter = TimeCounter(); //Not used yet
  final double height;
  final double width;

  ThreeChessBoard(
      {
      this.height,
      this.width,});

  @override
  _ThreeChessBoardState createState() => _ThreeChessBoardState();
}

class _ThreeChessBoardState extends State<ThreeChessBoard> {
  UniqueKey painterKey;


  // TODO Implement timeCounter

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }


  Function scrollProviderWrap({OnPointer doHit, context, ClientGame clientGame, bool isPointerDown,}){

    return (details){
    String whatsHit =
    clientGame.tileKeeper.getTilePositionOf(details.localPosition);
    if (whatsHit != null) {
      Provider
          .of<ScrollProvider>(context, listen: false)
          .isMakeAMoveLock =
          isPointerDown;
    }
    return doHit(details);
  };
  }



  @override
  Widget build(BuildContext context) {

    ClientGame clientGameDo = Provider.of<ClientGameProvider>(context, listen: false).clientGame;

    ClientGame clientGame = Provider.of<ClientGameProvider>(context).clientGame;

    OnPointer pointerDown = scrollProviderWrap(
        doHit: clientGameDo.doHitDown,
        context: context,
        clientGame: clientGame,
        isPointerDown: true);

    OnPointer pointerUp = scrollProviderWrap(
        doHit: clientGameDo.doHitUp,
        context: context,
        clientGame: clientGame,
        isPointerDown: false);


    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: pointerDown,
      onPointerUp: clientGameDo.doHitUp,
      onPointerMove: pointerUp,
      child: BoardPainter(
        key: painterKey,
        pieces: clientGame.selectedPieces,
        tiles: clientGame.tileKeeper.tiles,
        height: widget.height,
        width: widget.width,
        pieceOffset: clientGame.dragOffset,
        pieceOffsetKey: clientGame.draggedPiece,
      ),
    );
  }
}
