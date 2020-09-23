import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/piece_provider.dart';
import 'package:three_chess/providers/tile_select.dart';
import 'package:responsive_framework/responsive_framework.dart';

import './screens/home_screen.dart';
import './screens/board_screen.dart';
import './providers/tile_provider.dart';
import './providers/image_provider.dart';
import './models/tile.dart';

void main() => runApp(ThreeChessApp());

class ThreeChessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => TileProvider()),
          ChangeNotifierProvider(create: (ctx) => PieceProvider()),
          ChangeNotifierProvider(create: (ctx) => ImageProv()),
          ChangeNotifierProvider(
            create: (ctx) => TileSelect(),
          )
        ],
        child: MaterialApp(
            title: 'three chess app',
            home: HomeScreen(),
            routes: {
              BoardScreen.routeName: (ctx) => BoardScreen(),
            },
            builder: (context, widget) =>
                ResponsiveWrapper.builder(
                    BouncingScrollWrapper.builder(context, widget),
                    maxWidth: 1200,
                    minWidth: 300,
                    defaultScaleFactor: 0.312,
                    defaultScale: true,
                    breakpoints: [
                    ],
                    background: Container(color: Color(0xFFF5F5F5))),
        ));
  }
}

class TestProvider with ChangeNotifier {}
