import 'package:flutter/material.dart';
import 'package:three_chess/helpers/path_clipper.dart';


class CornerTile extends StatelessWidget {
  final bool isCornerLeft;
  bool isOnline;
  String username;
  int score;
  final double startY;
  final double borderWidth;
  final double cutOfLength;
  bool isKnown;

  CornerTile({@required this.isOnline, @required this.username, @required this.isCornerLeft, @required this.score, this.cutOfLength, this.startY , this.borderWidth = 1, this.isKnown = true});

  CornerTile.unknown({this.startY, this.cutOfLength, @required this.isCornerLeft, this.borderWidth = 1}){
    isKnown = false;
  }

  @override
  Widget build(BuildContext context) {

    //TODO MIRROR
    double shortSideLength = startY - (cutOfLength * 1.732);
    double longSideLength = shortSideLength * (2 / (1.732 * 2));

    double i = 1;
    double helper = isCornerLeft ? 0 : longSideLength;

    if(!isCornerLeft){
      i = -1;
    }

    // Path path = Path()
    //   ..moveTo(0 + helper, 0 )
    //   ..relativeLineTo(10 * i  * scaleFactor  , 0)
    //   ..relativeLineTo(0                   , 2 * scaleFactor)
    //   ..relativeLineTo(-8 * i * scaleFactor, 4 * scaleFactor)
    //   ..relativeLineTo(-2 * i * scaleFactor, 0)
    //   ..relativeLineTo(0                   , -6 * scaleFactor);

    Path path = Path()
    ..moveTo(0 , 0)
      ..relativeLineTo(0, shortSideLength)
      ..relativeLineTo(cutOfLength * i, 0)
      ..relativeLineTo(longSideLength * i,-(shortSideLength-cutOfLength))
      ..relativeLineTo(0, -cutOfLength)
      ..relativeLineTo(-longSideLength * i,0);

    return Stack(
      children: [

        ClipPath(
          child:

          Container(
            width: longSideLength,
            height: shortSideLength,
            //decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
            color: Colors.transparent,
            child: Align(
              alignment: isCornerLeft ? Alignment.topLeft  : Alignment.topRight,
              child: Container(
                child: isKnown ? Column(
                  children: [
                    Row(children: [
                      Icon(
                        isOnline ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: Colors.green,
                      ),
                      Text(username),
                    ],),
                    Text(score.toString()),
                  ],
                ) :
                Container(
                    padding: isCornerLeft ? EdgeInsets.only(top: 5, left: 20) : EdgeInsets.only(top: 5, right: 20),
                    child: Text("?", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, ),)),
              ),
            ),
          ),
          clipper: PathClipper(path: path),
        ),
        CustomPaint(
          painter: BorderPainter(path: path, width: borderWidth, color: Colors.black),
        ),
      ],
    );


  }
}

class BorderPainter extends CustomPainter{
  final Path path;
  final double width;
  final Color color;

  BorderPainter({@required this.path, @required this.width, @required this.color});


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;
}
