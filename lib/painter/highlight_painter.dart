import 'package:flutter/material.dart';
import 'package:three_chess/models/tile.dart';

class HighlightPainter extends CustomPainter {
  List<Tile> highlights;

  HighlightPainter(this.highlights);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    //..colorFilter = ColorFilter.mode(Color.fromRGBO(255, 255, 255, 1), BlendMode.overlay);
    ..color = Color.fromRGBO(185, 205, 195, 0.33);
    print("HIGHLIGHTPAINTER DOES SOMETHING");
    for (Tile toHighlight in highlights) {
     // paint.color = toHighlight.isWhite ? Colors.grey : Colors.brown;
      canvas.drawPath(toHighlight.path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
