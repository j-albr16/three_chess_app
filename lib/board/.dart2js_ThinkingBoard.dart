

import 'package:collection/collection.dart';
import 'dart:ui';
import 'dart:math';

main(){
  return ThinkingBoard;
}
enum SpecialMove{Castling, Enpassant, Check, CheckMate, Take, NoMove, Win}
enum MoveType { QueenSideRochade, KingSideRochade, Take }

class ChessMove {
  String initialTile;
  String nextTile;
  // TODO think whether we need Piece
  // PieceType piece;
  // bool check = false;
  // bool checkMate = false;
  int remainingTime; // in secs

  ChessMove({this.initialTile, this.nextTile, this.remainingTime});

  bool equalMove(ChessMove chessMove){
    return (chessMove.initialTile == initialTile && chessMove.nextTile == chessMove.nextTile);
  }
}


class Tile  {
  final bool isHighlighted;
  final List<Point> points;
  final bool isWhite;
  final String id;
  final Directions directions;
  final PlayerColor side;
  final Path path;

  Point get middle {
    double sx = 0.0;
    double sy = 0.0;
    double sL = 0.0;
    for (int i = 0; i < points.length; i++) {
      double x0 = (i == 0 ? points.last : points[i - 1]).x.toDouble();
      double y0 = (i == 0 ? points.last : points[i - 1]).y.toDouble();
      double x1 = points[i].x.toDouble();
      double y1 = points[i].y.toDouble();
      double L = sqrt(pow((x1 - x0), 2) + pow((y1 - y0), 2)); //Math.p
      sx += ((x0 + x1) / 2) * L;
      sy += ((y0 + y1) / 2) * L;
      sL += L;
    }

    double xc = sx / sL;
    double yc = sy / sL;
    return Point(xc, yc);

    //     double x1 = points[0].x;
//     double x2 = points[2].x;
//     double y1 = points[0].y;
//     double y2 = points[2].y;
//     print("x: " +(x1 + (1/2 * (x2-x1))).toString() + "y: " + (y1 + (1/2 + (y2-y1))).toString());
//     return Point(x1 + (1/2 * (x2-x1)), y1 + (1/2 + (y2-y1)));
  }

  static Offset toOffset(Point point) {
    return Offset(point.x, point.y);
  }

  Tile(
      {this.points,
      this.isWhite,
      this.id,
      this.directions,
      this.side,
      this.path,
      this.isHighlighted = false}) ;
}


class Tiles{

  Map<String, Tile> tiles;
  List<String> lastHighlighted;
  PlayerColor perspectiveOf;

  Tiles({ this.perspectiveOf = PlayerColor.white}){
    tiles = {};

    BoardData.tileData.entries.toList().forEach((e) {
      tiles[e.key] = Tile(
          id: e.key,
          points: e.value,
          isWhite: BoardData.tileWhiteData[e.key],
          directions: BoardData.adjacentTiles[e.key],
          side: BoardData.sideData[e.key],
          path: Path()
            ..moveTo(e.value[0].x.toDouble(), e.value[0].y.toDouble())
            ..lineTo(e.value[1].x.toDouble(), e.value[1].y.toDouble())
            ..lineTo(e.value[2].x.toDouble(), e.value[2].y.toDouble())
            ..lineTo(e.value[3].x.toDouble(), e.value[3].y.toDouble())
            ..lineTo(e.value[0].x.toDouble(), e.value[0].y.toDouble())
            ..close());
    });
    for(int i = 0; i < perspectiveOf.index; i++){
      rotateTilesNext();
    }
  }

  void highlightTiles(List<String> highlighted){
    if(lastHighlighted != null){
      for(String high in lastHighlighted){
        tiles[high] = Tile(
            isHighlighted: false,
            id: tiles[high].id,
            points: tiles[high].points,
            isWhite: BoardData.tileWhiteData[high],
            directions: BoardData.adjacentTiles[high],
            side: BoardData.sideData[high],
            path: tiles[high].path);
      }
    }
    if (highlighted != null) {
      for(String high in highlighted){
        tiles[high] = Tile(
            isHighlighted: true,
            id: tiles[high].id,
            points: tiles[high].points,
            isWhite: BoardData.tileWhiteData[high],
            directions: BoardData.adjacentTiles[high],
            side: BoardData.sideData[high],
            path: tiles[high].path);
      }
    }
    lastHighlighted = highlighted;
  }

  void rotateTilesTo(PlayerColor playerColor){
    while(perspectiveOf != playerColor){
      rotateTilesNext();
    }
  }

  void rotateTilesPrevious() {
    Map<String, Tile> newTiles = {};
  for (Tile tile in tiles.values.toList()) {
    String prevId = previousColorEqualCoordinate(tile.id);
    newTiles[prevId] = Tile(
        id: prevId,
        points: tile.points,
        isWhite: BoardData.tileWhiteData[prevId],
        directions: BoardData.adjacentTiles[prevId],
        side: BoardData.sideData[prevId],
        path: tile.path);
  }
  perspectiveOf = PlayerColor.values[perspectiveOf.index + 2 % 3];

  tiles = newTiles;}

  void rotateTilesNext() {
    Map<String, Tile> newTiles = {};
  for (Tile tile in tiles.values.toList()) {
    String nextId = nextColorEqualCoordinate(tile.id);
    newTiles[nextId] = Tile(
        id: nextId,
        points: tile.points,
        isWhite: BoardData.tileWhiteData[nextId],
        directions: BoardData.adjacentTiles[nextId],
        side: BoardData.sideData[nextId],
        path: tile.path);
  }

    perspectiveOf = PlayerColor.values[perspectiveOf.index + 1 % 3];
    tiles = newTiles;
  }

  static Map<PlayerColor, List<String>> charCoordinatesOf = {
    PlayerColor.white: ["A", "B", "C", "D", "E", "F", "G", "H"],
    PlayerColor.black: ["L", "K", "J", "I", "D", "C", "B", "A"],
    PlayerColor.red: ["H", "G", "F", "E", "I", "J", "K", "L"]
  };
  static Map<PlayerColor, List<String>> numCoordinatesOf = {
    PlayerColor.white: ["1", "2", "3", "4"],
    PlayerColor.black: ["8", "7", "6", "5"],
    PlayerColor.red: ["12", "11", "10", "9"],
  };

  static String getEqualCoordinate(String tileId, PlayerColor switchTo) {
    if (BoardData.sideData[tileId] == switchTo) {
      return tileId;
    } else if ((BoardData.sideData[tileId].index + 1) % 3 == switchTo.index) {
      return nextColorEqualCoordinate(tileId);
    }
    return previousColorEqualCoordinate(tileId);
  }

  static String previousColorEqualCoordinate(String tileId) {
    PlayerColor currentColor = BoardData.sideData[tileId];

    int charIndex = charCoordinatesOf[currentColor].indexOf(tileId[0]);
    int numIndex = numCoordinatesOf[currentColor].indexOf(tileId.substring(1));

    PlayerColor previousColor = PlayerColor.values[(currentColor.index + 2) % 3];

    return (charCoordinatesOf[previousColor][charIndex] + numCoordinatesOf[previousColor][numIndex]);
  }

  static String nextColorEqualCoordinate(String tileId) {
    PlayerColor currentColor = BoardData.sideData[tileId];

    int charIndex = charCoordinatesOf[currentColor].indexOf(tileId[0]);
    int numIndex = numCoordinatesOf[currentColor].indexOf(tileId.substring(1));

    PlayerColor nextColor = PlayerColor.values[(currentColor.index + 1) % 3];

    return (charCoordinatesOf[nextColor][charIndex] + numCoordinatesOf[nextColor][numIndex]);
  }

  getTilePositionOf(Offset localPosition,){
    return tiles
        .entries
        .firstWhere((e) => e.value.path.contains(localPosition), orElse: () => null)?.key;
  }

  static getTilePositionOfInTiles(Offset localPosition,  Map<String, Tile> tiles){
    return tiles
        .entries
        .firstWhere((e) => e.value.path.contains(localPosition), orElse: () => null).key;
  }

}
class BoardStateBone{
  Map<String, Piece> pieces;
  Map<PlayerColor, String> enpassent;
  List<ChessMove> chessMoves;

  BoardStateBone({this.chessMoves, this.enpassent, this.pieces}) {
    if(chessMoves == null && enpassent == null && pieces == null){
      newGame();
    }
    else if(pieces == null){
      BoardStateBone.generate(chessMoves: chessMoves);
    }
  }

  BoardStateBone.takeOver({this.pieces, this.enpassent, this.chessMoves});

  BoardStateBone.generate({this.chessMoves}){
    _generate(chessMoves);
  }

  void _generate(List<ChessMove> chessMoves){
    pieces = {};
    enpassent = {};
    newGame();
    for(ChessMove chessMove in chessMoves){
      movePieceTo(chessMove.initialTile, chessMove.nextTile);
    }
  }

  BoardStateBone clone(){
    Map<String, Piece> clonePieces = {};
    Map<PlayerColor, String> clonePassent = {};

    for (MapEntry potEnPass in enpassent.entries) {
      clonePassent[potEnPass.key] = potEnPass.value;
    }

    for (Piece piece in pieces.values) {
      clonePieces[piece.position] = Piece(
        pieceType: piece.pieceType,
        playerColor: piece.playerColor,
        position: piece.position,
      );
    }

    return new BoardStateBone.takeOver(
      pieces: clonePieces,
      enpassent: clonePassent,
      chessMoves: [...chessMoves],
    );
  }


  void movePieceTo(String start, String end){
    List<SpecialMove> specialMoves =[];
    PieceKey takenPiece;
    Piece movedPiece;

    if (end != null && start != null) {
      if(end == "" && start == ""){ //Special No Move Call
        // assert(!ThinkingBoard.anyLegalMove(PlayerColor.values[chessMoves.length % 3], this));
        specialMoves.add(SpecialMove.NoMove);

      }
      else{
        if (pieces[end] != null) {
          //boardState.pieces.firstWhere(()) = boardState.pieces[String]
          takenPiece = pieces[end].pieceKey;
          pieces.remove(end);
        }
        movedPiece = pieces[start];
        if (movedPiece != null) {
          enpassent.removeWhere((key, value) => key == movedPiece.playerColor);

          pieces.remove(start); // removes entry of old piece with old position
          movedPiece.position = end;
          pieces.putIfAbsent(
              end, () => movedPiece); // adds new entry for piece with new pos
          // moves the selectedPieces

          // Following code listens to weather The King is castling and moves the rook accordingly
          //moveCountOnCharAxis calulates the diffrence between start and end on the character Axis
          int moveCountOnCharAxis = Tiles
              .charCoordinatesOf[movedPiece.playerColor]
              .indexOf(start[0]) -
              Tiles.charCoordinatesOf[movedPiece.playerColor].indexOf(end[0]);
          if (movedPiece.pieceType == PieceType.King &&
              moveCountOnCharAxis.abs() == 2) {
            //If true: This is a castling move
            specialMoves.add(SpecialMove.Castling);
            if (moveCountOnCharAxis < 0) {
              //Checks in which direction we should castle
              String rookPos = Tiles.charCoordinatesOf[movedPiece.playerColor]
              [7] +
                  Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = pieces[rookPos];
              String newRookPos =
              BoardData.adjacentTiles[movedPiece.position].left[0];
              rook.position = newRookPos;
              pieces.remove(rookPos);
              pieces.putIfAbsent(newRookPos, () => rook);
              // pieces.firstWhere((e) => e.position == rookPos, orElse: () => null)?.position =
              //     BoardData.adjacentTiles[movedPiece.position].left[0]; //Places the rook to the right of the King

            } else if (moveCountOnCharAxis > 0) {
              //Checks in which direction we should castle
              String rookPos = Tiles.charCoordinatesOf[movedPiece.playerColor]
              [0] +
                  Tiles.numCoordinatesOf[movedPiece.playerColor][0];

              Piece rook = pieces[rookPos];
              String newRookPos =
              BoardData.adjacentTiles[movedPiece.position].right[0];
              rook.position = newRookPos;
              pieces.remove(rookPos);
              pieces.putIfAbsent(newRookPos, () => rook);
              //Places the rook to the right of the King
            }
          }
          //Pawn en passent listener
          if (movedPiece.pieceType == PieceType.Pawn) {
            int numIndexOld = Tiles.numCoordinatesOf[BoardData.sideData[end]]
                .indexOf(start.substring(1));
            int numIndexNew = Tiles.numCoordinatesOf[BoardData.sideData[end]]
                .indexOf(end.substring(1));
            int charIndexOld = Tiles.charCoordinatesOf[BoardData.sideData[end]]
                .indexOf(start[0]);
            int charIndexNew = Tiles.charCoordinatesOf[BoardData.sideData[end]]
                .indexOf(end[0]);
            if (numIndexOld == 1 && numIndexNew == 3) {
              enpassent[movedPiece.playerColor] = end;
            }
            //If passent occurs delete driven by pawn
            else if ((charIndexOld - charIndexNew).abs() == 1 &&
                numIndexOld - numIndexNew == 1 &&
                numIndexNew == 2 &&
                pieces[BoardData.adjacentTiles[end].top[0]] != null) {
              // print("im in boardState movePieceTo enpassent");
              // print(BoardData.adjacentTiles[end].top[0]);
              // print(enpassent[BoardData.sideData[end]].toString() + "this is the enpassent");

              PieceKey possTakenPiece =
                  pieces[BoardData.adjacentTiles[end].top[0]].pieceKey;
              if (enpassent[PieceKeyGen.getPlayerColor(possTakenPiece)] !=
                  null &&
                  enpassent[PieceKeyGen.getPlayerColor(possTakenPiece)] ==
                      ThinkingBoard.checkEmpty(
                          BoardData.adjacentTiles[end].top, 0)) {
                pieces.remove(BoardData.adjacentTiles[end].top[0]);
                takenPiece = possTakenPiece;
              }
            }
          }
        }
      }
      ChessMove chessMove = ChessMove(initialTile: start, nextTile: end);
      chessMoves.add(chessMove);
    }
  }

BoardStateBone cloneBones(){
    return this.clone();
}

  void newGame() {
    pieces = {};
    [
      //White
      //#region White
      //#region pawns
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'A2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'B2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'C2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'D2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'E2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'F2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'G2',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.white,
        position: 'H2',
      ),
      //#endregion
      //#region noPawns
      Piece(
        pieceType: PieceType.Rook,
        playerColor: PlayerColor.white,
        position: 'A1',
      ),
      Piece(
        pieceType: PieceType.Knight,
        playerColor: PlayerColor.white,
        position: 'B1',
      ),
      Piece(
        pieceType: PieceType.Bishop,
        playerColor: PlayerColor.white,
        position: 'C1',
      ),
      Piece(
        pieceType: PieceType.Queen,
        playerColor: PlayerColor.white,
        position: 'D1',
      ),
      Piece(
        pieceType: PieceType.King,
        playerColor: PlayerColor.white,
        position: 'E1',
      ),
      Piece(
        pieceType: PieceType.Bishop,
        playerColor: PlayerColor.white,
        position: 'F1',
      ),
      Piece(
        pieceType: PieceType.Knight,
        playerColor: PlayerColor.white,
        position: 'G1',
      ),
      Piece(
        pieceType: PieceType.Rook,
        playerColor: PlayerColor.white,
        position: 'H1',
      ),
      //#endregion
      //#endregion
      //#region Black
      //#region pawns
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'L7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'K7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'J7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'I7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'D7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'C7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'B7',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.black,
        position: 'A7',
      ),
      //#endregion
      //#region noPawns
      Piece(
        pieceType: PieceType.Rook,
        playerColor: PlayerColor.black,
        position: 'L8',
      ),
      Piece(
        pieceType: PieceType.Knight,
        playerColor: PlayerColor.black,
        position: 'K8',
      ),
      Piece(
        pieceType: PieceType.Bishop,
        playerColor: PlayerColor.black,
        position: 'J8',
      ),
      Piece(
        pieceType: PieceType.Queen,
        playerColor: PlayerColor.black,
        position: 'I8',
      ),
      Piece(
        pieceType: PieceType.King,
        playerColor: PlayerColor.black,
        position: 'D8',
      ),
      Piece(
        pieceType: PieceType.Bishop,
        playerColor: PlayerColor.black,
        position: 'C8',
      ),
      Piece(
        pieceType: PieceType.Knight,
        playerColor: PlayerColor.black,
        position: 'B8',
      ),
      Piece(
        pieceType: PieceType.Rook,
        playerColor: PlayerColor.black,
        position: 'A8',
      ),
      //#endregion
      //#endregion
      //#region red
      //#region pawns
      //Pawns
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'H11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'G11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'F11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'E11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'I11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'J11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'K11',
      ),
      Piece(
        pieceType: PieceType.Pawn,
        playerColor: PlayerColor.red,
        position: 'L11',
      ),
      //#endregion
      //#region noPawns
      Piece(
        pieceType: PieceType.Rook,
        playerColor: PlayerColor.red,
        position: 'H12',
      ),
      Piece(
        pieceType: PieceType.Knight,
        playerColor: PlayerColor.red,
        position: 'G12',
      ),
      Piece(
        pieceType: PieceType.Bishop,
        playerColor: PlayerColor.red,
        position: 'F12',
      ),
      Piece(
        pieceType: PieceType.Queen,
        playerColor: PlayerColor.red,
        position: 'E12',
      ),
      Piece(
        pieceType: PieceType.King,
        playerColor: PlayerColor.red,
        position: 'I12',
      ),
      Piece(
        pieceType: PieceType.Bishop,
        playerColor: PlayerColor.red,
        position: 'J12',
      ),
      Piece(
        pieceType: PieceType.Knight,
        playerColor: PlayerColor.red,
        position: 'K12',
      ),
      Piece(
        pieceType: PieceType.Rook,
        playerColor: PlayerColor.red,
        position: 'L12',
      ),
      //#endregions
      //#endregion
    ].forEach((piece) {pieces[piece.position] = piece;});
    enpassent = {};
    chessMoves = [];
  }

  @override
  bool operator ==(Object other) {
    return ListEquality().equals(chessMoves, other);
  }

  @override
  int get hashCode => chessMoves.hashCode;
}

class Piece {
  PieceType pieceType;
  bool invis = false;
  String _position;
  PlayerColor playerColor;
  bool didMove = false;



  PieceKey get pieceKey {
    return PieceKeyGen.genKey(pieceType, playerColor);
  }

  String get position {
    return _position;
  }

  set position(String newPosition) {
    if (!didMove) {
      didMove = true;
    }
    _position = newPosition;
  }

  Piece({this.pieceType, String position, this.playerColor}) {
    _position = position;
  }

 
}

// class Piece {
//   String _position;
//   bool invis = false;

//   set position(String newPosition) {
//     if (!didMove) {
//       didMove = true;
//     }
//     _position = newPosition;
//   }

//   String get position {
//     return _position;
//   }

// bool didMove = false;
// final PieceType pieceType;
// final PlayerColor playerColor;
// PieceKey get pieceKey {
//   return PieceKeyGen.genKey(pieceType, playerColor);
// }

//   Piece({
//     String position,
//     this.pieceType,
//     this.playerColor,
//   }) {
//     this._position = position;
//   }
// }

class PieceKeyGen {
  static genKey(PieceType pieceType, PlayerColor playerColor) {
    return PieceKey.values[pieceType.index * 3 + playerColor.index];
  }

  static getPieceType(PieceKey pieceKey) {
    return PieceType.values[(pieceKey.index / 3).toInt()];
  }

  static getPlayerColor(PieceKey pieceKey) {
    return PlayerColor.values[pieceKey.index % 3];
  }
}

enum Direction{bottomRight, bottom, bottomLeft, left, leftTop, top, topRight, right}

enum RequestType {
  Remi,
  Surrender,
  TakeBack,
}

enum TableAction { DrawOffer, TakebackRequest, SurrenderRequest }


enum PieceKey{PawnWhite, PawnBlack, PawnRed, RookWhite, RookBlack, RookRed, KnightWhite, KnightBlack, KnightRed, BishopWhite, BishopBlack, BishopRed, KingWhite, KingBlack, KingRed, QueenWhite, QueenBlack, QueenRed}
enum PieceType{Pawn, Rook, Knight, Bishop, King, Queen}
enum PlayerColor{white, black, red}

enum HowGameEnded {
  Remi,
  CheckMate,
  Surrender,
  Leave,
}

enum ResponseRole {
  Accept,
  Create,
  Decline,
}

enum MessageOwner{
  You,
  Server,
  Mate,
}
class ThinkingBoard {

  static checkEmpty(List list, int index){
    if(list.isNotEmpty && list.length > index){
      return list[index];
    }
    return null;
  }

  static PlayerColor _getCurrentPlayer(BoardStateBone boardState){
    return PlayerColor.values[boardState.chessMoves.length % 3];
  }

  static List<List<Direction>> _directionListKnight = [[Direction.left, Direction.top, Direction.top], [Direction.right, Direction.top, Direction.top], [Direction.top, Direction.left, Direction.left], [Direction.bottom, Direction.left, Direction.left], [Direction.left, Direction.bottom, Direction.bottom], [Direction.right, Direction.bottom, Direction.bottom], [Direction.top, Direction.right, Direction.right], [Direction.bottom, Direction.right, Direction.right]];
  static List<List<Direction>> _directionListKnight2 = [[Direction.top, Direction.top, Direction.left], [Direction.top, Direction.top, Direction.right], [Direction.left, Direction.left, Direction.top], [Direction.left, Direction.left, Direction.bottom], [Direction.bottom, Direction.bottom, Direction.left], [Direction.bottom, Direction.bottom, Direction.right], [Direction.right, Direction.right, Direction.top], [Direction.right, Direction.right, Direction.bottom]];

  static List<String> getLegalMove(
      String selectedTile, BoardStateBone boardState,) {
    if(selectedTile == null){
      return null;
    }
    Piece piece = boardState.pieces[selectedTile];
    if(piece == null){return [];}

    PlayerColor pieceColor = piece.playerColor;
    //region help

    _legalMovesPawn() {
      List<String> stepsInFront = _getPossibleStep(
        boardState: boardState,
        startingTile: selectedTile,
        direction: Direction.top,
        func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
        canMoveWithoutTake: true,
        canTake: false,
      );
      List<String> allLegalMoves = [
        ..._getPossibleStep(
          boardState: boardState,
          startingTile: selectedTile,
          direction: Direction.topRight,
          func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          canMoveWithoutTake: false,
        ),
        ..._getPossibleStep(
          boardState: boardState,
          startingTile: selectedTile,
          direction: Direction.leftTop,
          func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          canMoveWithoutTake: false,
        ),
        ...stepsInFront,
        if (boardState.pieces[selectedTile]?.didMove == false &&
            stepsInFront?.isNotEmpty == true)
          ..._getPossibleStep(
            boardState: boardState,
            startingTile: BoardData.adjacentTiles[selectedTile].top[0],
            direction: Direction.top,
            func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
            canMoveWithoutTake: true,
            canTake: false,
            twoStepWorkaroundPlayerColor: pieceColor,
          ),
      ];
      if (Tiles.numCoordinatesOf[BoardData.sideData[selectedTile]]
              .indexOf(selectedTile.substring(1)) ==
          3) {
        String possPassent =
            boardState.enpassent[BoardData.sideData[selectedTile]];
        if (possPassent != null && [
          checkEmpty(BoardData.adjacentTiles[selectedTile].left, 0),
          checkEmpty(BoardData.adjacentTiles[selectedTile].right, 0)
        ].contains(possPassent)) {
          allLegalMoves.add(BoardData.adjacentTiles[possPassent].bottom[0]);
        }
      }
      return allLegalMoves;
    }

    _legalMovesRook() {
      List<String> allLegalMoves = [];
      for (Direction direction
          in Direction.values.where((element) => element.index % 2 != 0)) {
        allLegalMoves += _getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }

    _legalMovesKnight() {
      List<String> allLegalMoves = [];
      for (List<Direction> directions
          in (_directionListKnight + _directionListKnight2)) {
        allLegalMoves += _getComplexStep(
          boardState: boardState,
          directions: directions,
          func: _canMoveOn(boardState.pieces[selectedTile].playerColor, boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves.toSet().toList();
    }

    _legalMovesBishop() {
      List<String> allLegalMoves = [];
      for (Direction direction
          in Direction.values.where((element) => element.index % 2 == 0)) {
        allLegalMoves += _getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn(_getCurrentPlayer(boardState), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }

    _legalMovesKing() {
      List<String> allLegalMoves = [];
      for (Direction direction in Direction.values) {
        allLegalMoves += _getPossibleStep(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn(_getCurrentPlayer(boardState), boardState,
              checkAttacked: true),
          startingTile: selectedTile,
        );
      }
      //Castling check
      if (!boardState.pieces[selectedTile].didMove && selectedTile == Tiles.getEqualCoordinate("E1", boardState.pieces[selectedTile].playerColor)) {
        Map<String, Piece> rooks = {
          "left": boardState.pieces[Tiles.getEqualCoordinate("A1", _getCurrentPlayer(boardState))],
          "right": boardState.pieces[Tiles.getEqualCoordinate("H1", _getCurrentPlayer(boardState))]
        };
        Map<String, Piece> usableRooks = {};
        rooks.entries.forEach((element) {
          if (element.value != null) {
            if (!element.value.didMove) {
              usableRooks[element.key] = element.value;
            }
          }
        });
        for (MapEntry pieceEntry in usableRooks.entries) {
          if (pieceEntry.key == "left") {
            if (boardState.pieces[
                        BoardData.adjacentTiles[selectedTile].left[0]] ==
                    null &&
                boardState.pieces[BoardData
                        .adjacentTiles[
                            BoardData.adjacentTiles[selectedTile].left[0]]
                        .left[0]] ==
                    null &&
                boardState.pieces[BoardData
                        .adjacentTiles[BoardData
                            .adjacentTiles[
                                BoardData.adjacentTiles[selectedTile].left[0]]
                            .left[0]]
                        .left[0]] ==
                    null) {
              if (!isTileCovered(
                  boardState: boardState,
                      toBeCheckedTile:
                          BoardData.adjacentTiles[selectedTile].left[0],
                      requestingPlayer: pieceColor) &&
                  !isTileCovered(
                      boardState: boardState,
                      toBeCheckedTile: BoardData
                          .adjacentTiles[
                              BoardData.adjacentTiles[selectedTile].left[0]]
                          .left[0],
                      requestingPlayer: pieceColor)) {
                //IF WE WANT MORE CASTELING OPTIONS ADD HERE
                allLegalMoves.add(BoardData
                    .adjacentTiles[
                        BoardData.adjacentTiles[selectedTile].left[0]]
                    .left[0]);
              }
            }
          } else if (pieceEntry.key == "right") {
            if (boardState.pieces[
                        BoardData.adjacentTiles[selectedTile].right[0]] ==
                    null &&
                boardState.pieces[BoardData
                        .adjacentTiles[
                            BoardData.adjacentTiles[selectedTile].right[0]]
                        .right[0]] ==
                    null) {
              if (!isTileCovered(
                      boardState: boardState,
                      toBeCheckedTile:
                          BoardData.adjacentTiles[selectedTile].right[0],
                      requestingPlayer: pieceColor) &&
                  !isTileCovered(
                      boardState: boardState,
                      toBeCheckedTile: BoardData
                          .adjacentTiles[
                              BoardData.adjacentTiles[selectedTile].right[0]]
                          .right[0],
                      requestingPlayer: pieceColor)) {
                //IF WE WANT MORE CASTELING OPTIONS ADD HERE
                allLegalMoves.add(BoardData
                    .adjacentTiles[
                        BoardData.adjacentTiles[selectedTile].right[0]]
                    .right[0]);
              }
            }
          }
        }
      }

      return allLegalMoves;
    }

    _legalMovesQueen() {
      List<String> allLegalMoves = [];
      for (Direction direction in Direction.values) {
        allLegalMoves += _getPossibleLine(
          boardState: boardState,
          direction: direction,
          func: _canMoveOn((PlayerColor.values[boardState.chessMoves.length % 3]), boardState),
          startingTile: selectedTile,
        );
      }
      return allLegalMoves;
    }
    //region end

    List<String> result = [];
    switch (piece.pieceType) {
    //Should not be null, but we dont like errors (talking to my self rn)
      case PieceType.Pawn:
        result.addAll(_legalMovesPawn());
        break;
      case PieceType.Rook:
        result.addAll(_legalMovesRook());
        break;
      case PieceType.Knight:
        result.addAll(_legalMovesKnight());
        break;
      case PieceType.Bishop:
        result.addAll(_legalMovesBishop());
        break;
      case PieceType.King:
        result.addAll(_legalMovesKing());
        break;
      case PieceType.Queen:
        result.addAll(_legalMovesQueen());
        break;
    }

   // Check for checks and therefor remove
    //print(result.toString());
    result.removeWhere((element) {
      bool resultRemove = false;
      BoardStateBone virtualState = boardState.cloneBones();

      if (virtualState.pieces[element]?.pieceType != PieceType.King) {
        virtualState.movePieceTo(piece.position, element);
      }

      resultRemove = isCheck(piece.playerColor, virtualState);
      return resultRemove;
    });
    return result;
  }

  static bool isCheck(PlayerColor toBeChecked, BoardStateBone boardState) {
    return isTileCovered(
      boardState: boardState,
      requestingPlayer: toBeChecked,
      toBeCheckedTile: boardState.pieces
          .values
          .firstWhere((currPiece) => currPiece.pieceType == PieceType.King && currPiece.playerColor == toBeChecked)
          .position);
  }

  static bool anyLegalMove(PlayerColor toBeChecked, BoardStateBone boardState){
    bool result = false;
    for (Piece piece in boardState.pieces.values.where((element) => element.playerColor == toBeChecked).toList()) {
      for (String legalMove in getLegalMove(piece.position, boardState)) {

        BoardStateBone virtualState = boardState.cloneBones();
        virtualState.movePieceTo(piece.position, legalMove);

        if (!isCheck(toBeChecked, virtualState)) {
          result = true;
        }
        if (result) {
          break;
        }
      }
    }
    return result;
  }

  static bool isCheckMate(
      PlayerColor toBeChecked, BoardStateBone boardState) {
    bool result = false;
    if (isCheck(toBeChecked, boardState)) {
      result = true;
      for (Piece piece in boardState.pieces.values.where((element) => element.playerColor == toBeChecked).toList()) {
        for (String legalMove in getLegalMove(piece.position, boardState)) {

          BoardStateBone virtualState = boardState.cloneBones();
          virtualState.movePieceTo(piece.position, legalMove);

          if (!isCheck(toBeChecked, virtualState)) {
            result = false;
          }
          if (!result) {
            break;
          }
        }
      }
    }
    return result;
  }

  static bool isTileCovered(
      {String toBeCheckedTile,
      PlayerColor requestingPlayer,
        BoardStateBone boardState}) {
    //Bishop, 1/2Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      if (_getPossibleLine(
        boardState: boardState,
        stopOnFirst: true,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Bishop, PieceType.Queen], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
        //startingColor: requestingPlayer,
      ).length >
          0) {
        return true;
      }
    }

    //print("I got past Bishop in tile covered");

    //Rook, 2/2 Queen
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 1)) {
      if (_getPossibleLine(
        boardState: boardState,
        stopOnFirst: true,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Rook, PieceType.Queen], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
        //startingColor: requestingPlayer,
      ).length >
          0) {
        return true;
      }
    }

   // print("I got past rook in tile covered");

    //King
    for (Direction direction in Direction.values) {
      if (_getPossibleStep(
        boardState: boardState,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.King], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      ).length >
          0) {
        return true;
      }
    }

   // print("I got past King in tile covered");

    //Knight
    for (List<Direction> directions in (_directionListKnight + _directionListKnight2)) {
      if (_getComplexStep(
        boardState: boardState,
        directions: directions,
        //startingColor: requestingPlayer,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Knight], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      ).length >
          0) {
        return true;
      }
    }

    //Pawns
    for (Direction direction in Direction.values.where((element) => element.index % 2 == 0)) {
      List<String> possMoves = _getPossibleStep(
        boardState: boardState,
        direction: direction,
        func: _occupiedBy(boardState: boardState, typesToLookFor: [PieceType.Pawn], requestingPlayer: requestingPlayer),
        startingTile: toBeCheckedTile,
      );

      for (String move in possMoves) {
        if (BoardData.adjacentTiles[move]
            .getRelativeEnum(Direction.leftTop, boardState.pieces[move].playerColor, BoardData.sideData[toBeCheckedTile])
            .contains(toBeCheckedTile) ||
            BoardData.adjacentTiles[move]
                .getRelativeEnum(Direction.topRight, boardState.pieces[move].playerColor, BoardData.sideData[toBeCheckedTile])
                .contains(toBeCheckedTile)) {
          return true;
        }
      }
    }

   // print("I got past Knight in tile covered");

    return false;
  }

  static Function _canMoveOn(PlayerColor requestingPlayer, BoardStateBone boardState,
      {bool checkAttacked = false}) {
    return (String toBeCheckedTile) {
      bool result = false;
      Piece piece = boardState.pieces[toBeCheckedTile];
      if (piece == null) {
        result = true;
      } else if (piece.playerColor != requestingPlayer) {
        result = null;
      }
      if (checkAttacked && (result != false)) {
        if (isTileCovered(
            boardState: boardState,
            toBeCheckedTile: toBeCheckedTile,
            requestingPlayer: requestingPlayer)) {
          return false;
        }
      }
      return result;
    };
  }

  ///Returns true if given Tile is occupied by one of the given PieceTypes of opposing PlayerColor
  static Function _occupiedBy(
      {BoardStateBone boardState,
      List<PieceType> typesToLookFor,
      PlayerColor requestingPlayer}) {
    return (String toBeCheckedTile, ) {
      bool result = false;
      Piece piece = boardState.pieces[toBeCheckedTile];
      if (piece != null) {
        if (piece.playerColor != requestingPlayer &&
            typesToLookFor.contains(piece.pieceType)) {
          result = true;
          //print("occupy says yes with ${piece.pieceType} when ${typesToLookFor[0]} at $toBeCheckedTile of ${piece.playerColor}");
        }
      }
      return result;
    };
  }

  static List<String> _getComplexStep({BoardStateBone boardState, List<Direction> directions, String startingTile, bool func(String tile), PlayerColor startingColor}) {
    startingColor ??= BoardData.sideData[startingTile];
    void _nextSteps(List<String> allMoves, int index, String currentTile) {
      List<String> nextTiles =
      BoardData.adjacentTiles[currentTile]?.getRelativeEnum(directions[index], startingColor, BoardData.sideData[currentTile]);
      if (nextTiles.length > 0) {
        if (index == directions.length - 1) {
          if (func(nextTiles[0]) != false) {
            allMoves.add(nextTiles[0]);
          }
        } else {
          _nextSteps(allMoves, index + 1, nextTiles[0]);
        }
      }
    }

    List<String> resultList = [];
    _nextSteps(resultList, 0, startingTile);
    return resultList;
  }

  static List<String> _getPossibleLine(
      {BoardStateBone boardState, Direction direction, String startingTile, bool func(String tile), bool stopOnFirst = false, PlayerColor startingColor}) {
    startingColor ??= BoardData.sideData[startingTile];
    void _nextStep(List<String> allMoves, String currentTile) {
      List<String> nextTiles =
      BoardData.adjacentTiles[currentTile]?.getRelativeEnum(direction, startingColor, BoardData.sideData[currentTile]);
      for (String tile in nextTiles) {
        bool evualtion = func(tile);
        if (evualtion == true && !stopOnFirst) {
          allMoves.add(tile);
          _nextStep(allMoves, tile);
        } else if (evualtion == null || (evualtion == true && stopOnFirst)) {
          allMoves.add(tile);
        } else if (evualtion == false) {
          if (stopOnFirst && boardState.pieces[tile] == null) {
            _nextStep(allMoves, tile);
          }
        }
      }
    }

    List<String> resultList = [];
    _nextStep(resultList, startingTile);
    return resultList;
  }

  static _getPossibleStep(
      {BoardStateBone boardState,
      Direction direction,
      String startingTile,
      bool func(String tile),
      bool canTake = true,
      bool canMoveWithoutTake = true,
      PlayerColor twoStepWorkaroundPlayerColor}) {
    twoStepWorkaroundPlayerColor ??=
        boardState.pieces[startingTile]?.playerColor;
    twoStepWorkaroundPlayerColor ??= BoardData.sideData[startingTile];
    List<String> nextTiles = BoardData.adjacentTiles[startingTile]
        ?.getRelativeEnum(direction, twoStepWorkaroundPlayerColor,
            BoardData.sideData[startingTile]);
    List<String> resultList = [];
    for (String tile in nextTiles) {
      if (func(tile) == true && canMoveWithoutTake) {
        //if tile is empty
        //yes: add to result
        resultList.add(tile);
        // if legal and not a take
      } else if (func(tile) == null && canTake) {
        //if tile has enemy Piece && taking is enabled (default = true)
        resultList.add(tile);
      }
    }
    return resultList;
  }
}
class BoardData {
  static Map<String, bool> tileWhiteData = {
    "A1": false,
    "B1": true,
    "C1": false,
    "D1": true,
    "E1": false,
    "F1": true,
    "G1": false,
    "H1": true,
    "A2": true,
    "B2": false,
    "C2": true,
    "D2": false,
    "E2": true,
    "F2": false,
    "G2": true,
    "H2": false,
    "A3": false,
    "B3": true,
    "C3": false,
    "D3": true,
    "E3": false,
    "F3": true,
    "G3": false,
    "H3": true,
    "A4": true,
    "B4": false,
    "C4": true,
    "D4": false,
    "E4": true,
    "F4": false,
    "G4": true,
    "H4": false,
    "A8": true,
    "B8": false,
    "C8": true,
    "D8": false,
    "I8": true,
    "J8": false,
    "K8": true,
    "L8": false,
    "A7": false,
    "B7": true,
    "C7": false,
    "D7": true,
    "I7": false,
    "J7": true,
    "K7": false,
    "L7": true,
    "A6": true,
    "B6": false,
    "C6": true,
    "D6": false,
    "I6": true,
    "J6": false,
    "K6": true,
    "L6": false,
    "A5": false,
    "B5": true,
    "C5": false,
    "D5": true,
    "I5": false,
    "J5": true,
    "K5": false,
    "L5": true,
    "L12": true,
    "K12": false,
    "J12": true,
    "I12": false,
    "E12": true,
    "F12": false,
    "G12": true,
    "H12": false,
    "L11": false,
    "K11": true,
    "J11": false,
    "I11": true,
    "E11": false,
    "F11": true,
    "G11": false,
    "H11": true,
    "L10": true,
    "K10": false,
    "J10": true,
    "I10": false,
    "E10": true,
    "F10": false,
    "G10": true,
    "H10": false,
    "L9": false,
    "K9": true,
    "J9": false,
    "I9": true,
    "E9": false,
    "F9": true,
    "G9": false,
    "H9": true,
  };

  static Map<String, PlayerColor> sideData = {
    "A1": PlayerColor.white,
    "B1": PlayerColor.white,
    "C1": PlayerColor.white,
    "D1": PlayerColor.white,
    "E1": PlayerColor.white,
    "F1": PlayerColor.white,
    "G1": PlayerColor.white,
    "H1": PlayerColor.white,
    "A2": PlayerColor.white,
    "B2": PlayerColor.white,
    "C2": PlayerColor.white,
    "D2": PlayerColor.white,
    "E2": PlayerColor.white,
    "F2": PlayerColor.white,
    "G2": PlayerColor.white,
    "H2": PlayerColor.white,
    "A3": PlayerColor.white,
    "B3": PlayerColor.white,
    "C3": PlayerColor.white,
    "D3": PlayerColor.white,
    "E3": PlayerColor.white,
    "F3": PlayerColor.white,
    "G3": PlayerColor.white,
    "H3": PlayerColor.white,
    "A4": PlayerColor.white,
    "B4": PlayerColor.white,
    "C4": PlayerColor.white,
    "D4": PlayerColor.white,
    "E4": PlayerColor.white,
    "F4": PlayerColor.white,
    "G4": PlayerColor.white,
    "H4": PlayerColor.white,
    "L8": PlayerColor.black,
    "K8": PlayerColor.black,
    "J8": PlayerColor.black,
    "I8": PlayerColor.black,
    "D8": PlayerColor.black,
    "C8": PlayerColor.black,
    "B8": PlayerColor.black,
    "A8": PlayerColor.black,
    "L7": PlayerColor.black,
    "K7": PlayerColor.black,
    "J7": PlayerColor.black,
    "I7": PlayerColor.black,
    "D7": PlayerColor.black,
    "C7": PlayerColor.black,
    "B7": PlayerColor.black,
    "A7": PlayerColor.black,
    "L6": PlayerColor.black,
    "K6": PlayerColor.black,
    "J6": PlayerColor.black,
    "I6": PlayerColor.black,
    "D6": PlayerColor.black,
    "C6": PlayerColor.black,
    "B6": PlayerColor.black,
    "A6": PlayerColor.black,
    "L5": PlayerColor.black,
    "K5": PlayerColor.black,
    "J5": PlayerColor.black,
    "I5": PlayerColor.black,
    "D5": PlayerColor.black,
    "C5": PlayerColor.black,
    "B5": PlayerColor.black,
    "A5": PlayerColor.black,
    "H12": PlayerColor.red,
    "G12": PlayerColor.red,
    "F12": PlayerColor.red,
    "E12": PlayerColor.red,
    "I12": PlayerColor.red,
    "J12": PlayerColor.red,
    "K12": PlayerColor.red,
    "L12": PlayerColor.red,
    "H11": PlayerColor.red,
    "G11": PlayerColor.red,
    "F11": PlayerColor.red,
    "E11": PlayerColor.red,
    "I11": PlayerColor.red,
    "J11": PlayerColor.red,
    "K11": PlayerColor.red,
    "L11": PlayerColor.red,
    "H10": PlayerColor.red,
    "G10": PlayerColor.red,
    "F10": PlayerColor.red,
    "E10": PlayerColor.red,
    "I10": PlayerColor.red,
    "J10": PlayerColor.red,
    "K10": PlayerColor.red,
    "L10": PlayerColor.red,
    "H9": PlayerColor.red,
    "G9": PlayerColor.red,
    "F9": PlayerColor.red,
    "E9": PlayerColor.red,
    "I9": PlayerColor.red,
    "J9": PlayerColor.red,
    "K9": PlayerColor.red,
    "L9": PlayerColor.red,
  };


  //Starting right bottom relative to white and iterating clockwise (1 right bottom, 2 left bottom, 3 left top, 4 right top)
  // White:
  //first Row:


  static Map<String, List<Point>> tileData = {
    "A1" : [
      Point(311.9881334220872, 865.3737874782529),
      Point(249.65149531756003, 865.3737874782529),
      Point(218.61358764208416, 811.7138756862989),
      Point(287.9924400931479, 797.6476852165636),
    ],
    "B1" : [
      Point(374.063948773039, 865.113302469554),
      Point(311.9881334220872, 865.3737874782529),
      Point(287.9924400931479, 797.6476852165636),
      Point(358.9362290656642, 784.3629497729245),
    ],
    "C1" : [
      Point(437.1830551382925, 865.113302469554),
      Point(374.063948773039, 865.113302469554),
      Point(358.9362290656642, 784.3629497729245),
      Point(429.3583725310296, 771.599184346683),
    ],
    "D1" : [
      Point(500.5629842571214, 864.9830599652047),
      Point(437.1830551382925, 865.113302469554),
      Point(429.3583725310296, 771.599184346683),
      Point(500.0413387499706, 758.1842063986946),
    ],
    "E1" : [
      Point(562.6387996080733, 865.8947574956505),
      Point(500.5629842571214, 864.9830599652047),
      Point(500.0413387499706, 758.1842063986946),
      Point(570.4634822153361, 771.3386993379842),
    ],
    "F1" : [
      Point(625.105849089388, 866.025),
      Point(562.6387996080733, 865.8947574956505),
      Point(570.4634822153361, 771.3386993379842),
      Point(640.4943915503383, 785.2746473033703),
    ],
    "G1" : [
      Point(687.9641327010662, 865.5040299826022),
      Point(625.105849089388, 866.025),
      Point(640.4943915503383, 785.2746473033703),
      Point(710.9165350157037, 798.6896252513587),
    ],
    "H1" : [
      Point(750.0399480520178, 865.5040299826022),
      Point(687.9641327010662, 865.5040299826022),
      Point(710.9165350157037, 798.6896252513587),
      Point(780.034564713192, 811.7138756862989),
    ],
    "A2" : [
      Point(287.9924400931479, 797.6476852165636),
      Point(218.61358764208416, 811.7138756862989),
      Point(186.92362308266965, 757.6632363812969),
      Point(264.12715814099624, 730.5727954766213),
    ],
    "B2" : [
      Point(358.9362290656642, 784.3629497729245),
      Point(287.9924400931479, 797.6476852165636),
      Point(264.12715814099624, 730.5727954766213),
      Point(342.7652183439877, 703.6125970762948),
    ],
    "C2" : [
      Point(429.3583725310296, 771.599184346683),
      Point(358.9362290656642, 784.3629497729245),
      Point(342.7652183439877, 703.6125970762948),
      Point(421.4032785469791, 676.6523986759685),
    ],
    "D2" : [
      Point(500.0413387499706, 758.1842063986946),
      Point(429.3583725310296, 771.599184346683),
      Point(421.4032785469791, 676.6523986759685),
      Point(499.51969324281964, 650.2131702930398),
    ],
    "E2" : [
      Point(570.4634822153361, 771.3386993379842),
      Point(500.0413387499706, 758.1842063986946),
      Point(499.51969324281964, 650.2131702930398),
      Point(577.5056965618726, 676.6523986759685),
    ],
    "F2" : [
      Point(640.4943915503383, 785.2746473033703),
      Point(570.4634822153361, 771.3386993379842),
      Point(577.5056965618726, 676.6523986759685),
      Point(656.0133453880763, 703.6125970762948),
    ],
    "G2" : [
      Point(710.9165350157037, 798.6896252513587),
      Point(640.4943915503383, 785.2746473033703),
      Point(656.0133453880763, 703.6125970762948),
      Point(734.52099421428, 730.4425529722719),
    ],
    "H2" : [
      Point(780.034564713192, 811.7138756862989),
      Point(710.9165350157037, 798.6896252513587),
      Point(734.52099421428, 730.4425529722719),
      Point(812.1157634029697, 757.9237213899958),
    ],
    "A3" : [
      Point(264.12715814099624, 730.5727954766213),
      Point(186.92362308266965, 757.6632363812969),
      Point(156.27694953755693, 703.0916270588974),
      Point(241.56598995672178, 662.8466932149319),
    ],
    "B3" : [
      Point(342.7652183439877, 703.6125970762948),
      Point(264.12715814099624, 730.5727954766213),
      Point(241.56598995672178, 662.8466932149319),
      Point(327.76791001340064, 622.7320018753159),
    ],
    "C3" : [
      Point(421.4032785469791, 676.6523986759685),
      Point(342.7652183439877, 703.6125970762948),
      Point(327.76791001340064, 622.7320018753159),
      Point(413.709007316504, 582.0963405183022),
    ],
    "D3" : [
      Point(499.51969324281964, 650.2131702930398),
      Point(421.4032785469791, 676.6523986759685),
      Point(413.709007316504, 582.0963405183022),
      Point(500.1717501267582, 541.2001941525899),
    ],
    "E3" : [
      Point(577.5056965618726, 676.6523986759685),
      Point(499.51969324281964, 650.2131702930398),
      Point(500.1717501267582, 541.2001941525899),
      Point(585.8520246762862, 582.0963405183022),
    ],
    "F3" : [
      Point(656.0133453880763, 703.6125970762948),
      Point(577.5056965618726, 676.6523986759685),
      Point(585.8520246762862, 582.0963405183022),
      Point(672.3147674865404, 622.7320018753159),
    ],
    "G3" : [
      Point(734.52099421428, 730.4425529722719),
      Point(656.0133453880763, 703.6125970762948),
      Point(672.3147674865404, 622.7320018753159),
      Point(758.1254534128562, 663.1071782236307),
    ],
    "H3" : [
      Point(812.1157634029697, 757.9237213899958),
      Point(734.52099421428, 730.4425529722719),
      Point(758.1254534128562, 663.1071782236307),
      Point(843.5449052088087, 704.003324589343),
    ],
    "A4" : [
      Point(241.56598995672178, 662.8466932149319),
      Point(156.27694953755693, 703.0916270588974),
      Point(124.45657360135475, 649.4317152669433),
      Point(217.70070800457015, 595.6415609706402),
    ],
    "B4" : [
      Point(327.76791001340064, 622.7320018753159),
      Point(241.56598995672178, 662.8466932149319),
      Point(217.70070800457015, 595.6415609706402),
      Point(311.5968992917241, 541.3304366569392),
    ],
    "C4" : [
      Point(413.709007316504, 582.0963405183022),
      Point(327.76791001340064, 622.7320018753159),
      Point(311.5968992917241, 541.3304366569392),
      Point(405.75391333245346, 487.4100398562866),
    ],
    "D4" : [
      Point(500.1717501267582, 541.2001941525899),
      Point(413.709007316504, 582.0963405183022),
      Point(405.75391333245346, 487.4100398562866),
      Point(500.0413387499706, 433.0989155425857),
    ],
    "E4" : [
      Point(585.8520246762862, 582.0963405183022),
      Point(500.1717501267582, 541.2001941525899),
      Point(500.0413387499706, 433.0989155425857),
      Point(594.3287641674876, 487.540282360636),
    ],
    "F4" : [
      Point(672.3147674865404, 622.7320018753159),
      Point(585.8520246762862, 582.0963405183022),
      Point(594.3287641674876, 487.540282360636),
      Point(687.7033099474907, 541.4606791612887),
    ],
    "G4" : [
      Point(758.1254534128562, 663.1071782236307),
      Point(672.3147674865404, 622.7320018753159),
      Point(687.7033099474907, 541.4606791612887),
      Point(782.1211467417955, 595.5113184662907),
    ],
    "H4" : [
      Point(843.5449052088087, 704.003324589343),
      Point(758.1254534128562, 663.1071782236307),
      Point(782.1211467417955, 595.5113184662907),
      Point(874.84363563786, 649.6922002756422),
    ],
    "A8" : [
      Point(31.168319052263577, 379.60944329307694),
      Point(0, 433.524649019401),
      Point(31.012147041415908, 487.19941446112085),
      Point(77.89904631293946, 434.2264648290337),
    ],
    "B8" : [
      Point(62.43210585822086, 326.05006670594054),
      Point(31.168319052263577, 379.60944329307694),
      Point(77.89904631293946, 434.2264648290337),
      Point(124.89077645374542, 379.50926787486947),
    ],
    "C8" : [
      Point(93.9916590408476, 271.458101075102),
      Point(62.43210585822086, 326.05006670594054),
      Point(124.89077645374542, 379.50926787486947),
      Point(171.16992558001317, 324.9827591816827),
    ],
    "D8" : [
      Point(125.79456316550275, 216.70567006159987),
      Point(93.9916590408476, 271.458101075102),
      Point(171.16992558001317, 324.9827591816827),
      Point(218.1441839092722, 270.55627011453134),
    ],
    "I8" : [
      Point(156.04189388429398, 162.56020220489108),
      Point(125.79456316550275, 216.70567006159987),
      Point(218.1441839092722, 270.55627011453134),
      Point(241.94835955264776, 203.070632238579),
    ],
    "J8" : [
      Point(187.1624790597106, 108.46708190897333),
      Point(156.04189388429398, 162.56020220489108),
      Point(241.94835955264776, 203.070632238579),
      Point(264.87928073939764, 135.5326468018359),
    ],
    "K8" : [
      Point(219.0433791265125, 54.36118792167173),
      Point(187.1624790597106, 108.46708190897333),
      Point(264.87928073939764, 135.5326468018359),
      Point(288.4575772522921, 67.91676642153412),
    ],
    "L8" : [
      Point(250.0812868019883, 0.6715688301860778),
      Point(219.0433791265125, 54.36118792167173),
      Point(288.4575772522921, 67.91676642153412),
      Point(311.7226355769699, 1.6241829719473702),
    ],
    "A7" : [
      Point(77.89904631293946, 434.2264648290337),
      Point(31.012147041415908, 487.19941446112085),
      Point(62.03708433658439, 541.6335102464602),
      Point(124.13028143580586, 488.40508678669806),
    ],
    "B7" : [
      Point(124.89077645374542, 379.50926787486947),
      Point(77.89904631293946, 434.2264648290337),
      Point(124.13028143580586, 488.40508678669806),
      Point(186.82780154211912, 433.87081558315117),
    ],
    "C7" : [
      Point(171.16992558001317, 324.9827591816827),
      Point(124.89077645374542, 379.50926787486947),
      Point(186.82780154211912, 433.87081558315117),
      Point(249.52532164843245, 379.33654437960433),
    ],
    "D7" : [
      Point(218.1441839092722, 270.55627011453134),
      Point(171.16992558001317, 324.9827591816827),
      Point(249.52532164843245, 379.33654437960433),
      Point(311.51026074020746, 324.99296143703515),
    ],
    "I7" : [
      Point(241.94835955264776, 203.070632238579),
      Point(218.1441839092722, 270.55627011453134),
      Point(311.51026074020746, 324.99296143703515),
      Point(327.576530655879, 244.32294342895617),
    ],
    "J7" : [
      Point(264.87928073939764, 135.5326468018359),
      Point(241.94835955264776, 203.070632238579),
      Point(327.576530655879, 244.32294342895617),
      Point(343.45186506416337, 162.941267142502),
    ],
    "K7" : [
      Point(288.4575772522921, 67.91676642153412),
      Point(264.87928073939764, 135.5326468018359),
      Point(343.45186506416337, 162.941267142502),
      Point(359.44013903768837, 81.62471210822264),
    ],
    "L7" : [
      Point(311.7226355769699, 1.6241829719473702),
      Point(288.4575772522921, 67.91676642153412),
      Point(359.44013903768837, 81.62471210822264),
      Point(374.40727536625303, 0.7721040350033401),
    ],
    "A6" : [
      Point(124.13028143580586, 488.40508678669806),
      Point(62.03708433658439, 541.6335102464602),
      Point(94.03542539986647, 595.4257445011457),
      Point(171.5782712688142, 541.7813818310449),
    ],
    "B6" : [
      Point(186.82780154211912, 433.87081558315117),
      Point(124.13028143580586, 488.40508678669806),
      Point(171.5782712688142, 541.7813818310449),
      Point(249.46461739127824, 487.28234468683576),
    ],
    "C6" : [
      Point(249.52532164843245, 379.33654437960433),
      Point(186.82780154211912, 433.87081558315117),
      Point(249.46461739127824, 487.28234468683576),
      Point(327.6723103979172, 433.2693791861637),
    ],
    "D6" : [
      Point(311.51026074020746, 324.99296143703515),
      Point(249.52532164843245, 379.33654437960433),
      Point(327.6723103979172, 433.2693791861637),
      Point(406.36670528861293, 378.93548292016453),
    ],
    "I6" : [
      Point(327.576530655879, 244.32294342895617),
      Point(311.51026074020746, 324.99296143703515),
      Point(406.36670528861293, 378.93548292016453),
      Point(413.74381907780827, 284.3822001929676),
    ],
    "J6" : [
      Point(343.45186506416337, 162.941267142502),
      Point(327.576530655879, 244.32294342895617),
      Point(413.74381907780827, 284.3822001929676),
      Point(421.7380461278481, 189.28240006560554),
    ],
    "K6" : [
      Point(359.44013903768837, 81.62471210822264),
      Point(343.45186506416337, 162.941267142502),
      Point(421.7380461278481, 189.28240006560554),
      Point(429.63212386640015, 94.87680902968825),
    ],
    "L6" : [
      Point(374.40727536625303, 0.7721040350033401),
      Point(359.44013903768837, 81.62471210822264),
      Point(429.63212386640015, 94.87680902968825),
      Point(436.87882627880754, 0.5491129373295274),
    ],
    "A5" : [
      Point(171.5782712688142, 541.7813818310449),
      Point(94.03542539986647, 595.4257445011457),
      Point(124.65633831091914, 649.7772698473801),
      Point(217.92244595692122, 596.025125040884),
    ],
    "B5" : [
      Point(249.46461739127824, 487.28234468683576),
      Point(171.5782712688142, 541.7813818310449),
      Point(217.92244595692122, 596.025125040884),
      Point(311.9663403058553, 541.969498655991),
    ],
    "C5" : [
      Point(327.6723103979172, 433.2693791861637),
      Point(249.46461739127824, 487.28234468683576),
      Point(311.9663403058553, 541.969498655991),
      Point(405.801827335855, 487.4929218797359),
    ],
    "D5" : [
      Point(406.36670528861293, 378.93548292016453),
      Point(327.6723103979172, 433.2693791861637),
      Point(405.801827335855, 487.4929218797359),
      Point(500.0413387499706, 433.0989155425857),
    ],
    "I5" : [
      Point(413.74381907780827, 284.3822001929676),
      Point(406.36670528861293, 378.93548292016453),
      Point(500.0413387499706, 433.0989155425857),
      Point(499.97631318813137, 324.32866363956003),
    ],
    "J5" : [
      Point(421.7380461278481, 189.28240006560554),
      Point(413.74381907780827, 284.3822001929676),
      Point(499.97631318813137, 324.32866363956003),
      Point(499.90660606849787, 216.60844996716676),
    ],
    "K5" : [
      Point(429.63212386640015, 94.87680902968825),
      Point(421.7380461278481, 189.28240006560554),
      Point(499.90660606849787, 216.60844996716676),
      Point(500.24560489077453, 107.92076850324611),
    ],
    "L5" : [
      Point(436.87882627880754, 0.5491129373295274),
      Point(429.63212386640015, 94.87680902968825),
      Point(500.24560489077453, 107.92076850324611),
      Point(499.6239901986902, 0.6342789135988298),
    ],
    "L12" : [
      Point(780.8611531197942, 54.313515856427266),
      Point(749.6928340675308, 0.3983101301032266),
      Point(687.6427793506391, 0.3834564803374008),
      Point(710.134732530179, 67.42259658215981),
    ],
    "K12" : [
      Point(811.6731816647888, 108.13337745226258),
      Point(780.8611531197942, 54.313515856427266),
      Point(710.134732530179, 67.42259658215981),
      Point(734.0867913618893, 135.42452897996318),
    ],
    "J12" : [
      Point(843.2327348474157, 162.7253430831012),
      Point(811.6731816647888, 108.13337745226258),
      Point(734.0867913618893, 135.42452897996318),
      Point(758.2297857009871, 202.7148030993913),
    ],
    "I12" : [
      Point(874.8097598415894, 217.60801660095262),
      Point(843.2327348474157, 162.7253430831012),
      Point(758.2297857009871, 202.7148030993913),
      Point(781.938493590669, 270.55627011453134),
    ],
    "E12" : [
      Point(906.6382444737499, 270.84178692721554),
      Point(874.8097598415894, 217.60801660095262),
      Point(781.938493590669, 270.55627011453134),
      Point(828.5564614126589, 324.887415051194),
    ],
    "F12" : [
      Point(937.984708779648, 324.8046647187838),
      Point(906.6382444737499, 270.84178692721554),
      Point(828.5564614126589, 324.887415051194),
      Point(875.656449560911, 378.48945252255106),
    ],
    "G12" : [
      Point(968.9620923245242, 379.4315287234832),
      Point(937.984708779648, 324.8046647187838),
      Point(875.656449560911, 378.48945252255106),
      Point(922.5002965133822, 432.69035495486435),
    ],
    "H12" : [
      Point(1000, 433.121147814969),
      Point(968.9620923245242, 379.4315287234832),
      Point(922.5002965133822, 432.69035495486435),
      Point(968.3532678861927, 485.9586879695108),
    ],
    "L11" : [
      Point(710.134732530179, 67.42259658215981),
      Point(687.6427793506391, 0.3834564803374008),
      Point(624.9278774960559, 0),
      Point(640.0382154551611, 80.31886436443789),
    ],
    "K11" : [
      Point(734.0867913618893, 135.42452897996318),
      Point(710.134732530179, 67.42259658215981),
      Point(640.0382154551611, 80.31886436443789),
      Point(655.9787555518392, 161.8133339683111),
    ],
    "J11" : [
      Point(758.2297857009871, 202.7148030993913),
      Point(734.0867913618893, 135.42452897996318),
      Point(655.9787555518392, 161.8133339683111),
      Point(671.9192956485173, 243.3078035721843),
    ],
    "I11" : [
      Point(781.938493590669, 270.55627011453134),
      Point(758.2297857009871, 202.7148030993913),
      Point(671.9192956485173, 243.3078035721843),
      Point(688.0507712525828, 324.09061489768226),
    ],
    "E11" : [
      Point(828.5564614126589, 324.887415051194),
      Point(781.938493590669, 270.55627011453134),
      Point(688.0507712525828, 324.09061489768226),
      Point(749.970504655964, 378.3214045228325),
    ],
    "F11" : [
      Point(875.656449560911, 378.48945252255106),
      Point(828.5564614126589, 324.887415051194),
      Point(749.970504655964, 378.3214045228325),
      Point(812.6028190738836, 432.74288240896027),
    ],
    "G11" : [
      Point(922.5002965133822, 432.69035495486435),
      Point(875.656449560911, 378.48945252255106),
      Point(812.6028190738836, 432.74288240896027),
      Point(875.1221939265623, 487.22948154726265),
    ],
    "H11" : [
      Point(968.3532678861927, 485.9586879695108),
      Point(922.5002965133822, 432.69035495486435),
      Point(875.1221939265623, 487.22948154726265),
      Point(937.7498267866873, 540.6009212027581),
    ],
    "L10" : [
      Point(640.0382154551611, 80.31886436443789),
      Point(624.9278774960559, 0),
      Point(562.2828628876612, 0.779375067714162),
      Point(570.0290574378782, 94.6686715817804),
    ],
    "K10" : [
      Point(655.9787555518392, 161.8133339683111),
      Point(640.0382154551611, 80.31886436443789),
      Point(570.0290574378782, 94.6686715817804),
      Point(578.344631372093, 189.28240006560554),
    ],
    "J10" : [
      Point(671.9192956485173, 243.3078035721843),
      Point(655.9787555518392, 161.8133339683111),
      Point(578.344631372093, 189.28240006560554),
      Point(586.0780356685574, 283.9310269232912),
    ],
    "I10" : [
      Point(688.0507712525828, 324.09061489768226),
      Point(671.9192956485173, 243.3078035721843),
      Point(586.0780356685574, 283.9310269232912),
      Point(593.8463835881159, 379.16106955500265),
    ],
    "E10" : [
      Point(749.970504655964, 378.3214045228325),
      Point(688.0507712525828, 324.09061489768226),
      Point(593.8463835881159, 379.16106955500265),
      Point(672.1495443484484, 432.8182059164872),
    ],
    "F10" : [
      Point(812.6028190738836, 432.74288240896027),
      Point(749.970504655964, 378.3214045228325),
      Point(672.1495443484484, 432.8182059164872),
      Point(750.6180601086628, 487.28234468683576),
    ],
    "G10" : [
      Point(875.1221939265623, 487.22948154726265),
      Point(812.6028190738836, 432.74288240896027),
      Point(750.6180601086628, 487.28234468683576),
      Point(828.5346682964267, 541.3127593744383),
    ],
    "H10" : [
      Point(937.7498267866873, 540.6009212027581),
      Point(875.1221939265623, 487.22948154726265),
      Point(828.5346682964267, 541.3127593744383),
      Point(906.7074176799714, 594.7443091010846),
    ],
    "L9" : [
      Point(570.0290574378782, 94.6686715817804),
      Point(562.2828628876612, 0.779375067714162),
      Point(499.84157404040633, 0.08776151343364584),
      Point(499.8196007976196, 107.63006061623312),
    ],
    "K9" : [
      Point(578.344631372093, 189.28240006560554),
      Point(570.0290574378782, 94.6686715817804),
      Point(499.8196007976196, 107.63006061623312),
      Point(499.6718977358395, 215.9968113148269),
    ],
    "J9" : [
      Point(586.0780356685574, 283.9310269232912),
      Point(578.344631372093, 189.28240006560554),
      Point(499.6718977358395, 215.9968113148269),
      Point(499.99342474656913, 324.3937848917347),
    ],
    "I9" : [
      Point(593.8463835881159, 379.16106955500265),
      Point(586.0780356685574, 283.9310269232912),
      Point(499.99342474656913, 324.3937848917347),
      Point(500.0413387499706, 433.0989155425857),
    ],
    "E9" : [
      Point(672.1495443484484, 432.8182059164872),
      Point(593.8463835881159, 379.16106955500265),
      Point(500.0413387499706, 433.0989155425857),
      Point(594.3937897293268, 487.427800627561),
    ],
    "F9" : [
      Point(750.6180601086628, 487.28234468683576),
      Point(672.1495443484484, 432.8182059164872),
      Point(594.3937897293268, 487.427800627561),
      Point(687.8380426289634, 541.2276174993018),
    ],
    "G9" : [
      Point(828.5346682964267, 541.3127593744383),
      Point(750.6180601086628, 487.28234468683576),
      Point(687.8380426289634, 541.2276174993018),
      Point(781.9168806009912, 595.8646596582203),
    ],
    "H9" : [
      Point(906.7074176799714, 594.7443091010846),
      Point(828.5346682964267, 541.3127593744383),
      Point(781.9168806009912, 595.8646596582203),
      Point(875.2609841891401, 648.9702674385161),
    ],
  };



  //Strings of player

  static final Map<String, Directions> adjacentTiles = {
    "A1": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: [], leftTop: [], top: ["A2"], topRight: ["B2"], right: ["B1"]),
    "B1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["A1"], leftTop: ["A2"], top: ["B2"], topRight: ["C2"], right: ["C1"]),
    "C1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["B1"], leftTop: ["B2"], top: ["C2"], topRight: ["D2"], right: ["D1"]),
    "D1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["C1"], leftTop: ["C2"], top: ["D2"], topRight: ["E2"], right: ["E1"]),
    "E1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["D1"], leftTop: ["D2"], top: ["E2"], topRight: ["F2"], right: ["F1"]),
    "F1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["E1"], leftTop: ["E2"], top: ["F2"], topRight: ["G2"], right: ["G1"]),
    "G1": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["F1"], leftTop: ["F2"], top: ["G2"], topRight: ["H2"], right: ["H1"]),
    "H1": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: ["G1"], leftTop: ["G2"], top: ["H2"], topRight: [], right: []),
//row 2
    "A2": Directions(
        bottomRight: ["B1"], bottom: ["A1"], bottomLeft: [], left: [], leftTop: [], top: ["A3"], topRight: ["B3"], right: ["B2"]),
    "B2": Directions(
        bottomRight: ["C1"],
        bottom: ["B1"],
        bottomLeft: ["A1"],
        left: ["A2"],
        leftTop: ["A3"],
        top: ["B3"],
        topRight: ["C3"],
        right: ["C2"]),
    "C2": Directions(
        bottomRight: ["D1"],
        bottom: ["C1"],
        bottomLeft: ["B1"],
        left: ["B2"],
        leftTop: ["B3"],
        top: ["C3"],
        topRight: ["D3"],
        right: ["D2"]),
    "D2": Directions(
        bottomRight: ["E1"],
        bottom: ["D1"],
        bottomLeft: ["C1"],
        left: ["C2"],
        leftTop: ["C3"],
        top: ["D3"],
        topRight: ["E3"],
        right: ["E2"]),
    "E2": Directions(
        bottomRight: ["F1"],
        bottom: ["E1"],
        bottomLeft: ["D1"],
        left: ["D2"],
        leftTop: ["D3"],
        top: ["E3"],
        topRight: ["F3"],
        right: ["F2"]),
    "F2": Directions(
        bottomRight: ["G1"],
        bottom: ["F1"],
        bottomLeft: ["E1"],
        left: ["E2"],
        leftTop: ["E3"],
        top: ["F3"],
        topRight: ["G3"],
        right: ["G2"]),
    "G2": Directions(
        bottomRight: ["H1"],
        bottom: ["G1"],
        bottomLeft: ["F1"],
        left: ["F2"],
        leftTop: ["F3"],
        top: ["G3"],
        topRight: ["H3"],
        right: ["H2"]),
    "H2": Directions(
        bottomRight: [], bottom: ["H1"], bottomLeft: ["G1"], left: ["G2"], leftTop: ["G3"], top: ["H3"], topRight: [], right: []),
//row 3
    "A3": Directions(
        bottomRight: ["B2"], bottom: ["A2"], bottomLeft: [], left: [], leftTop: [], top: ["A4"], topRight: ["B4"], right: ["B3"]),
    "B3": Directions(
        bottomRight: ["C2"],
        bottom: ["B2"],
        bottomLeft: ["A2"],
        left: ["A3"],
        leftTop: ["A4"],
        top: ["B4"],
        topRight: ["C4"],
        right: ["C3"]),
    "C3": Directions(
        bottomRight: ["D2"],
        bottom: ["C2"],
        bottomLeft: ["B2"],
        left: ["B3"],
        leftTop: ["B4"],
        top: ["C4"],
        topRight: ["D4"],
        right: ["D3"]),
    "D3": Directions(
        bottomRight: ["E2"],
        bottom: ["D2"],
        bottomLeft: ["C2"],
        left: ["C3"],
        leftTop: ["C4"],
        top: ["D4"],
        topRight: ["E4"],
        right: ["E3"]),
    "E3": Directions(
        bottomRight: ["F2"],
        bottom: ["E2"],
        bottomLeft: ["D2"],
        left: ["D3"],
        leftTop: ["D4"],
        top: ["E4"],
        topRight: ["F4"],
        right: ["F3"]),
    "F3": Directions(
        bottomRight: ["G2"],
        bottom: ["F2"],
        bottomLeft: ["E2"],
        left: ["E3"],
        leftTop: ["E4"],
        top: ["F4"],
        topRight: ["G4"],
        right: ["G3"]),
    "G3": Directions(
        bottomRight: ["H2"],
        bottom: ["G2"],
        bottomLeft: ["F2"],
        left: ["F3"],
        leftTop: ["F4"],
        top: ["G4"],
        topRight: ["H4"],
        right: ["H3"]),
    "H3": Directions(
        bottomRight: [], bottom: ["H2"], bottomLeft: ["G2"], left: ["G3"], leftTop: ["G4"], top: ["H4"], topRight: [], right: []),
//row 4
    "A4": Directions(
        bottomRight: ["B3"], bottom: ["A3"], bottomLeft: [], left: [], leftTop: [], top: ["A5"], topRight: ["B5"], right: ["B4"]),
    "B4": Directions(
        bottomRight: ["C3"],
        bottom: ["B3"],
        bottomLeft: ["A3"],
        left: ["A4"],
        leftTop: ["A5"],
        top: ["B5"],
        topRight: ["C5"],
        right: ["C4"]),
    "C4": Directions(
        bottomRight: ["D3"],
        bottom: ["C3"],
        bottomLeft: ["B3"],
        left: ["B4"],
        leftTop: ["B5"],
        top: ["C5"],
        topRight: ["D5"],
        right: ["D4"]),
    "D4": Directions(
        bottomRight: ["E3"],
        bottom: ["D3"],
        bottomLeft: ["C3"],
        left: ["C4"],
        leftTop: ["C5"],
        top: ["D5", "I9"],
        topRight: ["I5", "E9"],
        right: ["E4"]),
    "E4": Directions(
        bottomRight: ["F3"],
        bottom: ["E3"],
        bottomLeft: ["D3"],
        left: ["D4"],
        leftTop: ["I9", "D5"],
        top: ["E9", "I5"],
        topRight: ["F9"],
        right: ["F4"]),
    "F4": Directions(
        bottomRight: ["G3"],
        bottom: ["F3"],
        bottomLeft: ["E3"],
        left: ["E4"],
        leftTop: ["E9"],
        top: ["F9"],
        topRight: ["G9"],
        right: ["G4"]),
    "G4": Directions(
        bottomRight: ["H3"],
        bottom: ["G3"],
        bottomLeft: ["F3"],
        left: ["F4"],
        leftTop: ["F9"],
        top: ["G9"],
        topRight: ["H9"],
        right: ["H4"]),
    "H4": Directions(
        bottomRight: [], bottom: ["H3"], bottomLeft: ["G3"], left: ["G4"], leftTop: ["G9"], top: ["H9"], topRight: [], right: []),

//black:
// first Row:
    "L8": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: [], leftTop: [], top: ["L7"], topRight: ["K7"], right: ["K8"]),
    "K8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["L8"], leftTop: ["L7"], top: ["K7"], topRight: ["J7"], right: ["J8"]),
    "J8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["K8"], leftTop: ["K7"], top: ["J7"], topRight: ["I7"], right: ["I8"]),
    "I8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["J8"], leftTop: ["J7"], top: ["I7"], topRight: ["D7"], right: ["D8"]),
    "D8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["I8"], leftTop: ["I7"], top: ["D7"], topRight: ["C7"], right: ["C8"]),
    "C8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["D8"], leftTop: ["D7"], top: ["C7"], topRight: ["B7"], right: ["B8"]),
    "B8": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["C8"], leftTop: ["C7"], top: ["B7"], topRight: ["A7"], right: ["A8"]),
    "A8": Directions(bottomRight: [], bottom: [], bottomLeft: [], left: ["B8"], leftTop: ["B7"], top: ["A7"], topRight: [], right: []),
// second row:
    "L7": Directions(
        bottomRight: ["K8"], bottom: ["L8"], bottomLeft: [], left: [], leftTop: [], top: ["L6"], topRight: ["K6"], right: ["K7"]),
    "K7": Directions(
        bottomRight: ["J8"],
        bottom: ["K8"],
        bottomLeft: ["L8"],
        left: ["L7"],
        leftTop: ["L6"],
        top: ["K6"],
        topRight: ["J6"],
        right: ["J7"]),
    "J7": Directions(
        bottomRight: ["I8"],
        bottom: ["J8"],
        bottomLeft: ["K8"],
        left: ["K7"],
        leftTop: ["K6"],
        top: ["J6"],
        topRight: ["I6"],
        right: ["I7"]),
    "I7": Directions(
        bottomRight: ["D8"],
        bottom: ["I8"],
        bottomLeft: ["J8"],
        left: ["J7"],
        leftTop: ["J6"],
        top: ["I6"],
        topRight: ["D6"],
        right: ["D7"]),
    "D7": Directions(
        bottomRight: ["C8"],
        bottom: ["D8"],
        bottomLeft: ["I8"],
        left: ["I7"],
        leftTop: ["I6"],
        top: ["D6"],
        topRight: ["C6"],
        right: ["C7"]),
    "C7": Directions(
        bottomRight: ["B8"],
        bottom: ["C8"],
        bottomLeft: ["D8"],
        left: ["D7"],
        leftTop: ["D6"],
        top: ["C6"],
        topRight: ["B6"],
        right: ["B7"]),
    "B7": Directions(
        bottomRight: ["A8"],
        bottom: ["B8"],
        bottomLeft: ["C8"],
        left: ["C7"],
        leftTop: ["C6"],
        top: ["B6"],
        topRight: ["A6"],
        right: ["A7"]),
    "A7": Directions(
        bottomRight: [], bottom: ["A8"], bottomLeft: ["B8"], left: ["B7"], leftTop: ["B6"], top: ["A6"], topRight: [], right: []),
//third row:
    "L6": Directions(
        bottomRight: ["K7"], bottom: ["L7"], bottomLeft: [], left: [], leftTop: [], top: ["L5"], topRight: ["K5"], right: ["K6"]),
    "K6": Directions(
        bottomRight: ["J7"],
        bottom: ["K7"],
        bottomLeft: ["L7"],
        left: ["L6"],
        leftTop: ["L5"],
        top: ["K5"],
        topRight: ["J5"],
        right: ["J6"]),
    "J6": Directions(
        bottomRight: ["I7"],
        bottom: ["J7"],
        bottomLeft: ["K7"],
        left: ["K6"],
        leftTop: ["K5"],
        top: ["J5"],
        topRight: ["I5"],
        right: ["I6"]),
    "I6": Directions(
        bottomRight: ["D7"],
        bottom: ["I7"],
        bottomLeft: ["J7"],
        left: ["J6"],
        leftTop: ["J5"],
        top: ["I5"],
        topRight: ["D5"],
        right: ["D6"]),
    "D6": Directions(
        bottomRight: ["C7"],
        bottom: ["D7"],
        bottomLeft: ["I7"],
        left: ["I6"],
        leftTop: ["I5"],
        top: ["D5"],
        topRight: ["C5"],
        right: ["C6"]),
    "C6": Directions(
        bottomRight: ["B7"],
        bottom: ["C7"],
        bottomLeft: ["D7"],
        left: ["D6"],
        leftTop: ["D5"],
        top: ["C5"],
        topRight: ["B5"],
        right: ["B6"]),
    "B6": Directions(
        bottomRight: ["A7"],
        bottom: ["B7"],
        bottomLeft: ["C7"],
        left: ["C6"],
        leftTop: ["C5"],
        top: ["B5"],
        topRight: ["A5"],
        right: ["A6"]),
    "A6": Directions(
        bottomRight: [], bottom: ["A7"], bottomLeft: ["B7"], left: ["B6"], leftTop: ["B5"], top: ["A5"], topRight: [], right: []),
// fourth row:
    "L5": Directions(
        bottomRight: ["K6"], bottom: ["L6"], bottomLeft: [], left: [], leftTop: [], top: ["L9"], topRight: ["K9"], right: ["K5"]),
    "K5": Directions(
        bottomRight: ["J6"],
        bottom: ["K6"],
        bottomLeft: ["L6"],
        left: ["L5"],
        leftTop: ["L9"],
        top: ["K9"],
        topRight: ["J9"],
        right: ["J5"]),
    "J5": Directions(
        bottomRight: ["I6"],
        bottom: ["J6"],
        bottomLeft: ["K6"],
        left: ["K5"],
        leftTop: ["K9"],
        top: ["J9"],
        topRight: ["I9"],
        right: ["I5"]),
    "I5": Directions(
        bottomRight: ["D6"],
        bottom: ["I6"],
        bottomLeft: ["J6"],
        left: ["J5"],
        leftTop: ["J9"],
        top: ["I9", "E4"],
        topRight: ["E9", "D4"],
        right: ["D5"]),
    "D5": Directions(
        bottomRight: ["C6"],
        bottom: ["D6"],
        bottomLeft: ["I6"],
        left: ["I5"],
        leftTop: ["I9", "E4"],
        top: ["D4", "E9"],
        topRight: ["C4"],
        right: ["C5"]),
    "C5": Directions(
        bottomRight: ["B6"],
        bottom: ["C6"],
        bottomLeft: ["D6"],
        left: ["D5"],
        leftTop: ["D4"],
        top: ["C4"],
        topRight: ["B4"],
        right: ["B5"]),
    "B5": Directions(
        bottomRight: ["A6"],
        bottom: ["B6"],
        bottomLeft: ["C6"],
        left: ["C5"],
        leftTop: ["C4"],
        top: ["B4"],
        topRight: ["A4"],
        right: ["A5"]),
    "A5": Directions(
        bottomRight: [], bottom: ["A6"], bottomLeft: ["B6"], left: ["B5"], leftTop: ["B4"], top: ["A4"], topRight: [], right: []),

    //red:
    //first Row:
    "H12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: [], leftTop: [], top: ["H11"], topRight: ["G11"], right: ["G12"]),
    "G12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["H12"], leftTop: ["H11"], top: ["G11"], topRight: ["F11"], right: ["F12"]),
    "F12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["G12"], leftTop: ["G11"], top: ["F11"], topRight: ["E11"], right: ["E12"]),
    "E12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["F12"], leftTop: ["F11"], top: ["E11"], topRight: ["I11"], right: ["I12"]),
    "I12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["E12"], leftTop: ["E11"], top: ["I11"], topRight: ["J11"], right: ["J12"]),
    "J12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["I12"], leftTop: ["I11"], top: ["J11"], topRight: ["K11"], right: ["K12"]),
    "K12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["J12"], leftTop: ["J11"], top: ["K11"], topRight: ["L11"], right: ["L12"]),
    "L12": Directions(
        bottomRight: [], bottom: [], bottomLeft: [], left: ["K12"], leftTop: ["K11"], top: ["L11"], topRight: [], right: []),
// second row:
    "H11": Directions(
        bottomRight: ["G12"], bottom: ["H12"], bottomLeft: [], left: [], leftTop: [], top: ["H10"], topRight: ["G10"], right: ["G11"]),
    "G11": Directions(
        bottomRight: ["F12"],
        bottom: ["G12"],
        bottomLeft: ["H12"],
        left: ["H11"],
        leftTop: ["H10"],
        top: ["G10"],
        topRight: ["F10"],
        right: ["F11"]),
    "F11": Directions(
        bottomRight: ["E12"],
        bottom: ["F12"],
        bottomLeft: ["G12"],
        left: ["G11"],
        leftTop: ["G10"],
        top: ["F10"],
        topRight: ["E10"],
        right: ["E11"]),
    "E11": Directions(
        bottomRight: ["I12"],
        bottom: ["E12"],
        bottomLeft: ["F12"],
        left: ["F11"],
        leftTop: ["F10"],
        top: ["E10"],
        topRight: ["I10"],
        right: ["I11"]),
    "I11": Directions(
        bottomRight: ["J12"],
        bottom: ["I12"],
        bottomLeft: ["E12"],
        left: ["E11"],
        leftTop: ["E10"],
        top: ["I10"],
        topRight: ["J10"],
        right: ["J11"]),
    "J11": Directions(
        bottomRight: ["K12"],
        bottom: ["J12"],
        bottomLeft: ["I12"],
        left: ["I11"],
        leftTop: ["I10"],
        top: ["J10"],
        topRight: ["K10"],
        right: ["K11"]),
    "K11": Directions(
        bottomRight: ["L12"],
        bottom: ["K12"],
        bottomLeft: ["J12"],
        left: ["J11"],
        leftTop: ["J10"],
        top: ["K10"],
        topRight: ["L10"],
        right: ["L11"]),
    "L11": Directions(
        bottomRight: [], bottom: ["L12"], bottomLeft: ["K12"], left: ["K11"], leftTop: ["K10"], top: ["L10"], topRight: [], right: []),
    //third row:
    "H10": Directions(
        bottomRight: ["G11"], bottom: ["H11"], bottomLeft: [], left: [], leftTop: [], top: ["H9"], topRight: ["G9"], right: ["G10"]),
    "G10": Directions(
        bottomRight: ["F11"],
        bottom: ["G11"],
        bottomLeft: ["H11"],
        left: ["H10"],
        leftTop: ["H9"],
        top: ["G9"],
        topRight: ["F9"],
        right: ["F10"]),
    "F10": Directions(
        bottomRight: ["E11"],
        bottom: ["F11"],
        bottomLeft: ["G11"],
        left: ["G10"],
        leftTop: ["G9"],
        top: ["F9"],
        topRight: ["E9"],
        right: ["E10"]),
    "E10": Directions(
        bottomRight: ["I11"],
        bottom: ["E11"],
        bottomLeft: ["F11"],
        left: ["F10"],
        leftTop: ["F9"],
        top: ["E9"],
        topRight: ["I9"],
        right: ["I10"]),
    "I10": Directions(
        bottomRight: ["J11"],
        bottom: ["I11"],
        bottomLeft: ["E11"],
        left: ["E10"],
        leftTop: ["E9"],
        top: ["I9"],
        topRight: ["J9"],
        right: ["J10"]),
    "J10": Directions(
        bottomRight: ["K11"],
        bottom: ["J11"],
        bottomLeft: ["I11"],
        left: ["I10"],
        leftTop: ["I9"],
        top: ["J9"],
        topRight: ["K9"],
        right: ["K10"]),
    "K10": Directions(
        bottomRight: ["L11"],
        bottom: ["K11"],
        bottomLeft: ["J11"],
        left: ["J10"],
        leftTop: ["J9"],
        top: ["K9"],
        topRight: ["L9"],
        right: ["L10"]),
    "L10": Directions(
        bottomRight: [], bottom: ["L11"], bottomLeft: ["K11"], left: ["K10"], leftTop: ["K9"], top: ["L9"], topRight: [], right: []),
// fourth row:
    "H9": Directions(
        bottomRight: ["G10"], bottom: ["H10"], bottomLeft: [], left: [], leftTop: [], top: ["H4"], topRight: ["G4"], right: ["G9"]),
    "G9": Directions(
        bottomRight: ["F10"],
        bottom: ["G10"],
        bottomLeft: ["H10"],
        left: ["H9"],
        leftTop: ["H4"],
        top: ["G4"],
        topRight: ["F4"],
        right: ["F9"]),
    "F9": Directions(
        bottomRight: ["E10"],
        bottom: ["F10"],
        bottomLeft: ["G10"],
        left: ["G9"],
        leftTop: ["G4"],
        top: ["F4"],
        topRight: ["E4"],
        right: ["E9"]),
    "E9": Directions(
        bottomRight: ["I10"],
        bottom: ["E10"],
        bottomLeft: ["F10"],
        left: ["F9"],
        leftTop: ["F4"],
        top: ["E4", "D5"],
        topRight: ["D4", "I5"],
        right: ["I9"]),
    "I9": Directions(
        bottomRight: ["J10"],
        bottom: ["I10"],
        bottomLeft: ["E10"],
        left: ["E9"],
        leftTop: ["E4", "D5"],
        top: ["I5", "D4"],
        topRight: ["J5"],
        right: ["J9"]),
    "J9": Directions(
        bottomRight: ["K10"],
        bottom: ["J10"],
        bottomLeft: ["I10"],
        left: ["I9"],
        leftTop: ["I5"],
        top: ["J5"],
        topRight: ["K5"],
        right: ["K9"]),
    "K9": Directions(
        bottomRight: ["L10"],
        bottom: ["K10"],
        bottomLeft: ["J10"],
        left: ["J9"],
        leftTop: ["J5"],
        top: ["K5"],
        topRight: ["L5"],
        right: ["L9"]),
    "L9": Directions(
        bottomRight: [], bottom: ["L10"], bottomLeft: ["K10"], left: ["K9"], leftTop: ["K5"], top: ["L5"], topRight: [], right: []),
  };
}

class Directions {
  List<String> bottomRight;
  List<String> bottom;
  List<String> bottomLeft;
  List<String> left;
  List<String> leftTop;
  List<String> top;
  List<String> topRight;
  List<String> right;

  List<List<String>> get _allDir {
    return [bottomRight, bottom, bottomLeft, left, leftTop, top, topRight, right];
  }

  List<String> getFromEnum(Direction direction) {
    return _allDir[direction.index];
  }

  List<String> getRelativeEnum(Direction direction, PlayerColor playerColor, PlayerColor side) {
    // print("playerColor: " + playerColor.toString()+ " side: " + side.toString() + " direction.index: " + direction.index.toString() + " i: " + ((playerColor != side) ? (direction.index+4)%8 : direction.index).toString());
    int i = (playerColor != side) ? (direction.index + 4) % 8 : direction.index;
    return _allDir[i];
  }

  static Direction makeRelativeEnum(Direction direction, PlayerColor playerColor, PlayerColor side) {
    // to test only: return playerColor == side ? direction : [];
    return Direction.values[(playerColor != side) ? (direction.index + 4) % 8 : direction.index];
  }

  Directions({this.bottomRight, this.bottom, this.bottomLeft, this.left, this.leftTop, this.top, this.topRight, this.right});

  List<String> get key => null;
}

