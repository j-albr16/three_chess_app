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

import '../painter/piece_painter.dart';
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

  @override
  void initState() {
    super.initState();
  }

  Widget _linkTile(context, {Tile child, List<Tile> currentHighlight}) {
    return GestureDetector(
      child: child,
      onTap: () {
        Provider.of<TileSelect>(context, listen: false).setSelectedTo(child.id, context);
      },
    );
  }

  Widget _buildPiece(context, {Piece child}) {
    Map<String, Tile> tiles = Provider.of<TileProvider>(context, listen: false).tiles;
    return child.playerColor == Provider.of<PlayerProvider>(context).currentPlayer
        ? SizedBox(
            height: 1000,
            width: 1000,
            child: Stack(
              children: [
                //IgnorePointer(child: child),
                Draggable<String>(
                  child: child,
                  //     child: ClipPath(child:
                  //       Container(
                  //        width: double.infinity,
                  //        height: double.infinity,
                  //        color: Colors.black,
                  //     ),
                  //     clipper: PathClipper(path: tiles[child.position].path)),
                  feedback: Container(
                    child: Container(
                        height: ImageData.pieceSize.height * 2.6, //Diese spielerrei schiebt das Piece näher an die Maus
                        width: ImageData.pieceSize.width * 2.2, //Das aber abhängig vom ort des Pieces ungenau,
                        child: Align(
                          //Anderer Ansatz wäre ein Positioned Widget das auf die Maus Position hört
                          alignment: Alignment.bottomRight,
                          child: child,
                        )),
                  ),
                  childWhenDragging: Container(),
                  onDragStarted: () {
                    TileSelect tileSelect = Provider.of<TileSelect>(context, listen: false);
                    tileSelect.setSelectedTo(null, context);

                    tileSelect.setSelectedTo(child.position, context);
                    _isDragging = true;
                  },
                  onDragEnd: (_) {},
                  onDraggableCanceled: (velocity, Offset offset) {
                    _isDragging = false;
                  },
                ),
              ],
            ))
        : child;
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
            onPointerUp: (details) {
              TileSelect tileSelect = Provider.of<TileSelect>(context, listen: false);
              if (_isDragging && tileSelect.isMoveState) {
                _handleTapUp(details);
              }
            },
            child: SizedBox(
                //key: boardBoxKey,
                height: 1000,
                width: 1000,
                child: Stack(fit: StackFit.expand, children: [
                  ...Provider.of<TileProvider>(context)
                      .tiles
                      .values
                      .map((e) => GestureDetector(
                          child: e,
                          onTap: () {
                            Provider.of<TileSelect>(context, listen: false).setSelectedTo(e.id, context);
                          }))
                      .toList(),
                  ...Provider.of<PieceProvider>(context)
                      .pieces
                      .values
                      .map((e) => Positioned(
                            child: _buildPiece(context, child: e),
                            top: Provider.of<TileProvider>(context).tiles[e.position].middle.y - ImageData.pieceSize.height / 2,
                            left: Provider.of<TileProvider>(context).tiles[e.position].middle.x - ImageData.pieceSize.width / 2,
                          ))
                      .toList(),
                  ..._buildHighlights(currentHighlight),
                ]))),
      ),
    );
  }

  void _handleTapUp(PointerUpEvent details) {
    //final RenderBox box = boardBoxKey.currentContext.findRenderObject();
    final Offset localOffset = details.localPosition; //box.globalToLocal(details.position);
    Provider.of<TileSelect>(context, listen: false).setByPosition(context, localOffset);
  }
}
