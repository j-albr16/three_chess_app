import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class SorroundingCard extends StatelessWidget {
  @required
  final Widget child;
  @required
  final ThemeData theme;

  final double height;
  final double maxWidth;
  final double width;
  final EdgeInsets padding;
  final Color color;
  final EdgeInsets margin;
  final AlignmentGeometry alignment;

  Color get getColor{
    if(color != null){
      return color;
    }
    return theme.colorScheme.background;
  }

  SorroundingCard({
    this.alignment = Alignment.center,
    this.child,
    this.color,
    this.maxWidth = 500,
    this.height,
    this.margin = const EdgeInsets.symmetric(horizontal: mainBoxMargin, vertical: mainBoxMargin / 1.5),
    this.padding = const EdgeInsets.all(mainBoxPadding),
    this.theme,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        color: getColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 0),
              blurRadius: 5,
              spreadRadius: 3),
        ],
      ),
      child: child,
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: margin,
      padding: padding,
    );
  }
}
