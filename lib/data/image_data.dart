
import '../models/piece.dart';
import '../models/enums.dart';



class ImageData{


  static Map<PieceKey, String> assetPaths ={

    PieceKeyGen.genKey(PieceType.Pawn, PlayerColor.white): 'assets/pieces/pawn_white.png',
    PieceKeyGen.genKey(PieceType.Pawn, PlayerColor.black): 'assets/pieces/pawn_black.png',
    PieceKeyGen.genKey(PieceType.Pawn, PlayerColor.red): 'assets/pieces/pawn_red.png',

    PieceKeyGen.genKey(PieceType.Rook, PlayerColor.white): 'assets/pieces/rook_white.png',
    PieceKeyGen.genKey(PieceType.Rook, PlayerColor.black): 'assets/pieces/rook_black.png',
    PieceKeyGen.genKey(PieceType.Rook, PlayerColor.red): 'assets/pieces/rook_red.png',

    PieceKeyGen.genKey(PieceType.Knight, PlayerColor.white): 'assets/pieces/knight_white.png',
    PieceKeyGen.genKey(PieceType.Knight, PlayerColor.black): 'assets/pieces/knight_black.png',
    PieceKeyGen.genKey(PieceType.Knight, PlayerColor.red): 'assets/pieces/knight_red.png',

    PieceKeyGen.genKey(PieceType.Bishop, PlayerColor.white): 'assets/pieces/bishop_white.png',
    PieceKeyGen.genKey(PieceType.Bishop, PlayerColor.black): 'assets/pieces/bishop_black.png',
    PieceKeyGen.genKey(PieceType.Bishop, PlayerColor.red): 'assets/pieces/bishop_red.png',

    PieceKeyGen.genKey(PieceType.King, PlayerColor.white): 'assets/pieces/king_white.png',
    PieceKeyGen.genKey(PieceType.King, PlayerColor.black): 'assets/pieces/king_black.png',
    PieceKeyGen.genKey(PieceType.King, PlayerColor.red): 'assets/pieces/king_red.png',

    PieceKeyGen.genKey(PieceType.Queen, PlayerColor.white): 'assets/pieces/queen_white.png',
    PieceKeyGen.genKey(PieceType.Queen, PlayerColor.black): 'assets/pieces/queen_black.png',
    PieceKeyGen.genKey(PieceType.Queen, PlayerColor.red): 'assets/pieces/queen_red.png',



  };

}


