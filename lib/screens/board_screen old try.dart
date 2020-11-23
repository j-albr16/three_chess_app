// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:three_chess/board/BoardState.dart';
// import 'package:three_chess/models/enums.dart';
// import 'package:three_chess/models/game.dart';
// import 'package:three_chess/models/player.dart';
//
// import '../models/chess_move.dart';
// import '../widgets/board_boarding_widgets.dart';
// import '../providers/game_provider.dart';
// import '../widgets/three_chess_board.dart';
// import 'package:relative_scale/relative_scale.dart';
//
// class BoardScreen extends StatefulWidget {
//   static const routeName = '/board-screen';
//
//   @override
//   _BoardScreenState createState() => _BoardScreenState();
// }
//
// class _BoardScreenState extends State<BoardScreen> {
//   ThreeChessBoard threeChessBoard;
//   bool didload = false;
//
//   @override
//   void initState() {
//     // threeChessBoard = ThreeChessBoard(
//     //     boardState: BoardState.newGame(), height: 1000, width: 1000);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double scaleFactor = 20;
//     double borderWith = 4;
//
//     GameProvider gameProvider =
//         Provider.of<GameProvider>(context, listen: false);
//     Player getPlayer(PlayerColor playerColor) {
//       return gameProvider.game.player.firstWhere(
//           (element) => element.playerColor == playerColor,
//           orElse: null);
//     }
//
//     bool waiting = gameProvider.game == null || !gameProvider.game.didStart;
//     Player leftCorner;
//     Player rightCorner;
//
//     if (gameProvider.game != null) {
//       leftCorner = getPlayer(
//           PlayerColor.values[(gameProvider.player.playerColor.index + 1) % 3]);
//       rightCorner = getPlayer(
//           PlayerColor.values[(gameProvider.player.playerColor.index + 2) % 3]);
//     }
//
//
//     return Scaffold(
//       appBar: AppBar(),
//       body:
//       RelativeBuilder(
//         builder: (context, screenHeight, screenWidth, sy, sx) {
//           bool noBottomPanel = false;
//           if(screenHeight/screenWidth < 745/615){
//             noBottomPanel = true;
//             print(screenWidth.toString());
//           }
//           return Container(
//             height: screenHeight,
//             child:
//                 Container(
//                   width: double.infinity,
//                   height: screenHeight *0.9,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 10,
//                         left: 10,
//                         child: (leftCorner != null)
//                             ? CornerTile(
//                           isOnline: leftCorner.isOnline ?? false,
//                           username: leftCorner.user.userName,
//                           score: leftCorner.user.score,
//                           isCornerLeft: true,
//                           borderWidth: borderWith,
//                           scaleFactor: scaleFactor,
//                         )
//                             : CornerTile.unknown(
//                           isCornerLeft: true,
//                           borderWidth: borderWith,
//                           scaleFactor: scaleFactor,
//                         ),
//                       ),
//                       Positioned(
//                         top: 10,
//                         right: 10,
//                         child: (rightCorner != null)
//                             ? CornerTile(
//                           isOnline: rightCorner.isOnline ?? false,
//                           username: rightCorner.user.userName,
//                           score: rightCorner.user.score,
//                           isCornerLeft: false,
//                           borderWidth: borderWith,
//                           scaleFactor: scaleFactor,
//                         )
//                             : CornerTile.unknown(
//                           isCornerLeft: false,
//                           borderWidth: borderWith,
//                           scaleFactor: scaleFactor,
//                         ),
//                       ),
//                       waiting ? Align(
//                         alignment: Alignment.center,
//                         child: Container(
//                           height: screenHeight * 0.5,
//                           width: screenWidth *0.6,
//                           color: Colors.black,
//                         ),
//                       ) : Positioned(
//                           top: noBottomPanel ? screenHeight * 0.11 : screenHeight * 0.14,
//                           left: 10,
//                           child:
//                           Container(
//                             height: noBottomPanel ? screenWidth * 0.95 : screenWidth,
//                             width: noBottomPanel ? screenWidth * 0.95 : screenWidth,
//                             child: FittedBox(
//                               child: ThreeChessBoard(
//                                 boardState: BoardState.newGame(),
//                                 height: 500,
//                                 width: 500,
//                               ),
//                             ),
//                           )
//                       ),
//                       if(!noBottomPanel)Align(
//                         alignment: Alignment.bottomCenter,
//                         //top: screenHeight - screenHeight * 0.15,
//                         child: Container(
//                            height: screenHeight * 0.10 ,
//                            width: screenWidth,
//                           color: Colors.grey,
//                           child: Row(children: [
//                             Icon( Icons.radio_button_checked, //TODO put all those online buttons in one file that all usage places can reference from
//                               color: Colors.green,
//                             ),
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text("${gameProvider.player?.user?.userName}"),
//                                 Text(gameProvider.player?.user?.score.toString())
//                               ],
//                             ),
//                             Text("${gameProvider.game?.time} + ${gameProvider.game?.increment}")
//                           ],),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//           );
//
//
//           // waiting ?
//           //
//           // Container(
//           //     width: 2400,
//           //     child: ThreeChessBoard(
//           //         boardState: BoardState.newGame(), height: 1000, width: 1000)),
//         }));
//   }
// }
