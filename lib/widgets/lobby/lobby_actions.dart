import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:three_chess/screens/lobby_screen.dart';

import '../../helpers/constants.dart';
import '../basic/sorrounding_cart.dart';

const List<List<MapEntry>> quickParingButtons = [
  [
    MapEntry([2, 0], "Bullet"),
    MapEntry([5, 0], "Blitz"),
    MapEntry([10, 5], "Rapid")
  ],
  [
    MapEntry([2, 1], "Bullet"),
    MapEntry([5, 3], "Blitz"),
    MapEntry([15, 5], "Classic")
  ],
  [
    MapEntry([3, 0], "Blitz"),
    MapEntry([10, 0], "Rapid"),
    MapEntry([30, 5], "Classical")
  ]
];

class LobbyActions extends StatelessWidget {
  final StartQuickPairing startQuickPairing;

  LobbyActions({this.startQuickPairing});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return SurroundingCard(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.all(mainBoxPadding / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: size.width,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: quickParingButtons
                    .map((column) => Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: column
                              .map(
                                (child) => lobbyButton(
                                  figures: " ${child.key[0]} + ${child.key[1]}",
                                  size: size,
                                  description: child.value,
                                  buttonSize: Size(
                                      size.width * 0.25, size.height * 0.06),
                                  theme: theme,
                                  onTap: () => startQuickPairing(
                                      time: child.key[0],
                                      increment: child.key[1],
                                      context: context),
                                ),
                              )
                              .toList(),
                        ))
                    .toList()),
          ),
          Row(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              lobbyButton(
                figures: "Find a Game like",
                size: size,
                onTap: () => print("something"),
                theme: theme,
                color: theme.colorScheme.primary,
                buttonSize: Size(size.width * 0.3, size.height * 0.06),
              ),
              Container(width: size.width * 0.15, color: Colors.transparent),
              lobbyButton(
                figures: "Find me this Game",
                size: size,
                onTap: () => print("something"),
                color: theme.colorScheme.primary,
                theme: theme,
                buttonSize: Size(size.width * 0.3, size.height * 0.06),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget lobbyButton(
      {String figures,
      Size size,
      Color color,
      String description,
      Function onTap,
      Size buttonSize,
      ThemeData theme}) {
    onTap ??= () => print("noFunctionGiven");
    return FlatButton(
      onPressed: onTap,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(figures, style: theme.textTheme.bodyText2),
            if (description != null)
              Text(description,
                  style: theme.textTheme.overline
                      .copyWith(color: theme.colorScheme.onSecondary)),
          ],
        ),
      ),
      color: color ?? theme.colorScheme.secondary,
      height: buttonSize.height ?? size.height,
      minWidth: buttonSize.width ?? size.width,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius / 2))),
    );
  }

  _createGameTap(List<int> timeAndIncrement) {
    assert(timeAndIncrement.length == 2);
    int timeInMinutes = timeAndIncrement[0];
    int incrementInSeconds = timeAndIncrement[1];
    //TODO need to create a game with the given time and increment (public, rated)
  }
}
