import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/providers/server_provider.dart';
import '../screens/friends_screen.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/auth_provider.dart';
import 'package:three_chess/providers/game_provider.dart';

import '../screens/board_screen.dart';
import '../screens/design-test-screen.dart';
import '../screens/auth_test_screen.dart';
import '../screens/lobby_screen.dart';
import '../screens/game_provider_test_screen.dart';
import '../helpers/constants.dart';
import '../widgets/text_field.dart';
import '../widgets/logo.dart';
import '../widgets/meta_data_count.dart';
import '../providers/online_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            title(theme),
            SizedBox(height: 20),
            Logo(
              size: Size(size.width * 0.7, size.height * 0.35),
              imagePath: 'assets/logo.png',
              theme: theme,
            ),
            SizedBox(height: 30),
            countWidget(Size(size.width * 0.7, size.height * 0.1), theme)
          ],
        ),
      ),
    );
  }

  Widget homeScreenButtons() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 2,
        crossAxisSpacing: 40,
        mainAxisSpacing: 40,
      ),
      children: [],
    );
  }

  Widget gridButton(
      {String title, Function callback, ThemeData theme, Size size}) {
    return FlatButton(
      onPressed: callback,
      child: Text(title,
          style: theme.textTheme.headline1
              .copyWith(color: theme.colorScheme.onSecondary)),
      height: size.height,
      minWidth: size.width,
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius))),
    );
  }

  static sendErrorReport(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          content: ChessTextField(),
          actions: [
            FlatButton(
                onPressed: () {
                  controller.dispose();
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            FlatButton(
                onPressed: () {
                  Provider.of<ServerProvider>(context, listen: false)
                      .sendErrorReport(controller.text);
                  controller.dispose();
                },
                child: Text('Submitt'))
          ],
        );
      },
    );
  }

  static Widget title(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Welcome to Three Chess Beta',
        style: theme.textTheme.headline1,
      ),
    );
  }

  static Widget countWidget(Size size, ThemeData theme) {
    return Consumer<OnlineProvider>(
      builder: (_, onlineProvider, __) => Count(
        size: size,
        theme: theme,
        games: onlineProvider.gamesCount,
        player: onlineProvider.playerCount,
        users: onlineProvider.usersCount,
      ),
    );
  }
}
