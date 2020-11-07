import 'enums.dart';
import 'package:flutter/material.dart';

import '../data/image_data.dart';

class Piece extends StatelessWidget {
  PieceType pieceType;
  bool invis = false;
  String _position;
  PlayerColor playerColor;
  bool didMove = false;


  static Size pieceSize = Size(55, 55);

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset(ImageData.assetPaths[pieceKey], width: ImageData.pieceSize.width, height: ImageData.pieceSize.height),
    );
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
