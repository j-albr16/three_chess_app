import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/board/Painter.dart';
import 'package:three_chess/board/PieceMover.dart';
import 'package:three_chess/board/ThinkingBoard.dart';
import 'package:three_chess/board/TileSelect.dart';
import 'package:three_chess/board/Tiles.dart';
import 'package:three_chess/board/timeCounter.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/providers/scroll_provider.dart';

typedef Future<bool> ResponseMove(ChessMove chessMove);

class ThreeChessBoard extends StatefulWidget {
  final Tiles tileKeeper;
  final BoardState boardState;
  final TimeCounter timeCounter = TimeCounter(); //Not used yet
  final double height;
  final double width;
  final ResponseMove sendMove;
  final ValueNotifier<List<ChessMove>> syncChessMoves;
  final PlayerColor whoIsPlaying;
  final ValueNotifier<bool> didStart;

  ThreeChessBoard(
      {this.tileKeeper,
        this.boardState,
      this.height,
      this.width,
      this.sendMove,
      this.syncChessMoves,
      this.whoIsPlaying,
      this.didStart});

  @override
  _ThreeChessBoardState createState() => _ThreeChessBoardState();
}

class _ThreeChessBoardState extends State<ThreeChessBoard> {
  Tiles tileKeeper;
  MapEntry<String, List<String>> highlighted;
  String draggedPiece;
  Offset dragOffset;
  Offset startingOffset;
  PlayerColor playingPlayer;
  bool somethingChangedWorkAround = true;
  bool waitingForResponse = false;
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
      playingPlayer = widget.whoIsPlaying;
      tileKeeper = widget.tileKeeper ?? Tiles();
      widget.syncChessMoves?.addListener(() => updateGame());
      if (playingPlayer != null) {
        setState(() {
          widget.tileKeeper.rotateTilesTo(playingPlayer);
        });
      }

    super.initState();
  }

  void updateGame() {
    //print("i update look the last move: " + game?.chessMoves?.last?.nextTile.toString());
    if (!waitingForResponse) {
      setState(() {
        widget.boardState.transformTo(widget.syncChessMoves.value);
      });
    }
  }

  _makeAMove(String start, String whatsHit) {
    widget.boardState.movePieceTo(start, whatsHit);

    waitingForResponse = true;
    widget.sendMove(widget.boardState.chessMoves.last).then((response) {
      if (!response) {
        widget.boardState.transformTo(widget.boardState.chessMoves
            .sublist(0, widget.boardState.chessMoves.length - 1));
      }
      waitingForResponse = false;
    });
  }

  doHitDown(String whatsHit, details) {

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
              _makeAMove(highlighted.key, whatsHit);
            }
           _cleanMove();
          }
          else if(widget.boardState.pieces[whatsHit].playerColor == myColor){
            //if whatsHit is myPiece.
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
            _makeAMove(highlighted.key, whatsHit);
            _cleanMove();
            //Make the move because only the turns pieces can drag
          } else { //if widget.whoIsPlaying != null
            //check weather its your turn
            if(myTurn){
              _makeAMove(highlighted.key, whatsHit);
            }
            _cleanMove();
          }
        } else if(whatsHit == draggedPiece){
          //Basically means when piece is tapped and not dragged
          // (tho you can drag and still stop at the same location)
          _cleanDrag();
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
      behavior: HitTestBehavior.opaque,
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
        pieces: widget.boardState.selectedPieces,
        tiles: tileKeeper.tiles,
        height: widget.height,
        width: widget.width,
        pieceOffset: dragOffset,
        pieceOffsetKey: draggedPiece,
      ),
    );
  }
}
