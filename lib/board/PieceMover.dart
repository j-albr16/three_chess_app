import '../models/chess_move.dart';
import '../models/piece.dart';
import 'package:three_chess/board/BoardState.dart';
import '../board/tiles.dart';
import '../data/board_data.dart';
import '../models/enums.dart';


class PieceMover{

  static movePieceTo(String start, String end, BoardState boardState){
    if (end != null && start != null) {
      if (boardState.pieces[end] != null) {
        //boardState.pieces.firstWhere(()) = boardState.pieces[String]
        boardState.pieces.remove(end);
      }
      Piece movedPiece = boardState.pieces[start];
      if (movedPiece != null) {
        boardState.enpassent.removeWhere((key, value) => key == movedPiece.playerColor);

        boardState.pieces.remove(start); // removes entry of old piece with old position
        movedPiece.position = end;
        boardState.pieces.putIfAbsent(end, () => movedPiece); // adds new entry for piece with new pos
        // moves the selectedPieces

        // Following code listens to weather The King is castling and moves the rook accordingly
        //moveCountOnCharAxis calulates the diffrence between start and end on the character Axis
        int moveCountOnCharAxis = Tiles.charCoordinatesOf[movedPiece.playerColor].indexOf(start[0]) -
            Tiles.charCoordinatesOf[movedPiece.playerColor].indexOf(end[0]);
        if (movedPiece.pieceType == PieceType.King && moveCountOnCharAxis.abs() == 2) {
          //If true: This is a castling move
          if (moveCountOnCharAxis < 0) {
            //Checks in which direction we should castle
            String rookPos =
                Tiles.charCoordinatesOf[movedPiece.playerColor][7] + Tiles.numCoordinatesOf[movedPiece.playerColor][0];

            Piece rook = boardState.pieces[rookPos];
            String newRookPos = BoardData.adjacentTiles[movedPiece.position].left[0];
            rook.position = newRookPos;
            boardState.pieces.remove(rookPos);
            boardState.pieces.putIfAbsent(newRookPos, () => rook);
            // boardState.pieces.firstWhere((e) => e.position == rookPos, orElse: () => null)?.position =
            //     BoardData.adjacentTiles[movedPiece.position].left[0]; //Places the rook to the right of the King

          } else if (moveCountOnCharAxis > 0) {
            //Checks in which direction we should castle
            String rookPos =
                Tiles.charCoordinatesOf[movedPiece.playerColor][0] + Tiles.numCoordinatesOf[movedPiece.playerColor][0];

            Piece rook = boardState.pieces[rookPos];
            String newRookPos = BoardData.adjacentTiles[movedPiece.position].right[0];
            rook.position = newRookPos;
            boardState.pieces.remove(rookPos);
            boardState.pieces.putIfAbsent(newRookPos, () => rook);
            //Places the rook to the right of the King
          }
        }
        //Pawn en passent listener
        if (movedPiece.pieceType == PieceType.Pawn) {
          int numIndexOld = Tiles.numCoordinatesOf[BoardData.sideData[end]].indexOf(start.substring(1));
          int numIndexNew = Tiles.numCoordinatesOf[BoardData.sideData[end]].indexOf(end.substring(1));
          int charIndexOld = Tiles.charCoordinatesOf[BoardData.sideData[end]].indexOf(start[0]);
          int charIndexNew = Tiles.charCoordinatesOf[BoardData.sideData[end]].indexOf(end[0]);
          if (numIndexOld == 1 && numIndexNew == 3) {
            boardState.enpassent[movedPiece.playerColor] = end;
          }
          //If passent occurs delete driven by pawn
          else if ((charIndexOld - charIndexNew).abs() == 1 &&
              (numIndexOld - numIndexNew).abs() == 1 &&
              boardState.pieces[BoardData.adjacentTiles[end].top[0]] != null) {
            boardState.pieces.remove(BoardData.adjacentTiles[end].top[0]);
          }
        }
      }

      boardState.chessMoves.add(ChessMove(initialTile: start, nextTile: end));
    }}
}