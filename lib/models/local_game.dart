import 'game.dart';
import './request.dart';
import 'player.dart';
import 'chess_move.dart';
import 'piece.dart';
import 'enums.dart';
import 'user.dart';

class LocalGame extends Game{

  //Option weather Tiles perspective follow the player whos turn it is
  bool followPlaying;
  @override
  GameType gameType = GameType.Local;
  
  @override
  List<Player> player = [
    Player(playerColor: PlayerColor.white, isOnline: true, user: User(userName: "White")),
    Player(playerColor: PlayerColor.black, isOnline: true, user: User(userName: "Black")),
    Player(playerColor: PlayerColor.red, isOnline: true, user: User(userName: "Red")),
  ]; //TODO names are dependent on language, therefor should be saved somewhere else

  LocalGame({
    this.followPlaying,
    Map finishedGameData,
    List<ChessMove> chessMoves,
    List<Piece>  startingBoard,
    bool didStart,
    String id,
    int increment,
    int time}) : super(
      finishedGameData: finishedGameData,
      chessMoves: chessMoves,
      startingBoard: startingBoard,
      didStart: didStart,
      id: id,
      increment: increment,
      time: time
  );

}