import "package:flutter/material.dart";

import 'client_game.dart';
import '../models/enums.dart';
import '../models/piece.dart';
import '../models/dragged_piece.dart';
typedef Offset GetOffset(String string);
typedef void UpdateDragged(DraggedPiece draggedPiece);

typedef Future<void> AnimationFunction(
    {@required String draggedPiece, @required String animatedStart, @required GetOffset getOffset, Map<String, DraggedPiece> draggedPieces, UpdateDragged updateDragged});

/// Mixin for handling Chess Board Hit Events
mixin ChessMoveController{

  //Maneging piece dragged by mouse
  String draggedPieceMouse;
  Offset dragOffsetMouse;
  Offset startingOffsetMouse;
  AnimationFunction get onAnimate;

  //Maneging other pieces that move
  Map<String, DraggedPiece> _draggedPieces = {};

  Map<String, DraggedPiece> get draggedPieces{
    Map<String, DraggedPiece> returnedDraggedPieces = {};
    if(draggedPieceMouse != null && dragOffsetMouse != null) {
      returnedDraggedPieces[draggedPieceMouse] = DraggedPiece(
          dragOffset: dragOffsetMouse, draggedPiece: draggedPieceMouse);
    }
    _draggedPieces.forEach((key, value) => returnedDraggedPieces[key] = value);
    return returnedDraggedPieces;
  }

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

  Offset getOffset(String tile);

  //Link of notify listeners
  void update();

  //Link for clientMove
  void clientMove(String start, String end);

  //Link of notify listeners for highlighted. e.g. tileKeeper.highlightTiles(...)
  void updateHighlighted();

  //Handles PointerUp event
  void doHitUp(PointerUpEvent details){
    String whatsHit = getPosition(details.localPosition);
    if(draggedPieceMouse != null){
      if(draggedPieceMouse == whatsHit){
        if(whatsHit == _possibleDeselect){
          finishMove();
        }
        else{
          finishDrag();
        }
        _possibleDeselect = whatsHit;
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
          }

      }
      else if(highlighted != null){
        if(whatsHit != null && highlighted.value.contains(whatsHit)){
          clientMove(highlighted.key, whatsHit);
          //TODO ANIMATION
          animatePiece(draggedPiece: whatsHit, animatedStart: highlighted.key);
          
          finishMove();
        }
        else{
          finishMove();
        }
      }

  }

  void doHitMove(PointerMoveEvent details){
    if(draggedPieceMouse != null){
      dragOffsetMouse = details.localPosition - startingOffsetMouse;
    }
    update();
  }

  void startDrag(String whatsHit, details){
    if(canMove()){
      highlighted = MapEntry(whatsHit, legalMoves(whatsHit));
    }
    draggedPieceMouse = whatsHit;
    startingOffsetMouse = details.localPosition;
    dragOffsetMouse = Offset(0,0);
  }

  void finishMove(){
    highlighted = null;
    _possibleDeselect = null;

    finishDrag();
  }

  void finishDrag(){
    dragOffsetMouse = null;
    draggedPieceMouse = null;
    startingOffsetMouse = null;
  }

  void _updateDragged(DraggedPiece draggedPiece){
    _draggedPieces[draggedPiece.draggedPiece] = draggedPiece;
    update();
  }

  //Animates Piece to move onto its position. End Position is equal to PiecePosition when this function starts
  //Meaning Piece be offset to animatedStart position and than moves to its original Position
  Future<void> animatePiece({@required String draggedPiece, @required String animatedStart}) async {
    if(onAnimate != null){
      return onAnimate(draggedPiece: draggedPiece, animatedStart: animatedStart, draggedPieces: draggedPieces, getOffset: getOffset, updateDragged: _updateDragged);
    }
  }
}