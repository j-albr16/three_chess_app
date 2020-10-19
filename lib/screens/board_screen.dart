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
  GlobalKey boardPaintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildDraggables(List<Piece> pieces, Map<String, Tile> tiles, context) {
    List<Draggable> draggables = [];
    pieces.where((element) => element.playerColor == Provider.of<PlayerProvider>(context, listen: false).currentPlayer,).forEach((element) {
      draggables.add(Draggable(
        child: Container(child: ClipPath(child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent,), clipper: PathClipper(path: tiles[element.position].path))),
        feedback: Container(
            child: Image.asset(ImageData.assetPaths[element.pieceKey],
              alignment: Alignment.center,
             // width: Provider.of<ImageProv>(context, listen: false).size.width,
             //  height: Provider.of<ImageProv>(context, listen: false).size.height,
            ),
          ),
        childWhenDragging: Container(),
        onDragStarted: () {
          Provider.of<PieceProvider>(context, listen: false).switchInvis(element, true);
          Provider.of<TileSelect>(context, listen: false).setSelectedTo(element.position, context);
        },
        onDragEnd: (_) {
          Provider.of<PieceProvider>(context, listen: false).switchInvis(element, false);
        },
        onDraggableCanceled: (__, _) {
          Provider.of<PieceProvider>(context, listen: false).switchInvis(element, false);
        },
      ));
    });
    return draggables;
  }

  List<Widget> _buildDragTargets(List<Tile> viableTiles, context, List<Piece> pieces) {
    return [
      ...viableTiles.map((e) => DragTarget(
            builder: (context, List<int> candidateData, rejectedData) {
              return ClipPath(child: Container(width: double.infinity, height: double.infinity,), clipper: PathClipper(path: e.path));
            },
            onWillAccept: (_) {
              return true;
            },
            onAccept: (_) {
              Provider.of<TileSelect>(context).setSelectedTo(e.id, context);
            },
          ))
    ];
  }

  Widget _buildPieces() {
    List<Piece> pieces = Provider.of<PieceProvider>(context).pieces;
    Map<String, Tile> tiles = Provider.of<TileProvider>(context, listen: false).tiles;
    return IgnorePointer(
      child: new CustomPaint(
        size: Size(1000, 1000),
        painter: new PiecePainter(
          imageProvSize: Provider.of<ImageProv>(context, listen: false).size,
          pieces: pieces,
          tiles: tiles,
          images: Provider.of<ImageProv>(context, listen: false).images,
        ),
      ),
    );
  }

  Widget _buildHighlighter(List<Tile> currentHighlight) {
    return currentHighlight == null
        ? Container()
        : CustomPaint(
            painter: HighlightPainter(currentHighlight),
          );
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
      body: !Provider.of<ImageProv>(context).isImagesLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              //alignment: Alignment.center,
              child: SizedBox(
                height: 1000,
                width: 1000,
                child: GestureDetector(
                    onTapDown: _handleTap,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CustomPaint(
                          key: boardPaintKey,
                          painter: BoardPainter(Provider.of<TileProvider>(context).tiles, context),
                        ),
                        _buildHighlighter(currentHighlight),
                        _buildPieces(),
                        ..._buildDraggables(
                            Provider.of<PieceProvider>(context).pieces, Provider.of<TileProvider>(context).tiles, context),
                        if (Provider.of<TileSelect>(context).currentHighlight != null)
                          ..._buildDragTargets(
                              Provider.of<TileSelect>(context).currentHighlight, context, Provider.of<PieceProvider>(context).pieces)
                      ],
                    )),
              ),
            ),
    );
  }

  void _handleTap(TapDownDetails details) {
    final RenderBox box = boardPaintKey.currentContext.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    Provider.of<TileSelect>(context, listen: false).setByPosition(context, localOffset);
  }
}
