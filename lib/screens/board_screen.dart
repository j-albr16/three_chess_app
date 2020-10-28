import 'dart:html';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/helpers/hit_stack.dart';
import 'package:three_chess/painter/board_painter.dart';
import 'package:three_chess/painter/highlight_painter.dart';
import 'package:three_chess/providers/image_provider.dart';
import 'package:three_chess/providers/tile_select.dart';
import '../providers/piece_provider.dart';
import '../providers/tile_provider.dart';

import '../painter/path_clipper.dart';
import '../models/piece.dart';
import '../models/tile.dart';
import '../providers/piece_provider.dart';
import '../providers/tile_provider.dart';
import '../providers/player_provider.dart';
import '../models/tile.dart';
import '../data/image_data.dart';

class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  // GlobalKey boardBoxKey = GlobalKey();
  bool _isDragging = false;
  String _pieceOnDrag = null;
  Offset _startingPosition;
  Offset _deltaOffset = null;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<PlayerProvider>(context, listen: false).nextPlayer();
          Provider.of<TileProvider>(context, listen: false).rotateTilesNext();
        },
      ),
      appBar: AppBar(),
      body: Container(
        //alignment: Alignment.center,
        child: Listener(
            onPointerDown: (details) {
              TileSelect tileSelect = Provider.of<TileSelect>(context, listen: false);
              String whatsHit = _getPieceAtPointerDown(details);
              if (whatsHit != null) {
                if (!tileSelect.isMoveState) {
                  _isDragging = true;
                  _pieceOnDrag = whatsHit;
                  _startingPosition = details.localPosition;
                  tileSelect.goIntoMoveState(whatsHit, context);
                } else {
                  tileSelect.endMoveState(whatsHit, context);
                  Piece currentPiece = Provider.of<PieceProvider>(context, listen: false).pieces[whatsHit];
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
                  ...Provider.of<PieceProvider>(context).pieces.values.map((e) {
                    Offset myOffset = Offset(0, 0);
                    if (_isDragging && _pieceOnDrag == e.position && _deltaOffset != null) {
                      myOffset = _deltaOffset;
                    }
                    return Positioned(
                      child: IgnorePointer(child: _buildPiece(context, child: e)),
                      top:
                          Provider.of<TileProvider>(context).tiles[e.position].middle.y - ImageData.pieceSize.height / 2 + myOffset.dy,
                      left:
                          Provider.of<TileProvider>(context).tiles[e.position].middle.x - ImageData.pieceSize.width / 2 + myOffset.dx,
                    );
                  }).toList(),
                ]))),
      ),
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
