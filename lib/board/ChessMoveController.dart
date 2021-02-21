import "package:flutter/material.dart";

import 'client_game.dart';
import '../models/enums.dart';
import '../models/piece.dart';
import '../models/chess_move.dart';

/// Mixin for handling Chess Board Hit Events
mixin ChessMoveController{

  String draggedPiece;
  Offset dragOffset;
  Offset startingOffset;
  String _possibleDeselect;
  MapEntry<String, List<String>> _highlighted;
  set highlighted(MapEntry<String, List<String>> newHighlighted){
    _highlighted = newHighlighted;
    updateHighlighted();
  }
  get highlighted{
    return _highlighted;
  }
  bool canDrag();
  bool canMove();

  PlayerColor get clientPlayer;
  Map<String, Piece> get pieces;

  //Method for determining LegalMoves for given Position as this Mixin has no access to boardState
  List<String> legalMoves(String whatsHit);

  String getPosition(Offset localPosition);

  //Link of notify listeners
  void update();

  //Link for clientMove
  void clientMove(String start, String end);

  //Link of notify listeners for highlighted. e.g. tileKeeper.highlightTiles(...)
  void updateHighlighted();

  //Handles PointerUp event
  void doHitUp(PointerUpEvent details){
    String whatsHit = getPosition(details.localPosition);
    if(draggedPiece != null){
      if(draggedPiece == whatsHit){
        if(whatsHit == _possibleDeselect){
          finishMove();
        }
        else{
          finishDrag();
        }
        _possibleDeselect = null;
      }
      else if(highlighted?.value?.contains(whatsHit) == true){
        clientMove(highlighted.key, whatsHit);
        finishMove();
      }
      else{
        finishMove();
      }
    }
    }

  void doHitDown(PointerDownEvent details){
    String whatsHit = getPosition(details.localPosition);
    Piece hitPiece = pieces[whatsHit];

      if (hitPiece != null && hitPiece.playerColor == clientPlayer){
          if(canDrag()){
            startDrag(whatsHit, details);
            if(highlighted != null && highlighted.key == whatsHit){
              _possibleDeselect = whatsHit;
            }
          }

      }
      else if(highlighted != null){
        if(whatsHit != null && highlighted.value.contains(whatsHit)){
          clientMove(highlighted.key, whatsHit);
          finishMove();
        }
        else{
          finishMove();
        }
      }

  }

  void doHitMove(PointerMoveEvent details){
    if(draggedPiece != null){
      dragOffset = details.localPosition - startingOffset;
    }
    update();
  }

  void startDrag(String whatsHit, details){
    if(canMove()){
      highlighted = MapEntry(whatsHit, legalMoves(whatsHit));
    }
    draggedPiece = whatsHit;
    startingOffset = details.localPosition;
    dragOffset = Offset(0,0);
  }

  void finishMove(){
    highlighted = null;
    finishDrag();
  }

  void finishDrag(){
    dragOffset = null;
    draggedPiece = null;
    startingOffset = null;
  }
}