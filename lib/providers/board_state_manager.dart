import 'package:flutter/foundation.dart';
import 'package:three_chess/board/BoardState.dart';
import 'package:three_chess/board/ThinkingBoard.dart';
import 'package:three_chess/models/chess_move.dart';
import 'package:three_chess/models/enums.dart';

import 'game_provider.dart';

typedef Future<bool> ConfirmFunction(dynamic);

class BoardStateManager with ChangeNotifier{
  BoardState boardState;
  GameType _gameType;
  GameProvider gameProvider;
  bool waitingForResponse = false;
  PlayerColor whoIsPlaying;

  MapEntry<String, List<String>> _highlighted;

  get highlighted {
    return _highlighted;
  }

  set highlighted(newHighlighted){
    _highlighted = newHighlighted;
    print("someone set a new Highlight to me (boardStateManager");
    notifyListeners();
  }


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
          boardState = BoardState.generate(chessMoves: gameProvider.game.chessMoves);
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
      List<ChessMove> chessMoves = gameProvider.game?.chessMoves;
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
            _highlighted = null;

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
        gameProvider.sendMove(boardState.chessMoves.last).then((response) {
          if (!response) {
            boardState.transformTo(boardState.chessMoves
                .sublist(0, boardState.chessMoves.length - 1));
          }
          waitingForResponse = false;
        });
      }
      else if(gameType == GameType.Local){
        boardState.movePieceTo(start, end);

        if(!ThinkingBoard.anyLegalMove(PlayerColor.values[boardState.chessMoves.length % 3], boardState)){
          boardState.movePieceTo("", "");
        }
      }
      notifyListeners();
    }
  }




}