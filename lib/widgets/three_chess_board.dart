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



class ThreeChessBoard extends StatefulWidget {
  final Tiles tileKeeper = Tiles();
  final BoardState boardState;
  final TimeCounter timeCounter = TimeCounter(); //Not used yet
  final TileSelect tileSelect = TileSelect();
  final double height;
  final double width;
  final bool isOffline;


  ThreeChessBoard({this.boardState, this.height, this.width, this.isOffline = false});

  @override
  _ThreeChessBoardState createState() => _ThreeChessBoardState();

}

class _ThreeChessBoardState extends State<ThreeChessBoard> {
  MapEntry<String, List<String>> highlighted;
  String draggedPiece;
  Offset dragOffset;
  Offset startingOffset;
  PlayerColor playingPlayer;
  bool didStart = false;
  bool somethingChangedWorkAround = true;

  bool get myTurn{
    if(widget.isOffline){
      return true;
    }
    return playingPlayer != null ? (playingPlayer == PlayerColor.values[widget.boardState.chessMoves.length%3] && didStart) : false;
  }

  // TODO Implement timeCounter

  @override
  void initState() {
    setState(() {

     // widget.tileKeeper.rotateTilesNext();
    });
    Future.delayed(Duration.zero).then((_) {
      GameProvider gameProvider = Provider.of<GameProvider>(context ,listen: false);
      playingPlayer =
          gameProvider.player?.playerColor ?? PlayerColor.white; // TODO alternative red call will be removed
      if(playingPlayer != null){
          setState(() {
            widget.tileKeeper.rotateTilesTo(playingPlayer);
          });
      }}
      );


    super.initState();
  }

  void updateGame(Game game) {
    //print("i update look the last move: " + game?.chessMoves?.last?.nextTile.toString());
    if (game != null) {
      widget.boardState.transformTo(game.chessMoves);
    }
  }


  _moveWasMade(context){
    if (!widget.isOffline) {
      GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
        gameProvider.sendMove(widget.boardState.chessMoves.last);
    }
//TODO make a timefull chessMove
  }

  @override
  Widget build(BuildContext context) {


    GameProvider gameProvider = Provider.of<GameProvider>(context);

   // print(gameProvider.player.playerColor.toString() + " this is what gameProvider says");

    if (widget.isOffline != true) {
      setState(() {
        updateGame(gameProvider.game);
      });
    }

    didStart = gameProvider.game?.didStart?? false;
    if(widget.isOffline){
      didStart = true;
    }
    playingPlayer =
        gameProvider.player?.playerColor ?? PlayerColor.red;

    setState(() { // TODO MOVE TO POSITION WHERE HIGHLIGHT CHANGES MAYBE
      widget.tileKeeper.highlightTiles(highlighted?.value);
    });


    // Provider.of<GameProvider>(context).game == null ?
    // Center(child: Column(
    //   children: [
    //     Text("lodaing ... "),
    //     CircularProgressIndicator(),
    //   ],
    // ))
    //     :
    //print("im a print " + widget.boardState.pieces.toString());
    return
     Listener(
       behavior: HitTestBehavior.opaque,
        onPointerDown: (details){
          String whatsHit = widget.tileKeeper.getTilePositionOf(details.localPosition);
          if(whatsHit != null){
            Provider.of<ScrollProvider>(context, listen: false).isMakeAMoveLock = true;
            //print("$whatsHit : ${widget.tileKeeper.tiles[whatsHit].isWhite}");
          }
         print(whatsHit);
          _startAMove(){
            //print(ThinkingBoard.getLegalMove(whatsHit, widget.boardState).toString() + "THIS IS WHAT BOARD SETS");
            print(widget.boardState.selectedMove.toString());
            if (widget.boardState.selectedMove == widget.boardState.chessMoves.length -1 || widget.boardState.selectedMove == null) {
              highlighted = MapEntry(whatsHit, ThinkingBoard.getLegalMove(whatsHit, widget.boardState));
              draggedPiece = whatsHit;
              startingOffset = details.localPosition;
            }
          }
          PlayerColor pieceColor = widget.boardState.pieces[whatsHit]?.playerColor;
          //PlayerColor playingPlayer = PlayerColor.white;

          setState(() {
            if(highlighted == null){
              if(widget.boardState.pieces[whatsHit] != null){
                if(pieceColor == playingPlayer){
                  _startAMove();
                }
              }
            }
            else{
              if(highlighted.value.contains(whatsHit) && myTurn){
                if(!widget.isOffline){ // TODO THIS WILL BE DIFFRENT ONCE THERES A BOARDSTATE MANAGER THAT HANDLES OFFLINE MOVES
                widget.boardState.movePieceTo(highlighted.key, whatsHit);
              }
              _moveWasMade(context);
                  highlighted = null;
              }
              else if(pieceColor == playingPlayer){
                highlighted = null;
                _startAMove();
              }
              else{
                highlighted = null;
              }
            }
          });
            },
        onPointerMove: (details){
          if(draggedPiece != null){
            setState(() {
              dragOffset =  details.localPosition - startingOffset;
            });
          }
        },
        onPointerUp: (details){
          Provider.of<ScrollProvider>(context, listen: false).isMakeAMoveLock = false;
          String whatsHit = widget.tileKeeper.getTilePositionOf(details.localPosition);
         // print(whatsHit);
            if (highlighted != null) {
              setState(() {
                if(highlighted.value.contains(whatsHit)&& myTurn){
                  if(!widget.isOffline){ // TODO THIS WILL BE DIFFRENT ONCE THERES A BOARDSTATE MANAGER THAT HANDLES OFFLINE MOVES
                widget.boardState.movePieceTo(highlighted.key, whatsHit);
              }
              _moveWasMade(context);
                      highlighted = null;
                      draggedPiece = null;
                      dragOffset = null;

                }
                else if(whatsHit == draggedPiece){
                      draggedPiece = null;
                      dragOffset = null;
                }
                else{
                  highlighted = null;
                  draggedPiece = null;
                  dragOffset = null;
                }
              });
            }
        },

        child: BoardPainter(
          pieces: widget.boardState.selectedPieces,
          tiles: widget.tileKeeper.tiles,
          height: widget.height,
          width: widget.width,
          pieceOffset: dragOffset,
          pieceOffsetKey: draggedPiece,
        ),
    );
  }
}
