import 'enums.dart';
import 'game.dart';
import './request.dart';
import './player.dart';
import './chess_move.dart';
import './piece.dart';

class OnlineGame extends Game {
  @override
  GameType gameType = GameType.Online;

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
    List<Piece> startingBoard,
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
    this.endGameExpiry,
  }) : super(
            player: player,
            finishedGameData: finishedGameData,
            chessMoves: chessMoves,
            startingBoard: startingBoard,
            didStart: didStart,
            id: id,
            increment: increment,
            time: time);

  set didStart(bool didStart) {
    super.didStart = didStart;
  }

  set startingBoard(List<Piece> startingBoard) {
    super.startingBoard = startingBoard;
  }

  set chessMoves(List<ChessMove> chessMoves) {
    super.chessMoves = chessMoves;
  }

  set time(int time) {
    super.time = time;
  }

  set player(List<Player> player) {
    super.player = player;
  }

  set finishedGameData(Map finishedGameData) {
    super.finishedGameData = finishedGameData;
  }

  set id(String id) {
    super.id = id;
  }

  set increment(int increment) {
    super.increment = increment;
  }
}
