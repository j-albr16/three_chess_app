import 'package:flutter/foundation.dart';
import '../board/BoardState.dart';
import '../models/chess_move.dart';
import '../models/enums.dart';

import 'game_provider.dart';

typedef Future<bool> ConfirmFunction(dynamic);

class BoardStateManager with ChangeNotifier{
  BoardState boardState;
  GameType _gameType;
  GameProvider gameProvider;
  bool waitingForResponse = false;
  PlayerColor whoIsPlaying;

  MapEntry<String, List<String>> highlighted;


  set gameType(GameType newGameType){
    if(newGameType != gameType){
      _gameType = newGameType;
      _updateBoardState();
      notifyListeners();
    }
  }

  get gameType{
    return _gameType;
  }

  BoardStateManager(GameProvider currentGameProvider){
    gameProvider = currentGameProvider;
  }

  void _updateBoardState(){
    if(gameType != null){
      switch (gameType) {
        case GameType.Online:
          boardState = BoardState.generate(chessMoves: gameProvider.onlineGame?.chessMoves);
          whoIsPlaying = gameProvider.player.playerColor;
          break;
        case GameType.Local:
          boardState = BoardState();
          whoIsPlaying = null;
          break;
        case GameType.Analyze:
          break;
      }
    }
    else { // gameType == null
      boardState = null;
      whoIsPlaying = null;
    }
  }

  void update(GameProvider gameProviderUpdate){
    gameProvider = gameProviderUpdate;
    if(gameType == GameType.Online){
      List<ChessMove> chessMoves = gameProvider.onlineGame?.chessMoves;
      if(chessMoves != null){
        syncChessMove(chessMoves);
      }
    }
  }

  syncChessMove(List<ChessMove> chessMoves){
    if(boardState != null){
      if (!waitingForResponse) {
        int previousLength = boardState.chessMoves.length;
          boardState.transformTo(chessMoves);
          if(boardState.chessMoves.length != previousLength){
            highlighted = null;

          }
      }
      notifyListeners();
    }
  }

  setSelectedMove(int newIndex){ //With AnalysisBoard there will be *named* parameter
    if(boardState != null){
      boardState.selectedMove = newIndex;
      notifyListeners();
    }
  }

  clientMove(String start, String end){
    if(boardState != null){
      if(gameType == GameType.Online){
        boardState.movePieceTo(start, end);

        waitingForResponse = true;
        gameProvider.sendMove(chessMove: boardState.chessMoves.last).then((response) {
          if (!response) {
            boardState.transformTo(boardState.chessMoves
                .sublist(0, boardState.chessMoves.length - 1));
          }
          waitingForResponse = false;
        });
      }
      else if(gameType == GameType.Local){
        boardState.movePieceTo(start, end);
      }
      notifyListeners();
    }
  }




}