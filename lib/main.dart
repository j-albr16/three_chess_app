import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import './screens/home_screen.dart';
import './providers/chat_provider.dart';

import './screens/board_screen.dart';
import './screens/design-test-screen.dart';
import './providers/game_provider.dart';
import './providers/auth_provider.dart';
import './screens/auth_test_screen.dart';
import './screens/lobby_screen.dart';
import './screens/create_game_screen.dart';
import './screens/game_provider_test_screen.dart';
import './screens/friends_screen.dart';

void main() => runApp(ThreeChessApp());

class ThreeChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, GameProvider>(
              create: (_) => GameProvider(),
              update: (_, auth, previousGame) =>
                  previousGame /*..update(auth.userId, auth.token, previousGame.game, previousGame.games)*/),
          ChangeNotifierProvider(create: (ctx) => ChatProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(primaryColor: Colors.blueAccent),
          title: 'three chess app',
          home: HomeScreen(),
          routes: {
            BoardScreen.routeName: (ctx) => BoardScreen(),
            DesignTestScreen.routeName: (ctx) => DesignTestScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            CreateGameScreen.routeName: (ctx) => CreateGameScreen(),
            LobbyScreen.routeName: (ctx) => LobbyScreen(),
            GameTestScreen.routeName: (ctx) => GameTestScreen(),
            FriendsScreen.routeName: (ctx) => FriendsScreen(),
          },
          builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget),
              maxWidth: 2400,
              minWidth: 300,
              defaultScaleFactor: 0.212,
              defaultScale: true,
              breakpoints: [],
              background: Container(color: Color(0xFFF5F5F5))),
        ));
  }
}
