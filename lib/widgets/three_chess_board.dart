import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/board/Painter.dart';
import 'package:three_chess/board/ThinkingBoard.dart';
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
  BoardStateManager boardStateManager;

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
      Future.delayed(Duration.zero).then((value) {
        boardStateManager = Provider.of<BoardStateManager>(context);
        boardStateManager.addListener(() {
          updateHighlight(boardStateManager.highlighted);
        });
      });

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
    setState(() => widget.tileKeeper.highlightTiles(newHighlighted?.value));
  }

  String possibleDeselect; //This makes deselecting by clicking on the same piece again possible

  doHitDown(String whatsHit, details) {
    MapEntry<String, List<String>> highlighted = boardStateManager.highlighted;

    _cleanDrag(){
      draggedPiece = null;
      dragOffset = null;
    }
    _cleanMove(){
      highlighted = null;
      widget.tileKeeper.highlightTiles(highlighted?.value);
      _cleanDrag();
    }
    _startAMove(){
      print(widget.boardState.selectedMove.toString());
      if (widget.boardState.selectedMove == widget.boardState.chessMoves.length -1 || widget.boardState.selectedMove == null) {
        highlighted = MapEntry(whatsHit, ThinkingBoard.getLegalMove(whatsHit, widget.boardState));
        widget.tileKeeper.highlightTiles(highlighted?.value);
        if (highlighted.value.isNotEmpty) {
          draggedPiece = whatsHit;
          startingOffset = details.localPosition;
        }
        else{
          highlighted = null;
        }
      }
    }
    if (whatsHit == null) {
    } else {
      // if whatsHit != null
      PlayerColor myColor = widget.whoIsPlaying ?? PlayerColor.values[widget.boardState.chessMoves.length % 3];

        if (highlighted == null) {
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
          if(highlighted.value.contains(whatsHit)){
            //if whatsHit is highlighted
            if(myTurn){
              boardStateManager.clientMove(highlighted.key, whatsHit);
            }
           _cleanMove();
          }
          else if(widget.boardState.pieces[whatsHit].playerColor == myColor){
            //if whatsHit is myPiece.
            if(whatsHit == highlighted.key) {
              possibleDeselect = whatsHit;
            }
            highlighted = null;
            _startAMove();

          }
          else {
            //if whatsHit is not a Highlight or one of your pieces
            _cleanMove();
          }
        }
    }
  }

  doHitUp(String whatsHit) {
    MapEntry<String, List<String>> highlighted = boardStateManager.highlighted;

    _cleanDrag(){
      draggedPiece = null;
      dragOffset = null;
    }
    _cleanMove(){
      highlighted = null;
      widget.tileKeeper.highlightTiles(highlighted?.value);
      _cleanDrag();
    }
    if(whatsHit == null){
      _cleanDrag();
    }
    else {
      if(highlighted != null){
        if(highlighted.value.contains(whatsHit)) {
          if (widget.whoIsPlaying == null) {
            boardStateManager.clientMove(highlighted.key, whatsHit);
            _cleanMove();
            //Make the move because only the turns pieces can drag
          } else { //if widget.whoIsPlaying != null
            //check weather its your turn
            if(myTurn){
              boardStateManager.clientMove(highlighted.key, whatsHit);
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {

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
          doHitDown(whatsHit, details);
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
          doHitUp(whatsHit);
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
