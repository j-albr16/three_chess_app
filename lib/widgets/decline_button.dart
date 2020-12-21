import 'package:flutter/material.dart';

import '../helpers/constants.dart';

class DeclineButton extends StatelessWidget {
  final Size size;
  final Function onDecline;
  final ThemeData theme;

  DeclineButton({this.theme, this.onDecline, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.height,
      width: size.width,
      child: InkWell(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cornerRadius),
          ),
          color: theme.colorScheme.error,
          child: Center(
            child: Text(
              'X',
              style: theme.textTheme.subtitle2.copyWith(
                  color: Colors.white,
                  shadows: [
                    Shadow(offset: Offset(0, 2), color: Colors.black26)
                  ]),
            ),
          ),
        ),
        onTap: () => onDecline(),
      ),
    );
  }
}
