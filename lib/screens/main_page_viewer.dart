import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:three_chess/providers/friends_provider.dart';
import 'package:three_chess/providers/game_provider.dart';
import 'package:three_chess/screens/board_screen.dart';
import '../screens/friends_screen.dart';
import '../screens/home_screen.dart';
import '../screens/lobby_screen.dart';
//


import 'dart:math';
import 'package:flutter/material.dart';


class MainPageViewer extends StatefulWidget {
  static const routeName = '/main-page-viewer';
  int initPage;

  MainPageViewer({this.initPage = 1});

  @override
  State createState() => new MainPageViewerState();
}

class MainPageViewerState extends State<MainPageViewer> {

   PageController _controller;

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  void initState() {
    _controller = PageController(initialPage: widget.initPage);
    Future.delayed(Duration.zero).then((_) {
      GameProvider gameProvider =
      Provider.of<GameProvider>(context, listen: false);
      gameProvider.fetchGames();
         Provider.of<FriendsProvider>(context, listen: false).fetchFriends();
    });


    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<Widget> _pages = <Widget>[
    FriendsScreen(),
    HomeScreen(),
    LobbyScreen(),
    BoardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new IconTheme(
        data: new IconThemeData(color: _kArrowColor),
        child: new Stack(
          children: <Widget>[
            new PageView.builder(
              physics: new AlwaysScrollableScrollPhysics(),
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return _pages[index % _pages.length];
              },
            ),
            new Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: new Container(
                color: Colors.grey[800].withOpacity(0.4),
                padding: const EdgeInsets.all(5.0),
                child: new Center(
                  child: new DotsIndicator(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: _kDuration,
                        curve: _kCurve,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 10.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    bool toLoop = false;
    if(controller.page != null && controller.page.ceil() % itemCount == 0 && index == 0){
      toLoop = true;
    }
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - (((controller.page ?? controller.initialPage) + (toLoop ? 1 : 0)) % itemCount - (index + (toLoop ? 1 : 0))).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
