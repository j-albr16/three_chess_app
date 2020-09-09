import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

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
    return CanvasTouchDetector(
      builder: (ctx) =>
        CustomPaint(
        size: Size(double.infinity, double.infinity),
          painter: BoardPainter(),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
