import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:three_chess/providers/scroll_provider.dart';

import './screens/home_screen.dart';
import 'providers/chat_provider.dart';

import './screens/board_screen.dart';
import './screens/design-test-screen.dart';
import './providers/game_provider.dart';
import './providers/auth_provider.dart';
import './screens/auth_test_screen.dart';
import './screens/lobby_screen.dart';
import './screens/create_game_screen.dart';
import './screens/game_provider_test_screen.dart';
import './screens/friends_screen.dart';
import './screens/chat_screen.dart';
import './providers/friends_provider.dart';
import './providers/server_provider.dart';
import './providers/user_provider.dart';
import './screens/main_page_viewer.dart';

void main() => runApp(ThreeChessApp());

class ThreeChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, ServerProvider>(
            create: (_) => ServerProvider(),
            update: (_, auth, previousServer) => previousServer
              // ..update(
              //   token: auth.token,
              //   userId: auth.userId,
              // )
          ),
          ChangeNotifierProxyProvider<ServerProvider, GameProvider>(
            create: (_) => GameProvider(),
            update: (_, server, previousGame) => previousGame
              ..update(
                serverProvider: server,
                game: previousGame.game,
                games: previousGame.games,
              ),
          ),
          ChangeNotifierProxyProvider<ServerProvider, ChatProvider>(
            create: (_) => ChatProvider(),
            update: (_, server, previousChat) => previousChat
              ..update(
                serverProvider: server,
                chats: previousChat.chats,
                chatIndex: previousChat.currentChatIndex,
              ),
          ),
          ChangeNotifierProxyProvider2<ServerProvider,ChatProvider ,  FriendsProvider>(
            create: (_) => FriendsProvider(),
            update: (_, server,chat, previousFriends) => previousFriends
              ..update(
                chatProvider: chat,
                serverProvider: server,
                friends: previousFriends.friends,
              ),
          ),
          ChangeNotifierProxyProvider<ServerProvider, UserProvider>(
            create: (_) => UserProvider(),
            update: (_, server, previousUser) => previousUser
              ..update(
                user: previousUser.user,
              ),
          ),
          ChangeNotifierProvider<ScrollProvider>(
            create: (_) => ScrollProvider(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.deepPurpleAccent[300],
            errorColor: Colors.red[800],
            disabledColor: Colors.grey[800],
            primaryColorDark: Colors.black87,
          backgroundColor: Colors.white24,
            primaryColorLight: Colors.white70,
            focusColor: Colors.deepPurpleAccent[800],
            primaryTextTheme: TextTheme(
              bodyText1: TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal
              ),
              bodyText2: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
              headline1: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold
              ),
              headline2: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              subtitle1: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              ),
              subtitle2: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
            ),
          title: 'three chess app',
          home: MainPageViewer(),
          routes: {
            MainPageViewer.routeName: (ctx) => MainPageViewer(),
            BoardScreen.routeName: (ctx) => BoardScreen(),
            DesignTestScreen.routeName: (ctx) => DesignTestScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen(),
            CreateGameScreen.routeName: (ctx) => CreateGameScreen(),
            LobbyScreen.routeName: (ctx) => LobbyScreen(),
            GameTestScreen.routeName: (ctx) => GameTestScreen(),
            FriendsScreen.routeName: (ctx) => FriendsScreen(),
            ChatScreen.routeName: (ctx) => ChatScreen(),

          },
          // builder: (context, widget) => ResponsiveWrapper.builder(
          //     BouncingScrollWrapper.builder(context, widget),
          //     maxWidth: 2400,
          //     minWidth: 300,
          //     defaultScaleFactor: 0.212,
          //     defaultScale: true,
          //     breakpoints: [],
          //     background: Container(color: Color(0xFFF5F5F5))),
        ));
  }
}
