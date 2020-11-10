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



class ThreeChessBoard extends StatefulWidget {
  final Tiles tileKeeper = Tiles();
  final BoardState boardState;
  final TimeCounter timeCounter = TimeCounter();
  final TileSelect tileSelect = TileSelect();
  final double height;
  final double width;


  ThreeChessBoard({this.boardState, this.height, this.width});

  @override
  _ThreeChessBoardState createState() => _ThreeChessBoardState();

}

class _ThreeChessBoardState extends State<ThreeChessBoard> {
  MapEntry<String, List<String>> highlighted;
  String draggedPiece;
  Offset dragOffset;
  Offset startingOffset;
  PlayerColor playingPlayer;

  bool get myTurn{
    return playingPlayer != null ? playingPlayer == PlayerColor.values[widget.boardState.chessMoves.length%3] : false;
  }

  // TODO Implement timeCounter

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      GameProvider gameProvider = Provider.of<GameProvider>(context ,listen: false);
      playingPlayer =
          gameProvider.player?.playerColor;
      if(playingPlayer != null){
        for (int i = 0; i < playingPlayer.index; i++) {
          widget.tileKeeper.rotateTilesNext();
        }
      }}
      );


    super.initState();
  }

  void updateGame(Game game){
    //TODO maybe catch chessmove diffrence the other way around
    if(game != null){
      List<ChessMove> newChessMoves = game.chessMoves.sublist(
          game.chessMoves.length - widget.boardState.chessMoves.length);
      for (ChessMove chessMove in newChessMoves) {
        PieceMover.movePieceTo(
            chessMove.initialTile, chessMove.nextTile, widget.boardState);
      }
      setState(() {});
    }
  }

  _moveWasMade(context){
    GameProvider gameProvider = Provider.of<GameProvider>(context, listen: false);
      gameProvider.sendMove(widget.boardState.chessMoves.last); //TODO make a timefull chessMove
  }

  @override
  Widget build(BuildContext context) {
    GameProvider gameProvider = Provider.of<GameProvider>(context);
    updateGame(gameProvider.game);
    return Provider.of<GameProvider>(context).game == null ?
    Center(child: Column(
      children: [
        Text("lodaing ... "),
        CircularProgressIndicator(),
      ],
    ))
        :
     Listener(
        onPointerDown: (details){
          String whatsHit = widget.tileKeeper.getTilePositionOf(details.localPosition);
          print(whatsHit);
          _startAMove(){
            highlighted = MapEntry(whatsHit,ThinkingBoard.getLegalMove(whatsHit, widget.boardState));
            draggedPiece = whatsHit;
            startingOffset = details.localPosition;
          }
          PlayerColor pieceColor = widget.boardState.pieces[whatsHit]?.playerColor;
          PlayerColor playingPlayer = Provider.of<GameProvider>(context, listen: false).player.playerColor;
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
                  PieceMover.movePieceTo(highlighted.key, whatsHit, widget.boardState);
                  _moveWasMade(context);
                highlighted = null;
              }
              else if(pieceColor == playingPlayer){
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
          String whatsHit = widget.tileKeeper.getTilePositionOf(details.localPosition);
          print(whatsHit);
            if (highlighted != null) {
              if(highlighted.value.contains(whatsHit)&& myTurn){
                  setState(() {
                    PieceMover.movePieceTo(highlighted.key, whatsHit, widget.boardState);
                    _moveWasMade(context);
                    highlighted = null;
                    draggedPiece = null;
                    dragOffset = null;
                  });
              }
              else if(whatsHit == draggedPiece){
                    draggedPiece = null;
                    dragOffset = null;
              }
              else{
                highlighted = null;
              }
            }
        },
        child: BoardPainter(
          pieces: widget.boardState.pieces,
          tiles: widget.tileKeeper.tiles,
          height: widget.height,
          width: widget.width,
          highlighted: highlighted?.value,
          pieceOffset: dragOffset,
          pieceOffsetKey: draggedPiece,
        ),
    );
  }
}
