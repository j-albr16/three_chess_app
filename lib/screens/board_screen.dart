import 'package:flutter/material.dart';
import 'package:three_chess/board_painter.dart';
import 'package:touchable/touchable.dart';

class BoardScreen extends StatelessWidget {
  static const routeName = '/board-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: 700,
        width: 700,
        child: CanvasTouchDetector(
            builder: (context) {
              return CustomPaint(
                painter: BoardPainter(context),
              );}),

      ),
    );

  }
}