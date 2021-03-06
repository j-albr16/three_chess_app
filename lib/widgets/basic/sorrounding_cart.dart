import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class SurroundingCard extends StatelessWidget {
  @required
  final Widget child;
  final double height;
  final double width;
  final EdgeInsets padding;
  final Color color;
  final Color shadowColor;
  final EdgeInsets margin;
  final AlignmentGeometry alignment;

  SurroundingCard({
    this.alignment = Alignment.center,
    this.child,
    this.color,
    this.shadowColor = Colors.black26,
    this.height,
    this.margin = const EdgeInsets.symmetric(
        horizontal: mainBoxMargin, vertical: mainBoxMargin / 1.5),
    this.padding = const EdgeInsets.all(mainBoxPadding),
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color getColor;
    if (color == null) {
      getColor = theme.colorScheme.background;
    } else {
      getColor = color;
    }
    return Container(
      alignment: alignment,
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        color: getColor,
        boxShadow: [
          BoxShadow(
              color: shadowColor,
              offset: Offset(2, 0),
              blurRadius: 5,
              spreadRadius: 3),
        ],
      ),
      child: child,
      margin: margin,
      padding: padding,
    );
  }
}
