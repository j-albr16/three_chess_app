import 'game.dart';
import './request.dart';
import './player.dart';
import './chess_move.dart';
import './piece.dart';

class OnlineGame extends Game{

  DateTime endGameExpiry; //Will prob. change
  List<String> invitations;
  bool isPublic;
  bool isRated;
  int posRatingRange;
  int negRatingRange;
  List<Request> requests;
  String chatId;
  bool allowPremades;

  OnlineGame({
    List<Player> player,
    Map finishedGameData,
    List<ChessMove> chessMoves,
    List<Piece>  startingBoard,
    bool didStart,
    String id,
    int increment,
    int time,
    this.allowPremades,
    this.chatId,
    this.invitations,
    this.requests,
    this.isPublic,
    this.isRated,
    this.negRatingRange,
    this.posRatingRange,
    this.endGameExpiry,}) : super(
      player: player,
      finishedGameData: finishedGameData,
      chessMoves: chessMoves,
      startingBoard: startingBoard,
      didStart: didStart,
      id: id,
      increment: increment,
      time: time
  );
}