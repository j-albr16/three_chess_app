import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class Logo extends StatelessWidget {
 final Size size;
  final String imagePath;
  final ThemeData theme;


Logo({this.size, this.imagePath, this.theme});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      // constraints: BoxConstraints(maxHeight: , maxWidth: , minHeight: , minWidth: ),
      margin: EdgeInsets.all(inMainBoxPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        // boxShadow: [
        //   BoxShadow(color: Colors.black38, offset: Offset(0, 2)),
        // ],
        border: Border.all(color: theme.colorScheme.onSurface, width: 2.4)
      ),
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}
