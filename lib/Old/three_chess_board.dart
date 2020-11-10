import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:three_chess/providers/thinking_board.dart';
import 'package:three_chess/providers/tile_select.dart';

import 'package:three_chess/providers/tile_provider.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/models/game.dart';
import 'package:three_chess/providers/image_provider.dart';
import 'package:three_chess/providers/player_provider.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:flutter/gestures.dart';
import '../providers/piece_provider.dart';
import '../providers/tile_provider.dart';

import '../painter/path_clipper.dart';
import '../models/piece.dart';
import '../models/tile.dart';
import '../models/game.dart';
import '../providers/player_provider.dart';
import '../data/image_data.dart';

class ThreeChessBoard extends StatelessWidget {
  GlobalKey boardKey = GlobalKey();

  GameProvider get gameProviderListner {
    return Provider.of<GameProvider>(boardKey.currentContext);
  }

  GameProvider get gameProvider {
    return Provider.of<GameProvider>(boardKey.currentContext, listen: false);
  }

  //ThreeChessBoard(
  // @required Game game); //Game has to be loaded, so the chessmoves list must be put into a board state without visual glithcing

  ThreeChessBoard();

  @override
  Widget build(context) => MultiProvider(providers: [
        ChangeNotifierProvider(create: (ctx) => TileProvider()),
        ChangeNotifierProvider(create: (ctx) => PieceProvider()),
        ChangeNotifierProvider(create: (ctx) => ImageProv()),
        ChangeNotifierProvider(create: (ctx) => PlayerProvider()),
        ChangeNotifierProvider(create: (ctx) => ThinkingBoard()),
        ChangeNotifierProvider(create: (ctx) => TileSelect()),
      ], child: ThreeChessInnerBoard(key: boardKey));
}

class ThreeChessInnerBoard extends StatefulWidget {
  final Key key;
  ThreeChessInnerBoard({this.key}) : super(key: key);
  @override
  ThreeChessInnerBoardState createState() => ThreeChessInnerBoardState();
}

class ThreeChessInnerBoardState extends State<ThreeChessInnerBoard> {
  // GlobalKey boardBoxKey = GlobalKey();
  bool _boardIsLoaded = false;
  bool _waitForServerMove = false;
  bool _isDragging = false;
  String _pieceOnDrag;
  Offset _startingPosition;
  Offset _deltaOffset;
  bool didstart = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      //Provider.of<GameProvider>(context, listen: false).fetchGame()
    PieceProvider pieceProvider = Provider.of<PieceProvider>(context, listen: false);
    pieceProvider.startGame();});
    super.initState();
  }

  void setUpChessMoves(context, List<ChessMove> chessMoves) {
    PlayerColor currentPlayer = PlayerColor.white;
    PieceProvider pieceProvider = Provider.of<PieceProvider>(context, listen: false).startGame(noNotify: true);
    bool notValid = false;
    int i = 0;
    for (ChessMove chessMove in chessMoves) {
      i++;
      if (Provider.of<ThinkingBoard>(context, listen: false)
          .getLegalMove(
              chessMove.initialTile,
              MapEntry(pieceProvider.pieces[chessMove.initialTile].pieceType, currentPlayer),
              context)
          .contains(chessMove.nextTile)) {
        pieceProvider
            .movePieceTo(chessMove.initialTile, chessMove.nextTile, noNotify: i == chessMoves.length ? false : true);
      } else {
        notValid = true;
        break;
      }

      currentPlayer = PlayerColor.values[(currentPlayer.index + 1) % 3];
    }
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context, listen: false);
    GameProvider gameProvider = Provider.of<GameProvider>(context);

    playerProvider.currentPlayer = currentPlayer;
    playerProvider.nextPlayer();
    if (playerProvider.currentPlayer != gameProvider.player.playerColor) {
      _waitForServerMove = true;
    } else {
      _waitForServerMove = false;
    }
  }

  Widget _buildPiece(context, {Piece child}) {
    return child;
  }

  List<Widget> _buildHighlights(List<Tile> currentHighlight) {
    if (currentHighlight != null && currentHighlight.isNotEmpty) {
      return currentHighlight.map((e) {
        return IgnorePointer(
            child: ClipPath(
          child: Container(
            color: Color.fromRGBO(30, 60, 140, 0.5),
          ),
          clipper: PathClipper(path: e.path),
        ));
      }).toList();
    }
    return [Container()];
  }

  @override
  Widget build(BuildContext context) {
    List<Tile> currentHighlight = Provider.of<TileSelect>(context).currentHighlight;
    PlayerProvider playerProvider = Provider.of<PlayerProvider>(context);
    PieceProvider pieceProvider = Provider.of<PieceProvider>(context, listen: false);



    GameProvider gameProvider = Provider.of<GameProvider>(context);
    Game game = gameProvider.game;
    if(didstart){
      gameProvider.fetchGame();
      didstart = true;
    }
    
    if (gameProvider.game != null) {
      if (game.chessMoves.length > pieceProvider.doneChessMoves.length) {
        ChessMove chessMove = game.chessMoves.last; //JUST ONE AT THE TIME IS POSSIBLE
        pieceProvider.movePieceTo(chessMove.initialTile, chessMove.nextTile);
        playerProvider.nextPlayer();
        //
        // ,0,playerProvider.updateGathered(context);
        if (playerProvider.currentPlayer == gameProvider.player.playerColor) {
          _waitForServerMove = false;
        } else {
          _waitForServerMove = true;
        }
      }
      if (game.chessMoves.isNotEmpty && !_boardIsLoaded) {
        setUpChessMoves(context, game.chessMoves);
        _boardIsLoaded = true;
      }
    }

    return gameProvider.game == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            //alignment: Alignment.center,
            child: Listener(
                onPointerDown: (details) {
                  print("at least i was clicked down");
                  TileSelect tileSelect = Provider.of<TileSelect>(context, listen: false);
                  String whatsHit = _getPieceAtPointerDown(details);
                  if (whatsHit != null) {
                    if (!tileSelect.isMoveState) {
                      if (pieceProvider.pieces[whatsHit]?.playerColor ==
                              gameProvider.player.playerColor &&
                          !_waitForServerMove) {
                        _isDragging = true;
                        _pieceOnDrag = whatsHit;
                        _startingPosition = details.localPosition;
                        tileSelect.goIntoMoveState(whatsHit, context);
                      }
                    } else {
                      tileSelect.endMoveState(whatsHit, context);
                      Piece currentPiece = pieceProvider.pieces[whatsHit];
                      if (currentPiece != null &&
                          currentPiece.playerColor == Provider.of<PlayerProvider>(context, listen: false).currentPlayer) {
                        // tileSelect.goIntoMoveState(whatsHit, context);
                      }
                    }
                  }
                },
                onPointerMove: (details) {
                  if (_isDragging) {
                    setState(() {
                      _deltaOffset =
                          Offset(details.localPosition.dx - _startingPosition.dx, details.localPosition.dy - _startingPosition.dy);
                    });
                  }
                },
                onPointerUp: (details) {
                  TileSelect tileSelect = Provider.of<TileSelect>(context, listen: false);
                  if (_isDragging && tileSelect.isMoveState) {
                    String whatsHit = _getPieceAtPointerUp(details);
                    bool tap = false;
                    if (tileSelect.selectedTile == whatsHit) {
                      tap = true;
                    }
                    tileSelect.endMoveState(whatsHit, context);
                    if (tap) {
                      tileSelect.goIntoMoveState(whatsHit, context);
                    }
                  }
                  _pieceOnDrag = null;
                  setState(() {
                    _deltaOffset = null;
                  });
                  _isDragging = false;
                },
                child: SizedBox(
                    //key: boardBoxKey,
                    height: 1000,
                    width: 1000,
                    child: Stack(fit: StackFit.expand, children: [
                      //The Stack of Tiles, Highlighter and Piece
                      ...Provider.of<TileProvider>(context).tiles.values.toList(),
                      ..._buildHighlights(currentHighlight),
                      ...pieceProvider.pieces.values.map((e) {
                        Offset myOffset = Offset(0, 0);
                        if (_isDragging && _pieceOnDrag == e.position && _deltaOffset != null) {
                          myOffset = _deltaOffset;
                        }
                        return Positioned(
                          child: IgnorePointer(child: _buildPiece(context, child: e)),
                          top: Provider.of<TileProvider>(context).tiles[e.position].middle.y -
                              ImageData.pieceSize.height / 2 +
                              myOffset.dy,
                          left: Provider.of<TileProvider>(context).tiles[e.position].middle.x -
                              ImageData.pieceSize.width / 2 +
                              myOffset.dx,
                        );
                      }).toList(),
                    ]))),
          );
  }

  void _handleTapUp(PointerUpEvent details) {
    //final RenderBox box = boardBoxKey.currentContext.findRenderObject();
    final Offset localOffset = details.localPosition; //box.globalToLocal(details.position);
    String whatsHit = Provider.of<TileSelect>(context, listen: false).getPieceAtPosition(context, localOffset);

    Provider.of<TileSelect>(context, listen: false).endMoveState(whatsHit, context);
  }

  String _getPieceAtPointerDown(PointerDownEvent details) {
    //final RenderBox box = boardBoxKey.currentContext.findRenderObject();
    final Offset localOffset = details.localPosition; //box.globalToLocal(details.position);
    return Provider.of<TileSelect>(context, listen: false).getPieceAtPosition(context, localOffset);
  }

  String _getPieceAtPointerUp(PointerUpEvent details) {
    //final RenderBox box = boardBoxKey.currentContext.findRenderObject();
    final Offset localOffset = details.localPosition; //box.globalToLocal(details.position);
    return Provider.of<TileSelect>(context, listen: false).getPieceAtPosition(context, localOffset);
  }
}