import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/dragged_piece.dart';
import '../board/client_game.dart';
import '../providers/ClientGameProvider.dart';
import '../board/Painter.dart';
import '../board/timeCounter.dart';
import '../models/chess_move.dart';
import '../providers/scroll_provider.dart';

typedef Future<bool> ResponseMove(ChessMove chessMove);
typedef void OnPointerDown(PointerDownEvent details);
typedef void OnPointerUp(PointerUpEvent details);
typedef Offset GetOffset(String string);
typedef void UpdateDragged(DraggedPiece draggedPiece);

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

class _ThreeChessBoardState extends State<ThreeChessBoard>  with SingleTickerProviderStateMixin{
  UniqueKey painterKey;
  AnimationController _controller;
  Animation<double> _pieceMoveAnimation;


  // TODO Implement timeCounter

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );

    _pieceMoveAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    Future.delayed(Duration.zero).then((value) => Provider.of<ClientGameProvider>(context, listen: false).clientGame.onAnimate = animatePiece);
  }

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
    Provider.of<ClientGameProvider>(context, listen: false).clientGame.onAnimate = null;

  }

  Future<void> animatePiece({@required String draggedPiece, @required String animatedStart, @required GetOffset getOffset, Map<String, DraggedPiece> draggedPieces, UpdateDragged updateDragged}) async { //TODO clientGame --> Function getOffset %% draggedPieces

    if(draggedPiece != null && animatedStart != null){

        Offset dragOffset = getOffset(animatedStart) - getOffset(draggedPiece);
        DraggedPiece currentDraggedPiece = DraggedPiece(draggedPiece: draggedPiece, dragOffset: dragOffset);
        Function offsetUpdate = () {
          currentDraggedPiece.dragOffset = dragOffset - dragOffset*_pieceMoveAnimation.value;
              updateDragged(currentDraggedPiece);
        };

        _pieceMoveAnimation.addListener(offsetUpdate);

        _controller.repeat().whenCompleteOrCancel(() {
          draggedPieces.remove(currentDraggedPiece.draggedPiece);
          _pieceMoveAnimation.removeListener(offsetUpdate);
        });


    }

  }


  Function scrollProviderWrap({Function doHit, context, ClientGame clientGame, bool isPointerDown,}){

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

    OnPointerDown pointerDown = scrollProviderWrap(
        doHit: clientGameDo.doHitDown,
        context: context,
        clientGame: clientGame,
        isPointerDown: true);

    OnPointerUp pointerUp = scrollProviderWrap(
        doHit: clientGameDo.doHitUp,
        context: context,
        clientGame: clientGame,
        isPointerDown: false);


    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: pointerDown,
      onPointerUp: pointerUp,
      onPointerMove:  clientGameDo.doHitMove,
      child: BoardPainter(
        key: painterKey,
        pieces: clientGame.selectedPieces,
        tiles: clientGame.tileKeeper.tiles,
        height: widget.height,
        width: widget.width,
        draggedPieces: clientGame.draggedPieces,
      ),
    );
  }
}
