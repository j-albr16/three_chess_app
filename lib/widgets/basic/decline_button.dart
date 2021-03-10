import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class DeclineButton extends StatelessWidget {
  final Size size;
  final Function onDecline;
  final ThemeData theme;
  final Widget child;
  final EdgeInsets margin;

  DeclineButton({
    this.child,
    this.margin,
    this.theme,
    this.onDecline,
    this.size,
  });

  Widget get getChild {
    if (child != null) {
      return child;
    }

    return Text(
      'X',
      style: theme.textTheme.subtitle1.copyWith(
          color: Colors.white,
          shadows: [Shadow(offset: Offset(0, 2), color: Colors.black26)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: size.height,
      // width: size.width,
      child: InkWell(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 100,
          ),
          margin: margin,
          // margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius / 2),
            color: theme.colorScheme.error,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1, 0),
                  blurRadius: 2,
                  spreadRadius: 1),
            ],
          ),
          child: Center(
            child: getChild,
          ),
        ),
        onTap: () => onDecline(),
      ),
    );
  }
}
