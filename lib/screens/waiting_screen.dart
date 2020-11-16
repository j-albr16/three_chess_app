import 'package:flutter/material.dart';
import 'package:three_chess/helpers/path_clipper.dart';

class WaitingScreen extends StatelessWidget {
  static const routeName = '/WaitingScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(children: [
        Positioned(
          top: 10,
            left: 10,
            child: CornerTile.unknown(startingOffset: Offset(0,0), scaleFactor: 30, isCornerLeft: true, borderWidth: 2,)),
        Positioned
          (
          top: 10,
            right: 10,
            child:CornerTile.unknown(startingOffset: Offset(0,0), scaleFactor: 30, isCornerLeft: false, borderWidth: 2)),
        // Container(
        //   width: 200,
        //   height: 400,
        //   color: Colors.black,
        // )
      ],),
    );
  }
}


class CornerTile extends StatelessWidget {
  bool isCornerLeft;
  bool isOnline;
  String username;
  int score;
  bool isKnown;
  double scaleFactor;
  Offset startingOffset;
  double borderWidth;

  CornerTile({@required this.isOnline, @required this.username, @required this.isCornerLeft, @required this.score, @required this.startingOffset, this.scaleFactor = 1, this.borderWidth = 1}) {
    isKnown = true;
  }

  CornerTile.unknown({@required this.startingOffset, this.scaleFactor = 1, @required this.isCornerLeft, this.borderWidth = 1}){
    isKnown = false;
  }

  @override
  Widget build(BuildContext context) {
    double i = 1;
    double helper = isCornerLeft ? 0 : 10*scaleFactor;

    if(!isCornerLeft){
      i = -1;
    }
    Path path = Path()
    ..moveTo(0 + startingOffset.dx + helper, 0 + startingOffset.dy)
    ..relativeLineTo(10 * i  * scaleFactor  , 0)
    ..relativeLineTo(0                   , 2 * scaleFactor)
    ..relativeLineTo(-8 * i * scaleFactor, 4 * scaleFactor)
    ..relativeLineTo(-2 * i * scaleFactor, 0)
    ..relativeLineTo(0                   , -6 * scaleFactor);
    return Stack(
      children: [

        ClipPath(
          child:

          Container(
            width: 10 * scaleFactor,
            height: 6 * scaleFactor,
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
