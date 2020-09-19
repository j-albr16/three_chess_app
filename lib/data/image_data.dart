
import '../models/piece.dart';
import '../providers/piece_provider.dart';



class ImageData{


  static const Map<PieceType, Map<PlayerColor, String>> assetPaths ={
    PieceType.Pawn:{
      PlayerColor.black:'assets/pieces/black/pawn_black.png',
      PlayerColor.white:'assets/pieces/white/pawn_white.png',
      PlayerColor.red:'assets/pieces/black/pawn_black.png',
    },
    PieceType.Bishop:{
      PlayerColor.black:'assets/pieces/black/bishop_black.png',
      PlayerColor.white:'assets/pieces/white/bishop_white.png',
      PlayerColor.red:'assets/pieces/black/bishop_black.png',
    },
    PieceType.Knight:{
      PlayerColor.black:'assets/pieces/black/knight_black.png',
      PlayerColor.white:'assets/pieces/white/knight_white.png',
      PlayerColor.red:'assets/pieces/black/knight_black.png',
    },
    PieceType.Rook:{
      PlayerColor.black:'assets/pieces/black/rook_black.png',
      PlayerColor.white:'assets/pieces/white/rook_white.png',
      PlayerColor.red:'assets/pieces/black/rook_black.png',
    },
    PieceType.Queen:{
      PlayerColor.black:'assets/pieces/black/queen_black.png',
      PlayerColor.white:'assets/pieces/white/queen_white.png',
      PlayerColor.red:'assets/pieces/black/queen_black.png',
    },
    PieceType.King:{
      PlayerColor.black:'assets/pieces/black/king_black.png',
      PlayerColor.white:'assets/pieces/white/king_white.png',
      PlayerColor.red:'assets/pieces/black/king_black.png',
    },

  };

}


