import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/board/Painter.dart';
import 'package:three_chess/board/PieceMover.dart';
import 'package:three_chess/board/ThinkingBoard.dart';
import 'package:three_chess/board/TileSelect.dart';
import 'package:three_chess/board/Tiles.dart';
import 'package:three_chess/board/chess_move_info.dart';
import 'package:three_chess/board/timeCounter.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/providers/board_state_manager.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/providers/scroll_provider.dart';

typedef Future<bool> ResponseMove(ChessMove chessMove);

class ThreeChessBoard extends StatefulWidget {
  final Tiles tileKeeper;
  final BoardState boardState;
  final TimeCounter timeCounter = TimeCounter(); //Not used yet
  final double height;
  final double width;
  final PlayerColor whoIsPlaying;
  final ValueNotifier<bool> didStart;
  final BoardState boardStateListen;

  ThreeChessBoard(
      {
        this.tileKeeper,
        this.boardState,
      this.height,
      this.width,
      this.whoIsPlaying,
      this.didStart,
      this.boardStateListen});

  @override
  _ThreeChessBoardState createState() => _ThreeChessBoardState();
}

class _ThreeChessBoardState extends State<ThreeChessBoard> {
  Tiles tileKeeper;
  String draggedPiece;
  Offset dragOffset;
  Offset startingOffset;
  PlayerColor playingPlayer;
  bool somethingChangedWorkAround = true;
  UniqueKey painterKey;

  bool get myTurn {
    if (widget.whoIsPlaying == null) {
      return true;
    }
    return widget.whoIsPlaying != null
        ? (widget.whoIsPlaying ==
                PlayerColor.values[widget.boardState.chessMoves.length % 3] &&
            widget.didStart.value)
        : false;
  }

  // TODO Implement timeCounter

  @override
  void initState() {
    super.initState();
      playingPlayer = widget.whoIsPlaying;
      tileKeeper = widget.tileKeeper ?? Tiles();

      if (playingPlayer != null) {
        setState(() {
          widget.tileKeeper.rotateTilesTo(playingPlayer);
        });
      }


  }

  @override
  void dispose(){

    super.dispose();
  }

  void updateHighlight(MapEntry<String, List<String>> newHighlighted){
    print("nice u wanna update Highlights in ThreeChessBoard, i aprreciate");
    widget.tileKeeper.highlightTiles(newHighlighted?.value);
  }

  String possibleDeselect; //This makes deselecting by clicking on the same piece again possible

  doHitDown(String whatsHit, details, BuildContext context) {

    BoardStateManager boardStateManager = Provider.of<BoardStateManager>(context, listen: false);

    _cleanDrag(){
      draggedPiece = null;
      dragOffset = null;
    }
    _cleanMove(){
      boardStateManager.highlighted = null;
      _cleanDrag();
    }
    _startAMove(){
      print(widget.boardState.selectedMove.toString());
      if (widget.boardState.selectedMove == widget.boardState.chessMoves.length -1 || widget.boardState.selectedMove == null) {
        boardStateManager.highlighted = MapEntry(whatsHit, ThinkingBoard.getLegalMove(whatsHit, widget.boardState));
        print("${Provider.of<BoardStateManager>(context, listen: false).highlighted}");
        if (boardStateManager.highlighted?.value?.isNotEmpty == true) {
          draggedPiece = whatsHit;
          startingOffset = details.localPosition;
        }
        else{
          boardStateManager.highlighted = null;
        }
      }
    }
    if (whatsHit == null) {
    } else {
      // if whatsHit != null
      PlayerColor myColor = widget.whoIsPlaying ?? PlayerColor.values[widget.boardState.chessMoves.length % 3];

        if (boardStateManager.highlighted == null) {
          if (widget.boardState.pieces[whatsHit]?.playerColor ==
              myColor) {
            //if myPiece is hit. myPiece :
            _startAMove();
          } else if (widget.boardState.pieces[whatsHit] != null) {
            //if piece is hit && hitPiece isNot myPiece
          } else {
            //if hitBoard && not hit any piece
          }
        } else {
          //if highlighted != null
          if(boardStateManager.highlighted.value.contains(whatsHit)){
            //if whatsHit is highlighted
            if(myTurn){
              boardStateManager.clientMove(boardStateManager.highlighted.key, whatsHit);
            }
           _cleanMove();
          }
          else if(widget.boardState.pieces[whatsHit].playerColor == myColor){
            //if whatsHit is myPiece.
            if(whatsHit == boardStateManager.highlighted.key) {
              possibleDeselect = whatsHit;
            }
            boardStateManager.highlighted = null;
            _startAMove();

          }
          else {
            //if whatsHit is not a Highlight or one of your pieces
            _cleanMove();
          }
        }
    }
  }

  doHitUp(String whatsHit, BuildContext context) {
    BoardStateManager boardStateManager = Provider.of<BoardStateManager>(context, listen: false);

    _cleanDrag(){
      draggedPiece = null;
      dragOffset = null;
    }

    _cleanMove(){
      boardStateManager.highlighted = null;
      _cleanDrag();
    }

    if(whatsHit == null){
      _cleanDrag();
    }
    else {
      if(boardStateManager.highlighted != null){
        if(boardStateManager.highlighted.value.contains(whatsHit)) {
          if (widget.whoIsPlaying == null) {
            boardStateManager.clientMove(boardStateManager.highlighted.key, whatsHit);
            _cleanMove();
            //Make the move because only the turns pieces can drag
          } else { //if widget.whoIsPlaying != null
            //check weather its your turn
            if(myTurn){
              boardStateManager.clientMove(boardStateManager.highlighted.key, whatsHit);
            }
            _cleanMove();
          }
        } else if(whatsHit == draggedPiece){
          //Basically means when piece is tapped and not dragged
          // (tho you can drag and still stop at the same location)

          possibleDeselect == whatsHit ?
            _cleanMove() : _cleanDrag();
          possibleDeselect = null;

        } else { //if you neither drag to start or to highlight
          _cleanMove();
        }
      } else { //if highlighted == null
        //Nothing
        print("i actually think that nothing is highlighted, lul - im in doHitUp-ThreeChessBoard");
      }
    }
  }

  @override
  Widget build(BuildContext context) {


      updateHighlight(Provider.of<BoardStateManager>(context).highlighted);

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (details) {
        String whatsHit =
            tileKeeper.getTilePositionOf(details.localPosition);
        if (whatsHit != null) {
          Provider.of<ScrollProvider>(context, listen: false).isMakeAMoveLock =
              true;
        }
        setState(() {
          doHitDown(whatsHit, details, context);
        });
      },
      onPointerMove: (details) {
        if (draggedPiece != null) {
          setState(() {
            dragOffset = details.localPosition - startingOffset;
          });
        }
      },
      onPointerUp: (details) {
        Provider.of<ScrollProvider>(context, listen: false).isMakeAMoveLock =
            false;
        String whatsHit =
            tileKeeper.getTilePositionOf(details.localPosition);
        setState(() {
          doHitUp(whatsHit, context);
        });
      },
      child: BoardPainter(
        key: painterKey,
        pieces: widget.boardStateListen.selectedPieces,
        tiles: tileKeeper.tiles,
        height: widget.height,
        width: widget.width,
        pieceOffset: dragOffset,
        pieceOffsetKey: draggedPiece,
      ),
    );
  }
}
