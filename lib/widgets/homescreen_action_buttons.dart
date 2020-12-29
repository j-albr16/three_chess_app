import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../widgets/basic/sorrounding_cart.dart';

class HomeScreenButtons extends StatelessWidget {
  final List<Map<String, dynamic>> buttonData;
  final ThemeData theme;
  final Size size;

  HomeScreenButtons({
    this.buttonData,
    this.theme,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SorroundingCard(
      color: theme.colorScheme.secondary,
      child: homeScreenButtons(context, size, theme),
      theme: theme,
    );
  }

  Widget homeScreenButtons(BuildContext context, Size size, ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: buttonData
          .map((e) => gridButton(
                callback: e['callback'],
                size: Size(size.width, size.height),
                theme: theme,
                title: e['title'],
                icon: e['icon'],
              ))
          .toList(),
    );
  }

  static Widget gridButton(
      {String title,
      IconData icon,
      Function callback,
      ThemeData theme,
      Size size}) {
    return FlatButton(
      padding: EdgeInsets.all(1),
      onPressed: callback,
      child: buttonChild(title, theme, icon),
      // height: size.height,
      minWidth: size.width,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius))),
    );
  }

  static Widget buttonChild(String title, ThemeData theme, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 20),
        Icon(icon, color: theme.colorScheme.onSecondary,),
        SizedBox(width: 50),
        Text(
          title,
          style: theme.textTheme.bodyText1
              .copyWith(color: theme.colorScheme.onSecondary),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
