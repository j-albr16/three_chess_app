import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../providers/online_provider.dart';

class QuickPairingPopUp extends StatelessWidget {
  final int time;
  final int increment;
  final Timer _timer = new Timer.periodic(Duration(seconds: 1), (timer) {});

  QuickPairingPopUp({this.increment, this.time});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: SimpleDialog(
          insetPadding: EdgeInsets.all(15),
          contentPadding: EdgeInsets.all(15),
          title: Text('Quick Pairing',
              textAlign: TextAlign.center,
              style: theme.textTheme.headline2
                  .copyWith(color: theme.colorScheme.onSecondary)),
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Text('$time + $increment',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText1
                      .copyWith(color: theme.colorScheme.onSecondary)),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Consumer<OnlineProvider>(
                builder: (context, onlineProvider, child) => Text(
                    '${onlineProvider.possibleMatches} possible Matches',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyText1
                        .copyWith(color: theme.colorScheme.onSecondary)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<OnlineProvider>(
                      builder: (context, onlineProvider, child) {
                    String minString = ((onlineProvider.stopWatch / 60) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    String secString = ((onlineProvider.stopWatch) % 60)
                        .floor()
                        .toString()
                        .padLeft(2, '0');
                    return Text('$minString:$secString',
                        style: theme.textTheme.bodyText1
                            .copyWith(color: theme.colorScheme.onSecondary));
                  }),
                  SizedBox(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                          backgroundColor: theme.colorScheme.onSecondary)),
                ],
              ),
            ),
          ],
          backgroundColor: theme.colorScheme.secondary,
        ));
  }
}
