import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relative_scale/relative_scale.dart';
import 'package:three_chess/providers/online_provider.dart';
import 'package:three_chess/screens/game_lobby_screen.dart';
import 'package:three_chess/screens/screen_bone.dart';
import 'package:three_chess/widgets/lobby/quick-pairing-popup.dart';

import '../providers/game_provider.dart';
import '../providers/lobby_provider.dart';
import '../screens/test_screen.dart';
import '../widgets/lobby/lobby_table_mobilefull.dart';
import '../widgets/lobby/lobby_actions.dart';
import '../providers/lobby_provider.dart';
import '../widgets/lobby/lobby_select.dart';
import './create_game_screen.dart';
import 'board_screen.dart';
import '../models/online_game.dart';

typedef StartQuickPairing(
    {@required int time,
    @required int increment,
    @required BuildContext context});

class LobbyScreen extends StatefulWidget {
  static const routeName = '/lobby-screen';

  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen>
    with notificationPort<LobbyScreen> {
  LobbyTable lobbyTable;
  LobbyProvider _lobbyProvider;

  @override
  void initState() {
    _lobbyProvider = Provider.of<LobbyProvider>(context, listen: false);
    super.initState();
  }

  void lobbySelectPopUp(
      BuildContext context, List<OnlineGame> onlineGames, Size size) {
    showDialog(
      context: context,
      builder: (context) => LobbySelect(
        size: size,
        onlineGames: onlineGames,
        selectLobbyCall: (gameId, context) =>
            Provider.of<LobbyProvider>(context, listen: false)
                .setAndNavigateToGameLobby(context, gameId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => stopQuickPairing(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.dashboard_sharp),
                onPressed: () => Navigator.of(context)
                    .pushNamed(DesignTestScreen.routeName)),
            Consumer<LobbyProvider>(
              builder: (context, lobbyProvider, child) => IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => lobbySelectPopUp(
                      context, lobbyProvider.pendingGames, size)),
            ),
            IconButton(
              color: Colors.white,
              icon: Icon(Icons.add),
              onPressed: () {
                return Navigator.of(context).pushNamed(
                    CreateGameScreen.routeName,
                    arguments: {'friend': ''});
              },
            ),
            SizedBox(width: 20)
          ],
          title: Text('Lobby'),
        ),
        body: RelativeBuilder(
            builder: (context, screenHeight, screenWidth, sy, sx) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                flex: 3,
                child: Container(
                  width: screenWidth,
                  child: Container(
                    child: LobbyTable(
                      width: screenWidth,
                      lobbyProvider: Provider.of<LobbyProvider>(context),
                      theme: Theme.of(context),
                      height: screenHeight * 0.5,
                      selectedColumns: [
                        ColumnType.Time,
                        ColumnType.AverageScore,
                        ColumnType.Mode,
                        ColumnType.UserNames
                      ],
                      gameProvider: Provider.of<GameProvider>(context),
                      onGameTap: (game) {
                        Provider.of<LobbyProvider>(context, listen: false)
                            .joinGame(context, game.id);
                      },
                    ),
                  ),
                ),
              ),
              Flexible(
                child: LobbyActions(startQuickPairing: startQuickParing),
                flex: 2,
              ),
            ],
          );
        }),
      ),
    );
  }

  void startQuickParing({int time, int increment, BuildContext context}) async {
    Map<String, dynamic> data =
        await _lobbyProvider.quickPairing(time: time, increment: increment);
    if (data['valid']) {
      Provider.of<OnlineProvider>(context, listen: false)
          .setGetPossibleMatchesTimer(time, increment, data['possibleMatches']);
      return showDialog(
          context: context,
          builder: (context) {
            return QuickPairingPopUp(
              increment: increment,
              time: time,
            );
          }).then((value) => stopQuickPairing());
    }
  }

  void stopQuickPairing() async {
    print('Stopping Quick Pairing');
    bool isValid = await _lobbyProvider.stopQuickPairing();
    if (!isValid) {
      print('SOMETHING WENT WRONG STOPPING QUICK PAIRING');
      return null;
    }
    Provider.of<OnlineProvider>(context, listen: false)
        .stopGetPossibleMatchesTimer();
  }
}
