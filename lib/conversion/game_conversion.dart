import '../models/online_game.dart';
import '../models/player.dart';
import '../models/request.dart';
import '../models/user.dart';
import '../models/enums.dart';
import '../models/chess_move.dart';

typedef void GameCallback(
    Map<String, dynamic> gameData, List playerData, List userData);

class GameConversion {
  static OnlineGame rebaseAnalyzeGame(Map<String, dynamic> gameData) {}

  static void sortUserAndPlayer(
      Map<String, dynamic> data, GameCallback lobbyGameCallback,
      {GameType gameType}) {
    final Map<String, dynamic> gameData = data['gameData'];
    final userData = gameData['user'];
    final playerData = gameData['player'];
    // lobby OnlineGame Callback will be called for Each OnlineGame
    data['gameData']['games'].forEach((game) {
      final List pData = playerData
          .where((player) => player['gameId'] == game['_id'])
          .toList();
      print(pData);
      print(userData);
      print(gameTypeInterface[gameType]);
      final List uData = userData.where((user) {
        String gameTypeKey = gameTypeInterface[gameType];
        List gameIds = user[gameTypeKey];
        return gameIds.contains(game['_id']);
      }).toList();
      print(uData);
      lobbyGameCallback(game, pData, uData);
    });
  }

  static List<OnlineGame> rebaseOnlineGames(Map<String, dynamic> data) {
    List<OnlineGame> resultGames = [];
    sortUserAndPlayer(data, (gameData, playerData, userData) {
      resultGames.add(rebaseOnlineGame(
          gameData: gameData, playerData: playerData, userData: userData));
    }, gameType: GameType.Online);
    return resultGames;
  }

  static OnlineGame rebaseOnlineGame(
      {Map<String, dynamic> gameData,
      List playerData = const [],
      List userData = const []}) {
    print('rebasing Online Game');
    // input: takes a decoded response from Server , where GameData in JSON is encoeded
    // output: Returns a game Model
    // convert Chess moves and add them to exisitng Chess Move Class
    if (gameData == null) {
      return null;
    }
    List<ChessMove> chessMoves = [];
    gameData['chessMoves']?.forEach((e) => chessMoves.add(rebaseOneMove(e)));
    // convert player List and add them to existing player class
    List<Player> convPlayer = connectUserPlayerData(
      player: playerData,
      users: userData,
    );
    print('Finished converting Player and User');
    // creates a game and sets OnlineGame options in it
    OnlineGame game = createGameWithOptions(gameData['options']);
    // set remaining OnlineGame parameters
    game.didStart = gameData['didStart'];
    game.id = gameData['_id'];
    game.player = convPlayer;
    game.chessMoves = chessMoves;
    List<Request> convRequests = [];
    print('Raw Data of Requests');
    print(gameData['requests']);
    gameData['requests']?.forEach(
        (request) => convRequests.add(rebaseOneRequest(request, game)));
    // returns the converted OnlineGame
    game.requests = convRequests;
    return game;
  }

  static OnlineGame rebaseLobbyGame(
      {Map<String, dynamic> gameData, List userData, List playerData}) {
    print('rebasing Lobby Games');
    // input: takes the decoded GameData of an JSON Response as Input
    // output: returns a converted OnlineGame that includes Lobby OnlineGame Data
    //No Chess Moves made in Lobby Games
    List<ChessMove> chessMoves = [];
    // convert player List and add them to existing player class
    List<Player> convPlayer = connectUserPlayerData(
      player: playerData,
      users: userData,
    );
    // creates a game and sets gameOptions
    OnlineGame game = createGameWithOptions(gameData['options']);
    // set remaining OnlineGame parameters
    game.didStart = gameData['didStart'];
    game.id = gameData['_id'];
    game.player = convPlayer;
    game.chessMoves = chessMoves;
    // returns the converted OnlineGame
    return game;
  }

  static List<OnlineGame> rebaseLobbyGames(Map<String, dynamic> data) {
    List<OnlineGame> gamesResult = [];
    sortUserAndPlayer(data, (gameData, playerData, userData) {
      gamesResult.add(rebaseLobbyGame(
        gameData: gameData,
        playerData: playerData,
        userData: userData,
      ));
    }, gameType: GameType.Pending);
    return gamesResult;
  }

  static Request rebaseOneRequest(
      Map<String, dynamic> requestData, OnlineGame game) {
    PlayerColor createPlayerColor =
        getPlayerColorFromUserId(requestData['create'], game.player);
    PlayerColor acceptPlayerColor =
        getPlayerColorFromUserId(requestData['accept'], game.player);
    PlayerColor declinePlayerColor =
        getPlayerColorFromUserId(requestData['decline'], game.player);
    Map<ResponseRole, PlayerColor> playerResponse = {};
    playerResponse[ResponseRole.Create] = createPlayerColor;
    playerResponse[ResponseRole.Accept] = acceptPlayerColor;
    playerResponse[ResponseRole.Decline] = declinePlayerColor;
    return Request(
      moveIndex: requestData['chessMove'],
      playerResponse: playerResponse,
      requestType: RequestType.values[requestData['requestType']],
    );
  }

  static Player rebaseOnePlayer({playerData, userData}) {
    return new Player(
      isOnline: userData['isPlaying'],
      playerColor: PlayerColor.values[playerData['playerColor']],
      remainingTime: playerData['remainingTime'],
      user: rebaseOneUser(userData),
    );
  }

  static User rebaseOneUser(Map<String, dynamic> userData) {
    return new User(
        id: userData['_id'],
        score: userData['score'],
        friendIds: (userData['friends'] as List).map((friend) => friend as String).toList(),
        userName: userData['userName']);
  }

  static ChessMove rebaseOneMove(moveData) {
    // input : receive Move Data,
    // output : return Chess Move Model
    return ChessMove(
      initialTile: moveData['initialTile'],
      nextTile: moveData['nextTile'],
      remainingTime: moveData['remainingTime'],
    );
  }

  static PlayerColor getPlayerColorFromUserId(
      String userId, List<Player> gamePlayer) {
    print('Getting Player Color from UserId');
    Player player = gamePlayer.firstWhere((player) => player.user.id == userId,
        orElse: () => null);
    PlayerColor playerColor = player?.playerColor;
    print(playerColor);
    return playerColor;
  }

  static Request getRequestFromRequestType(
      RequestType requestType, OnlineGame game) {
    return game.requests
        .firstWhere((request) => request.requestType == requestType);
  }

  static void validation(data) {
    // input: receives a bool as decoded JSON Object __> mainly res.json(valid)
    // output : Return whether this bool is true or false
    // Checks whether Data was even recieved
    if (data == null) {
      throw ('No Data was received ... Data is equal to NULL');
    }
    // cheks whether Data is Valid. If validis not true Error was thrown on Server
    if (data['valid'] == false || data['valid'] == null) {
      throw ('validation did not succeed ... this is the Error Message: ...' +
          data['message']);
    }
    print('validation finished , was succesfull');
  }

  static List<Player> connectUserPlayerData({List users, List player}) {
    // input: get a Player JSON Object and a User JSON Object
    // output: return a Player model where User and Player are asigned
    List<Player> convPlayer = [];
    player.forEach((p) {
      final Map<String, dynamic> user =
          users?.firstWhere((u) => p['userId'] == u['_id'], orElse: () => null);
      // returns user object where player-userId and user.id are qual
      convPlayer.add(rebaseOnePlayer(
        playerData: p,
        userData: user,
      ));
    });
    // return List of Player.
    return convPlayer;
  }

  static OnlineGame createGameWithOptions(gameOptions) {
    // input: takes JSOON OnlineGame Options as Input
    // output: returns a game Model where OnlineGame options are set already
    return new OnlineGame(
      increment: gameOptions['increment'],
      isPublic: gameOptions['isPublic'],
      isRated: gameOptions['isRated'],
      negRatingRange: gameOptions['negRatingRange'],
      allowPremades: gameOptions['allowPremades'],
      posRatingRange: gameOptions['posRatingRange'],
      time: gameOptions['time'],
    );
  }

  static printEverything(
      OnlineGame game, Player player, List<OnlineGame> games) {
    print(
        '###########################################################################################');
    if (game != null) {
      print(
          'OnlineGame:-------------------------------------------------------------------------------------');
      print(
          '===========================================================================================');
      print('id:         ' + game.id.toString());
      print('didStart:   ' + game.didStart.toString());
      print(
          '----------------------------------------------------------------------------------------------');
      print('options: --------------------------   ');
      print(' -> increment:       ' + game.increment.toString());
      print(' -> time:            ' + game.time.toString());
      print(' -> negratingRange:  ' + game.negRatingRange.toString());
      print(' -> posRatingrange:  ' + game.posRatingRange.toString());
      print(' -> isPublic:        ' + game.isPublic.toString());
      print(' -> isRated:         ' + game.isRated.toString());
      print(
          '----------------------------------------------------------------------------------------------');
      print(
          'player:---------------------------------------------------------------------------------------');
      int index = 0;
      game.player.forEach((e) {
        print('Player ' + index.toString());
        print(' -> playerColor:     ' + e.playerColor.toString());
        print(' -> remainingTime:   ' + e.remainingTime.toString());
        print(' -> user:-----------------------');
        print('     - id:               ' + e.user.id.toString());
        print('     - userName:         ' + e.user.userName.toString());
        print('     - score:            ' + e.user.score.toString());
        print(
            '----------------------------------------------------------------------------------------------');
        index++;
      });
      print(
          'Chess Moves:--------------------------------------------------------------------------------');
      game.chessMoves.forEach((m) {
        print(
            'one move:-------------------------------------------------------------------------------------');
        print(' -> initialTile:     ' + m.initialTile);
        print(' -> nextTile:        ' + m.nextTile);
        print(' -> remainingTime:   ' + m.remainingTime.toString());
      });
      game.requests.forEach((re) {
        print('one request ' + '-' * 30);
        print(' -> requestType:     ' + re.requestType?.toString());
        print(' -> playerResponse:     ' + re.playerResponse?.toString());
        print(' -> moveIndex:     ' + re.moveIndex?.toString());
      });
    }
    if (player != null) {
      print(
          '=================================================================================================');
      print(
          'This Player:----------------------------------------------------------------------------------------');
      print('playerColor: ');
      print(player.playerColor);
      print('remainingTime:   ' + player?.remainingTime?.toString());
      print(
          '---------------------------------------------------------------------------------------------------');
      print(
          'user:---------------------------------------------------------------------------------------------');
      print(' -> id:          ' + player.user.id.toString());
      print(' -> userName:    ' + player.user.userName.toString());
      print(' -> score:       ' + player.user.score.toString());
      print(
          '=========================================================================================================');
    }
    if (games.isNotEmpty) {
      print(
          'games:------------------------------------------------------------------------------------------------');
      for (game in games) {
        print(
            'a game:-----------------------------------------------------------------------------------------');
        print(' -> id:        ' + game.id.toString());
        print(' -> isRated:   ' + game.isRated.toString());
        print(
            '-----------------------------------------------------------------------------------------------');
      }
    }
    print(
        '#####################################################################################################');
  }
}
