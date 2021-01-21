import 'package:flutter/material.dart';

class ChessDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Divider(
      thickness: 2,
      color: theme.colorScheme.background != Colors.black
          ? Colors.black26
          : Colors.white,
    );
  }
}
