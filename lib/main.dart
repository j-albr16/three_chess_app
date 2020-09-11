import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

import 'BoardPainter.dart';

void main() => runApp(ThreeChessApp());

class ThreeChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Three Player Chess"),
        ),
        body: Board(),
      )
    );
  }
}
class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      width: 700,
      child: CanvasTouchDetector(
        builder: (context) {
           return CustomPaint(
            painter: BoardPainter(context),
          );}),

      );

  }
}



