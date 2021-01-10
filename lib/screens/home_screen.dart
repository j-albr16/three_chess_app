import 'package:flutter/material.dart';
import 'package:three_chess/screens/invitation_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/basic/logo.dart';
import '../widgets/meta_data_count.dart';
import '../providers/online_provider.dart';
import '../widgets/report_error_dialog.dart';
import '../widgets/homescreen_action_buttons.dart';
import '../screens/auth_test_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
        ),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                title(theme),
                // SizedBox(height: 7),
                Divider(
                  thickness: 2,
                ),
                // SizedBox(height: 7),
                Logo(
                  size: Size(size.width * 0.7, size.height * 0.35),
                  imagePath: 'assets/logo.png',
                  theme: theme,
                ),
                countWidget(Size(size.width * 0.7, size.height * 0.1), theme),
                homeScreenButtons(size, theme, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget homeScreenButtons(
      Size size, ThemeData theme, BuildContext context) {
    final List<Map<String, dynamic>> buttonData = [
      {
        'callback': () =>
            Navigator.of(context).pushNamed(InvitationScreen.routeName),
        'title': 'Invitations',
        'icon': Icons.gamepad,
      },
      {
        'callback': () => Navigator.of(context).pushNamed(AuthScreen.routeName),
        'title': 'Auth Screen',
        'icon': Icons.person,
      },
      {
        'callback': () => sendErrorReport(size, context, theme),
        'title': 'Error Report',
        'icon': Icons.error,
      }
    ];
    return HomeScreenButtons(
      buttonData: buttonData,
      size: size,
      theme: theme,
    );
  }

  static sendErrorReport(Size size, BuildContext context, ThemeData theme) {
    return showDialog(
      context: context,
      builder: (context) {
        print(size.height);
        return ReportErrorDialog(
          size: Size(size.width * 0.9, size.height * 0.9),
          theme: theme,
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
