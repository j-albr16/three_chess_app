import 'package:flutter/material.dart';
import 'package:three_chess/widgets/friend_list.dart';

enum FriendAction{
  Watch,
  Battle,
  Profile,
  Delete
}

class FriendsScreen extends StatefulWidget {
   static const routeName = 'friends-screen';

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  bool isTyping = false;
    final List<FriendTileModel> sampleFriends = [
      FriendTileModel(
        isOnline: false,
        isPlaying: false,
        username: "Halbrechts",
      ),
      FriendTileModel(
        isOnline: true,
        isPlaying: true,
        username: "LeosLeo",
      ),
      FriendTileModel(
        isOnline: true,
        isPlaying: false,
        username: "winkt",
      )
    ];

   Future<void> _friendPopUp(context, FriendTileModel model) async {
     switch (await showDialog<FriendAction>(
         context: context,
         builder: (BuildContext context) {
           return SimpleDialog(
             
             title: const Text('What you wanna do with him?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
             children: <Widget>[
               SimpleDialogOption(
                 onPressed: () { Navigator.pop(context, FriendAction.Battle); },
                 child: Center(child: const Text('Battle him!', style: TextStyle(color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold),)),
               ),
               SimpleDialogOption(
                 onPressed: () { Navigator.pop(context, FriendAction.Profile); },
                 child: const Center(child: Text('His Profile!', style: TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.bold),)),
               ),
               SimpleDialogOption(
                 onPressed: () { Navigator.pop(context, model.isPlaying ? FriendAction.Watch : null); },
                 child:  Center(child: Text(model.isPlaying ? 'Watch him Play!' : "He ain't Playing right now!", style: TextStyle(color: model.isPlaying ? Colors.green : Colors.grey, fontSize: 17, fontWeight: FontWeight.bold),)),
               ),
               SimpleDialogOption(
                 onPressed: () { Navigator.pop(context, FriendAction.Delete); },
                 child: const Center(child: Text('Delete that guy!', style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),)),
               ),
             ],
           );
         }
     )) {
       case FriendAction.Battle:
       //TODO
         break;
       case FriendAction.Profile:
       //TODO
         break;
       case FriendAction.Watch:
       //TODO
         break;

     case FriendAction.Delete:
     //TODO
     break;
   }
   }


   switchTyping(){
     setState(() {
       isTyping = !isTyping;
     });
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Friends'),
        ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
          if(isTyping) {switchTyping();}
        } ,
        child: Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child:  FriendList(
              isTyping: isTyping,
              switchTyping: switchTyping,
              tileHeight: 40,
                addFriend: (toBeAddedUsername) => print("request to add: " + toBeAddedUsername),
                popUp: (username) => _friendPopUp(context, username),
                friendTiles: sampleFriends,
                width: 300,),
            ),
          ),
      ),
      );
  }
}