import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:poly/poly.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/painter/board_painter.dart';
import 'package:three_chess/providers/image_provider.dart';
import 'package:three_chess/providers/tile_select.dart';
import '../painter/piece_painter.dart';
import '../providers/piece_provider.dart';
import '../providers/tile_provider.dart';


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

  Widget _buildPieces(Point position) {
    return IgnorePointer(
      child: new CustomPaint(
        size: Size(position.x, position.y),
        painter: new PiecePainter(
          position: Point(0,200), // Point(-95, -120)
          pieces: Provider.of<PieceProvider>(context).pieces,
          tiles: Provider.of<TileProvider>(context, listen: false).tiles,
          images: Provider.of<ImageProv>(context, listen: false).images,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: !Provider.of<ImageProv>(context).isImagesloaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
            builder: (context, constraints){
              final maxHeight = 0.8 * MediaQuery.of(context).size.height;//constraints.maxHeight;
              final maxWidth = 0.85 * MediaQuery.of(context).size.width;//constraints.maxWidth;
              return SizedBox(
                height:  maxWidth,
                width: maxWidth,
                child: GestureDetector(
                    onTapDown: _handleTap,
                      child: Stack(
                        fit: StackFit.expand,
                    children: [
                         CustomPaint(
                           size: Size(maxWidth, maxWidth),
                           key: boardPaintKey,
                           painter: BoardPainter(context, Point(0,200)),
                      ),
                     _buildPieces(Point(maxWidth, maxWidth)),
                    ],
                  )),
              );}
          ),
    );
  }

  void _handleTap(TapDownDetails details){
    final RenderBox box = boardPaintKey.currentContext.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    Provider.of<TileSelect>(context, listen: false).setByPosition(context, localOffset);
  }
}
