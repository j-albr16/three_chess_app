import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/painter/board_painter.dart';
import 'package:three_chess/providers/image_provider.dart';
import '../painter/piece_painter.dart';
import 'package:touchable/touchable.dart';
import '../providers/piece_provider.dart';
import '../providers/tile_provider.dart';




class BoardScreen extends StatefulWidget {
  static const routeName = '/board-screen';

  @override
  _BoardScreenState createState() => _BoardScreenState();


}


class _BoardScreenState extends State<BoardScreen> {


  @override
  void initState() {
    super.initState();
  }

  Widget _buildPieces() {
      return IgnorePointer(
        child: new CustomPaint(
          painter: new PiecePainter(
            pieces: Provider
                .of<PieceProvider>(context)
                .pieces,
            tiles:
            Provider
                .of<TileProvider>(context, listen: false)
                .tiles,
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
          ? Center(child: CircularProgressIndicator(),)
          : SizedBox(
        height: 700,
        width: 700,
        child: Stack(children: [
          CanvasTouchDetector(builder: (context) {
            return CustomPaint(
              painter: BoardPainter(context),
            );
          }),
          _buildPieces(),
        ],
        ),

      ),
    );
  }
}
