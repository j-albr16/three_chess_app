import "package:flutter/material.dart";

class DraggedPiece{
  String draggedPiece;
  Offset dragOffset;

  DraggedPiece({@required this.dragOffset, @required this.draggedPiece});

  DraggedPiece clone(){
    return DraggedPiece(dragOffset: this.dragOffset, draggedPiece: this.draggedPiece);
  }
}