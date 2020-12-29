import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import './basic/sorrounding_cart.dart';

class Count extends StatelessWidget {
  final Size size;
  final int player;
  final int users;
  final int games;
  final ThemeData theme;

  Count({this.size, this.theme, this.games, this.player, this.users});

  @override
  Widget build(BuildContext context) {
    return SorroundingCard(
      // height: size.height,
      theme: theme,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        infoKeys(),
        count(),
      ]),
    );
  }

  Widget count() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        infoKeyTile('$games'),
        infoKeyTile('$player'),
        infoKeyTile('$users'),
      ],
    );
  }

  Widget infoKeys() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        infoKeyTile('Active Games '),
        infoKeyTile('Active Player '),
        infoKeyTile('Online User '),
      ],
    );
  }

  Widget infoKeyTile(String text) {
    return Text(text, style: theme.textTheme.bodyText1);
  }
}
