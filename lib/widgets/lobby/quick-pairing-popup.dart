import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/online_provider.dart';

class QuickPairingPopUp extends StatelessWidget {
  final int time;
  final int increment;

  QuickPairingPopUp({this.increment, this.time});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SimpleDialog(
          title: Text('Quick Pairing',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline2
                  .copyWith(color: theme.colorScheme.onSecondary)),
          children: [
            Text('$time + $increment',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyText1
                    .copyWith(color: theme.colorScheme.onSecondary)),
            Consumer<OnlineProvider>(
              builder: (context, onlineProvider , child) =>
               Text('${onlineProvider.possibleMatches} possible Matches',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText1
                      .copyWith(color: theme.colorScheme.onSecondary)),
            ),
          ],
          backgroundColor: theme.colorScheme.secondary,
        ));
  }
}
