import 'package:flutter/material.dart';
import 'package:relative_scale/relative_scale.dart';
import '../screens/friends_screen.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/auth_provider.dart';
import 'package:three_chess/providers/game_provider.dart';

import '../screens/board_screen.dart';
import '../screens/design-test-screen.dart';
import '../screens/auth_test_screen.dart';
import '../screens/lobby_screen.dart';
import '../screens/game_provider_test_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool boardClickable = Provider.of<GameProvider>(context).game != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
        menuItem('Chess Board Test', BoardScreen.routeName, context, clickable: boardClickable),
        menuItem('Design Test', DesignTestScreen.routeName, context),
        Consumer<AuthProvider>(
        builder: (context, auth, child) {
        return auth.isAuth
        ? Navigator.of(context).pushNamed(DesignTestScreen.routeName)
            : menuItem('Auth Test', AuthScreen.routeName, context);
        },
        ),
        menuItem('Lobby', LobbyScreen.routeName, context),
        menuItem('Game Test Screen', GameTestScreen.routeName, context),
        Container(
        height: 200,
        width: 200,
        child: GestureDetector(
        onTap: () => Provider.of<GameProvider>(context, listen: false).fetchGame(),
        child: Image.asset(
        'assets/pieces/bishop_black.png',
        fit: BoxFit.cover,
        ),
        ),
        ),
        menuItem('Friends Screen', FriendsScreen.routeName, context),
        ],
        ),
      ),
      );
  }
}

Widget menuItem(String title, String routeName, BuildContext context,{bool clickable = true}) {
  return GestureDetector(
    onTap: () { if(clickable){Navigator.of(context).pushNamed(routeName);}},
    child: Container(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: clickable ? Colors.blue : Colors.grey,
        border: Border.all(color: Colors.black87),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6.0,
          )
        ],
      ),
    ),
  );
}
