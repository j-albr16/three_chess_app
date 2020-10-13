import 'package:flutter/material.dart';
import 'package:three_chess/models/tile.dart';

class HighlightPainter extends CustomPainter {
  List<Tile> highlights;
  Map<String, Color> tileColor;
  HighlightPainter(this.highlights, {this.tileColor}) {
    for (String tile in highlights.map((e) => e.id).toList()) {
      tileColor[tile] ??= Color.fromRGBO(185, 205, 195, 0.33);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    print("HIGHLIGHTPAINTER DOES SOMETHING");
    Color lastColor = Color.fromRGBO(185, 205, 195, 0.33);
    Paint paint = Paint()..color = lastColor;
    for (Tile toHighlight in highlights) {
      if (lastColor != tileColor[toHighlight.id]) {
        paint.color = tileColor[toHighlight.id];
        lastColor = tileColor[toHighlight.id];
      }
      canvas.drawPath(toHighlight.path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
