import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class AcceptButton extends StatelessWidget {
  final Size size;
  final Function onAccept;
  final ThemeData theme;
  final Widget child;
  final EdgeInsets margin;

  AcceptButton({
    this.child,
    this.theme,
    this.margin,
    this.onAccept,
    this.size,
  });

  Widget get getChild {
    if (child != null) {
      return child;
    }
    return Icon(
      Icons.check,
      color: theme.colorScheme.onError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: size.height,
      // width: size.width,
      child: InkWell(
        child: Container(
          margin: margin,
          constraints: BoxConstraints(
            maxWidth: 100,
          ),
          decoration: BoxDecoration(
            color:Colors.green[600] ,
            borderRadius: BorderRadius.circular(cornerRadius / 2),
            boxShadow: [  BoxShadow(
              color: Colors.grey,
              offset: Offset(1, 0),
              blurRadius: 2,
              spreadRadius: 1),],
          ),
          child: Center(child: getChild),
        ),
        onTap: () => onAccept(),
      ),
    );
  }
}
