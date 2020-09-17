import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/piece_provider.dart';

import './screens/home_screen.dart';
import './screens/board_screen.dart';
import './providers/tile_provider.dart';

void main() => runApp(ThreeChessApp());

class ThreeChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
      ChangeNotifierProvider(create: (ctx) => TileProvider()),
          ChangeNotifierProvider(create: (ctx) => PieceProvider()),
    ],
    child: MaterialApp(
      title: 'three chess app',
      home: HomeScreen(),
      routes: {
        BoardScreen.routeName: (ctx) => BoardScreen(),
      },
    ));
  }
}
