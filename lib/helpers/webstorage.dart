import 'package:universal_html/prefer_universal/html.dart';

class WebStorage {

  WebStorage._internal();
  static final WebStorage instance = WebStorage._internal();
  factory WebStorage(){
    return instance;
  }

  String get token => window.localStorage['chessToken'];
  set token(String cToken) => (cToken == null) ? window.localStorage.remove('chessToken') : window.localStorage['chessToken'] = cToken;

  String get userId => window.localStorage['chessUserId'];
  set userId(String userId) => (userId == null) ? window.localStorage.remove('chessUserId') : window.localStorage['chessUserId'] = userId;
}