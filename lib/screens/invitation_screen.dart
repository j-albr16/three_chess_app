import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/invitations/invitations.dart';
import '../screens/screen_bone.dart';
import '../providers/friends_provider.dart';
import '../providers/game_provider.dart';
import '../providers/lobby_provider.dart';
import '../widgets/invitations/invitation_head.dart';

class InvitationScreen extends StatefulWidget {
  static String routeName = '/invitation-screen';

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen>
    with notificationPort<InvitationScreen> {
  void acceptInvitation(String gameId) {
    Provider.of<LobbyProvider>(context, listen: false)
        .joinGame(gameId)
        .then((_) {
      Navigator.of(context).pop();
    });
  }

  bool deleteAll = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitations'),
      ),
      body: Container(
        child: Consumer<FriendsProvider>(
          builder: (ctx, friendsProvider, __) => SingleChildScrollView(
                      child: Column(
              children: [
                InvitationHead(
                  deleteAll: deleteAll,
                  cancelDeclineAll: () => setState(() {
                    deleteAll = false;
                  }),
                  confirmDeclineAll: () {
                    setState(() {
                      deleteAll = false;
                    });
                    friendsProvider.declineInvitation(all: true);
                  },
                  declineAll: () => setState(() {
                    deleteAll = true;
                  }),
                  invitationCount: friendsProvider.invitations.length,
                  size: Size(size.width, size.height * 0.3),
                ),
                Invitations(
                  acceptInvitation: (String gameId) => acceptInvitation(gameId),
                  declineInvitation: (String gameId) =>
                      friendsProvider.declineInvitation(gameId: gameId),
                  invitations: friendsProvider.invitations,
                  size: Size(size.width, size.height * 0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
