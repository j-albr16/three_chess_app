import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class AcceptButton extends StatelessWidget {
  final Size size;
  final Function onAccept;
  final ThemeData theme;
  final Widget child;

  AcceptButton({this.child, this.theme, this.onAccept, this.size});

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
      height: size.height,
      width: size.width,
      child: InkWell(
        child: Card(
          color: Colors.green[600],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius / 2)),
          elevation: 4,
          child: Center(child: getChild),
        ),
        onTap: () => onAccept(),
      ),
    );
  }
}
