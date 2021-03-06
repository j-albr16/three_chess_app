enum ErrorResponseType {
  Snackbar,
}

enum ErrorType {
  Response,
  Critical,
  UnCritical,
}

enum Direction {
  bottomRight,
  bottom,
  bottomLeft,
  left,
  leftTop,
  top,
  topRight,
  right
}
enum SpecialMove { Castling, Enpassant, Check, CheckMate, Take, NoMove, Win }
enum RequestType {
  Remi,
  Surrender,
  TakeBack,
}

enum PopUpType { SnackBar, Invitation, Endgame, GameStarts }

const Map<RequestType, String> requestTypeInterface = {
  RequestType.TakeBack: "Take Back",
  RequestType.Remi: "Draw",
  RequestType.Surrender: "Surrender",
};

enum TableAction { DrawOffer, TakeBackRequest, SurrenderRequest }

enum ChatType { Friend, OnlineGame, Lobby }

enum PieceKey {
  PawnWhite,
  PawnBlack,
  PawnRed,
  RookWhite,
  RookBlack,
  RookRed,
  KnightWhite,
  KnightBlack,
  KnightRed,
  BishopWhite,
  BishopBlack,
  BishopRed,
  KingWhite,
  KingBlack,
  KingRed,
  QueenWhite,
  QueenBlack,
  QueenRed
}

enum PieceType { Pawn, Rook, Knight, Bishop, King, Queen }
enum PlayerColor { white, black, red, none }

enum HowGameEnded {
  Remi,
  CheckMate,
  Surrender,
  Leave,
}

enum GameType { Local, Analyze, Online, Pending }

const Map<GameType, String> gameTypeInterface = {
  GameType.Online: 'onlineGame',
  GameType.Analyze: 'analyzeGame',
  GameType.Local: 'localGame',
  GameType.Pending: 'pendingGame',
};

const Map<GameType, String> gameTypeString = {
  GameType.Analyze: 'Analyze',
  GameType.Local: 'Local',
  GameType.Online: 'Online',
};

enum ResponseRole {
  Accept,
  Create,
  Decline,
}

enum MessageOwner {
  You,
  Server,
  Mate,
}

const Map<PlayerColor, String> playerColorString = {
  PlayerColor.white: "White",
  PlayerColor.black: "Black",
  PlayerColor.red: "Red",
};
enum Method {
  // HTTP Requests
  // Fetching
  FetchAuthUser,
  FetchLocalGames,
  FetchPendingGames,
  FetchLobbyGames,
  FetchOnlineGames,
  FetchOnlineGame,
  // Local Games
  SaveGames,
  // Online Game
  GetPossiblePairings,
  CreateTestGame,
  SendMove,
  RequestSurrender,
  AcceptSurrender,
  DeclineSurrender,
  RequestRemi,
  AcceptRemi,
  DeclineRemi,
  RequestTakeBack,
  AcceptTakeBack,
  DeclineTakeBack,
  CancelRequest,
  // Auth User
  OnlineStatusUpdate,
  GetCount,
  SendErrorReport,
  // Pending Game
  UpdateIsReady,
  LeaveLobby,
  FindAGameLike,
  QuickPairing,
  StopQuickPairing,
  CreateGame,
  JoinGame,
  // Friend
  FetchFriends,
  SendFriendRequest,
  AcceptFriend,
  FriendDecline,
  FriendRemove,
  FetchInvitations,
  DeclineInvitations,
  // Chat
  FetchChat,
  SendMessage,

  // Socket Messages
  // Online Game
  HandlePlayerIsOnline,
  HandlePlayerIsOffline,
  HandleMove,
  HandleSurrenderFailed,
  HandleSurrenderRequest,
  HandleSurrenderDecline,
  HandleRemiRequest,
  HandleRequestCancelled,
  HandleRemiAccept,
  HandleRemiDecline,
  HandleTakeBackRequest,
  HandleTakeBackAccept,
  HandleTakeBack,
  HandleTakeBackDecline,
  HandleGameFinished,
  // Pending Game
  HandlePlayerJoined,
  HandleNewGame,
  HandleUpdateIsReadyStatus,
  HandleRemoveGame,
  HandlePlayerLeft,
  HandleGameStarts,

  // Friend
  HandleMessage,
  HandleFriendRequest,
  HandleFriendAccept,
  HandleFriendDecline,
  HandleFriendRemove,
  HandleGameInvitation,

  HandleUserStatusUpdate,

  Unknown,

  // Auth
  PostLogin,
  PostSignUp,
  GetValidateSignUp,
  TryAutoLogin,
}
