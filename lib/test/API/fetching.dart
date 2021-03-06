import 'package:http/http.dart' as http;
import 'package:three_chess/data/server.dart';
import 'package:three_chess/models/enums.dart';
import 'package:three_chess/test/API/auth.dart';
import 'package:three_chess/test/API/request.dart';

class Fetching {
  static fetchOnlineGames() async {
    try {
      print('Start Fetching Online Games');
      String url =
          SERVER_ADRESS + 'fetch-online-games' + Auth.getAuth(User.Leo);
      print(url);
      Request.get(
        url: url,
        method: Method.FetchOnlineGames,
      );

      print('Finished Fetching Online Games');
    } catch (error) {
      print(error);
    }
  }
}
