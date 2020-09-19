import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/painter/board_painter.dart';
import 'package:three_chess/providers/image_provider.dart';
import '../painter/piece_painter.dart';
import 'package:touchable/touchable.dart';
import '../providers/piece_provider.dart';
import '../models/piece.dart';
import '../providers/tile_provider.dart';

class BoardScreen extends StatelessWidget {
  static const routeName = '/board-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: 700,
        width: 700,
        // FutureBuilder(
        //   future: Provider.of<ImageProv>(context,listen: false).addImages(),
        //   builder: (context, snapshot) =>
        //
          child: Stack( children: [
              CanvasTouchDetector(builder: (context) {
                return CustomPaint(
                  painter: BoardPainter(context),
                );
              }),
              if (Provider.of<ImageProv>(context).isLoaded)
                CustomPaint(
                  size: Size(700,700),
                  painter: PiecePainter(
                    pieces: Provider.of<PieceProvider>(context).pieces,
                    tiles:
                    Provider.of<TileProvider>(context, listen: false).tiles,
                    images: Provider.of<ImageProv>(context, listen: false).images,
                  ),
                )
            ],
          ),

        ),

    );
  }
}
