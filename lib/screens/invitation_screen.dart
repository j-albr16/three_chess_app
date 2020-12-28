import 'package:flutter/material.dart';

import '../widgets/invitations.dart';
import '../screens/screen_bone.dart';
import 'package:provider/provider.dart';
import '../providers/friends_provider.dart';
import '../providers/game_provider.dart';
import '../screens/main_page_viewer.dart';

class InvitationScreen extends StatefulWidget {

  @override
  _InvitationScreenState createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> with notificationPort<InvitationScreen>{


  void acceptInvitation(String gameId){
    Provider.of<GameProvider>(context, listen: false).joinGame(gameId).then((_){
      Navigator.of(context).pushNamed(MainPageViewer.routeName);
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Invitations'),
      ),
      body: Container(
        child: Consumer<FriendsProvider>(
          builder: (ctx, friendsProvider, __) => 
                   Invitations(
            acceptInvitation: ,
            declineInvitation: ,
            invitations: [],
            size: size,
          ),
        ),
      ),
    );
  }
}