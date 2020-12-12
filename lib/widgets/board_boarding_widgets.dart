import 'package:flutter/material.dart';
import 'package:three_chess/helpers/path_clipper.dart';

enum Corner{ topLeft, topRight, bottomLeft, bottomRight}
class CornerTile extends StatelessWidget {
  final Corner whereIsCorner;
  final double startY;
  final double borderWidth;
  final double cutOfLength;
  final Widget child;
  final bool alignCenter;
  final Function onTap;

  CornerTile({this.alignCenter = false, this.startY, this.whereIsCorner, this.cutOfLength, this.borderWidth = 1, this.child, this.onTap});

  @override
  Widget build(BuildContext context) {

    //TODO MIRROR
    double shortSideLength = startY - (cutOfLength * 1.732);
    double longSideLength = shortSideLength * (2 / (1.732 * 2));

    double xTurn = 1;
    double yTurn = 1;
    double helperX = 0;
    double helperY = 0;
    Alignment alignment;

    switch(whereIsCorner){
      case Corner.topLeft:
        alignment = Alignment.topLeft;
        break;
      case Corner.topRight:
        alignment = Alignment.topRight;
        xTurn = -1;
        helperX = longSideLength;
        break;
      case Corner.bottomLeft:
        alignment = Alignment.bottomLeft;
        yTurn = -1;
        helperY = shortSideLength;
        break;
      case Corner.bottomRight:
        alignment = Alignment.bottomRight;
        yTurn = -1;
        helperY = shortSideLength;
        
        xTurn = -1;
        helperX = longSideLength;
        break;
    }
    if(alignCenter){
      alignment = Alignment.center;
    }
    
    Path path = Path()
    ..moveTo(0 +helperX, 0 + helperY)
      ..relativeLineTo(0, shortSideLength * yTurn)
      ..relativeLineTo(cutOfLength * xTurn, 0)
      ..relativeLineTo(longSideLength * xTurn,-(shortSideLength-cutOfLength) * yTurn)
      ..relativeLineTo(0, -cutOfLength * yTurn)
      ..relativeLineTo(-longSideLength * xTurn,0);

    return Stack(
      children: [

        GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: onTap ?? () {},
          child: ClipPath(
            child:

            Container(
            width: longSideLength,
            height: shortSideLength,
            //decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
            color: Colors.transparent,
            child: Align(
              alignment: alignment,
              child: child,)),
            clipper: PathClipper(path: path),
          ),
        ),
        CustomPaint(
          painter: BorderPainter(path: path, width: borderWidth, color: Colors.black),
        ),
      ],
    );


  }
}

class PlayerTile extends StatelessWidget {
  final bool isCornerLeft;
  final bool isOnline;
  final String username;
  final int score;
  final double startY;
  final double borderWidth;
  final double cutOfLength;
  final bool isKnown;

  PlayerTile({@required this.isOnline, @required this.username, @required this.isCornerLeft, @required this.score, this.cutOfLength, this.startY , this.borderWidth = 1, this.isKnown = true});



  @override
  Widget build(BuildContext context) {

    return CornerTile(
      cutOfLength: cutOfLength,
          borderWidth: borderWidth,
          whereIsCorner: isCornerLeft ? Corner.topLeft : Corner.topRight,
          startY: startY,
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
    );
  }
  
  
}class ActionTile extends StatelessWidget {
  final bool isCornerLeft;
  final double startY;
  final double borderWidth;
  final double cutOfLength;
  final Function onTap;
  final Widget icon;

  ActionTile({@required this.isCornerLeft, this.cutOfLength, this.startY , this.borderWidth = 1, this.onTap, this.icon});



  @override
  Widget build(BuildContext context) {

    return CornerTile(
      onTap: onTap,
        alignCenter: false,
          cutOfLength: cutOfLength,
              borderWidth: borderWidth,
              whereIsCorner: isCornerLeft ? Corner.bottomLeft : Corner.bottomRight,
              startY: startY,
                child: Container(
                    child: IgnorePointer(child: icon,),
                  ),
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
