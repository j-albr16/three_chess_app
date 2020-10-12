import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/painter/board_painter.dart';
import 'package:three_chess/painter/highlight_painter.dart';
import 'package:three_chess/providers/image_provider.dart';
import 'package:three_chess/providers/tile_select.dart';

import '../painter/piece_painter.dart';
import '../providers/piece_provider.dart';
import '../providers/tile_provider.dart';
import '../models/tile.dart';

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

  Widget _buildPieces() {
    return IgnorePointer(
      child: new CustomPaint(
        size: Size(1000, 1000),
        painter: new PiecePainter(
          imageProvSize: Provider.of<ImageProv>(context, listen: false).size,
          pieces: Provider.of<PieceProvider>(context).pieces,
          tiles: Provider.of<TileProvider>(context, listen: false).tiles,
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
    List<Tile> currentHighlight = Provider.of<TileSelect>(context).currentHightlight;
    return Scaffold(
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
                          painter: BoardPainter(context),
                        ),
                        _buildHighlighter(currentHighlight), //[Provider.of<TileProvider>(context, listen: false).tiles.values.firstWhere((element) => element.id == "A3")]
                        _buildPieces(),
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
