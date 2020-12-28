import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class AcceptButton extends StatelessWidget {
  final Size size;
  final Function onAccept;
  final ThemeData theme;

  AcceptButton({this.theme, this.onAccept, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width ,
      child: InkWell(
        child: Card(
        color: Colors.green[600],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius)),
          elevation: 4,
          child: Icon(
            Icons.check,
            color: theme.colorScheme.onError,

          ),
        ),
        onTap: () => onAccept(),
      ),
    );
  }
}