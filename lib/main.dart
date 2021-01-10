import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/scroll_provider.dart';

import 'providers/chat_provider.dart';

import './screens/board_screen.dart';
import './screens/design-test-screen.dart';
import './providers/game_provider.dart';
import './providers/auth_provider.dart';
import './screens/auth_test_screen.dart';
import './providers/popup_provider.dart';
import './screens/lobby_screen.dart';
import './screens/create_game_screen.dart';
import './screens/game_provider_test_screen.dart';
import './screens/friends_screen.dart';
import './providers/online_provider.dart';
import './screens/chat_screen.dart';
import './providers/friends_provider.dart';
import './helpers/theme.dart';
import './providers/server_provider.dart';
import './providers/user_provider.dart';
import './screens/main_page_viewer.dart';
import './screens/invitation_screen.dart';

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
          ChangeNotifierProxyProvider2<ServerProvider, ChatProvider,
              FriendsProvider>(
            create: (_) => FriendsProvider(),
            update: (_, server, chat, previousFriends) => previousFriends
              ..update(
                chatProvider: chat,
                serverProvider: server,
                friends: previousFriends.friends,
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
          ChangeNotifierProxyProvider2<ServerProvider, GameProvider,
              OnlineProvider>(
            create: (_) => OnlineProvider(),
            update: (_, serverProvider, gameProvider, previousOnlineProvider) =>
                previousOnlineProvider
                  ..update(game: gameProvider.game, server: serverProvider),
          ),
          ChangeNotifierProvider<ScrollProvider>(
            create: (_) => ScrollProvider(),
          ),
          ChangeNotifierProxyProvider2<GameProvider, FriendsProvider,
                  PopupProvider>(
              create: (_) => PopupProvider(),
              update: (_, gameProvider, friendsProvider, popUpProvider) =>
                  popUpProvider
                    ..update(
                        friendsProvider: friendsProvider,
                        gameProvider: gameProvider)),
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
                    GameTestScreen.routeName: (ctx) => GameTestScreen(),
                    FriendsScreen.routeName: (ctx) => FriendsScreen(),
                    ChatScreen.routeName: (ctx) => ChatScreen(),
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
