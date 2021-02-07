import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/chat_provider.dart';

import './providers/scroll_provider.dart';
import './screens/board_screen.dart';
import './screens/test_screen.dart';
import './providers/game_provider.dart';
import './providers/auth_provider.dart';
import './screens/auth_screen.dart';
import './providers/popup_provider.dart';
import './screens/lobby_screen.dart';
import './screens/create_game_screen.dart';
import './screens/friends_screen.dart';
import './providers/online_provider.dart';
import './screens/chat_screen.dart';
import './providers/friends_provider.dart';
import './helpers/theme.dart';
import './providers/server_provider.dart';
import './providers/user_provider.dart';
import './screens/main_page_viewer.dart';
import './screens/invitation_screen.dart';
import './providers/lobby_provider.dart';
import './screens/game_lobby_screen.dart';

void main() => runApp(ThreeChessApp());

class ThreeChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProvider<PopupProvider>(
            create: (_) => PopupProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ServerProvider>(
              create: (_) => ServerProvider(),
              update: (_, auth, previousServer) => previousServer
              // ..update(
              //   token: auth.token,
              //   userId: auth.userId,
              // )
              ),
          ChangeNotifierProxyProvider2<ServerProvider, PopupProvider,
              GameProvider>(
            create: (_) => GameProvider(),
            update: (_, server, popUpProvider, gameProvider) => gameProvider
              ..update(
                serverProvider: server,
                gameProvider: gameProvider,
                popUpProvider: popUpProvider
              ),
          ),
          ChangeNotifierProxyProvider2<ServerProvider, PopupProvider,
              ChatProvider>(
            create: (_) => ChatProvider(),
            update: (_, server, popUpProvider, previousChat) => previousChat
              ..update(
                serverProvider: server,
                chats: previousChat.chats,
                popUpProvider: popUpProvider,
                chatIndex: previousChat.currentChatIndex,
              ),
          ),
          ChangeNotifierProxyProvider3<ServerProvider, PopupProvider,
              ChatProvider, FriendsProvider>(
            create: (_) => FriendsProvider(),
            update: (_, server, popUpProvider, chat, previousFriends) =>
                previousFriends
                  ..update(
                    chatProvider: chat,
                    serverProvider: server,
                    friends: previousFriends.friends,
                    popUpProvider: popUpProvider
                  ),
          ),
          ChangeNotifierProxyProvider2<ServerProvider, GameProvider,
              UserProvider>(
            create: (_) => UserProvider(),
            update: (_, server, gameProvider, previousUser) => previousUser
              ..update(
                gameProvider: gameProvider,
                serverProvider: server,
                user: previousUser.user,
              ),
          ),
          ChangeNotifierProxyProvider2<ServerProvider, PopupProvider,
                  LobbyProvider>(
              create: (_) => LobbyProvider(),
              update:
                  (_, serverProvider, popUpProvider, previousLobbyProvider) =>
                      previousLobbyProvider
                        ..update(serverProvider, previousLobbyProvider, popUpProvider)),
          ChangeNotifierProxyProvider2<ServerProvider, GameProvider,
              OnlineProvider>(
            create: (_) => OnlineProvider(),
            update: (_, serverProvider, gameProvider, previousOnlineProvider) =>
                previousOnlineProvider
                  ..update(
                      hasGame: gameProvider.hasGame, server: serverProvider),
          ),
          ChangeNotifierProvider<ScrollProvider>(
            create: (_) => ScrollProvider(),
          ),
          ChangeNotifierProvider<ChessTheme>(create: (_) => ChessTheme()),
        ],
        child: Consumer<ChessTheme>(
            builder: (_, themeProvider, __) => MaterialApp(
                  theme: themeProvider.theme,
                  title: 'three chess app',
                  home: MainPageViewer(),
                  routes: {
                    MainPageViewer.routeName: (ctx) => MainPageViewer(),
                    BoardScreen.routeName: (ctx) => BoardScreen(),
                    DesignTestScreen.routeName: (ctx) => DesignTestScreen(),
                    AuthScreen.routeName: (ctx) => AuthScreen(),
                    CreateGameScreen.routeName: (ctx) => CreateGameScreen(),
                    LobbyScreen.routeName: (ctx) => LobbyScreen(),
                    FriendsScreen.routeName: (ctx) => FriendsScreen(),
                    ChatScreen.routeName: (ctx) => ChatScreen(),
                    GameLobbyScreen.routeName: (ctx) => GameLobbyScreen(),
                    InvitationScreen.routeName: (ctx) => InvitationScreen(),
                  },
                  // builder: (context, widget) => ResponsiveWrapper.builder(
                  //     BouncingScrollWrapper.builder(context, widget),
                  //     maxWidth: 2400,
                  //     minWidth: 300,
                  //     defaultScaleFactor: 0.212,
                  //     defaultScale: true,
                  //     breakpoints: [],
                  //     background: Container(color: Color(0xFFF5F5F5))),
                )));
  }
}
