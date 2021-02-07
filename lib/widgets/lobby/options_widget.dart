import 'package:flutter/material.dart';

import '../../models/online_game.dart';

class OptionsWidget extends StatelessWidget {
  final OnlineGame onlineGame;

  OptionsWidget({this.onlineGame});

  Map<String, String> get data {
    return {
      'Time': '${onlineGame.time}',
      'Increment': '${onlineGame.increment}',
      'Rating Range':
          '${onlineGame.negRatingRange} - ${onlineGame.posRatingRange}',
      'Allow Premades': '${onlineGame.allowPremades ?? true}',
      'Rated': '${onlineGame.isRated}'
    };
  }

  List<Widget> getWidgets(ThemeData theme, {bool keys = true}) {
    List<Widget> widgets = [];
    data.forEach((key, value) {
      widgets.add(Text(keys ? key : value, style: theme.textTheme.bodyText1));
    });
    return widgets;
  }

  Widget keys(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: getWidgets(theme),
    );
  }

  Widget values(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: getWidgets(theme, keys: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          keys(theme),
          values(theme),
        ],
      ),
    );
  }
}
