import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class Logo extends StatelessWidget {
 final Size size;
  final String imagePath;


Logo({this.size, this.imagePath});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      // constraints: BoxConstraints(maxHeight: , maxWidth: , minHeight: , minWidth: ),
      margin: EdgeInsets.all(inMainBoxPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: [
          BoxShadow(color: Colors.black38, offset: Offset(0, 2)),
        ],
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
