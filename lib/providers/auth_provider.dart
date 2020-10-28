import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return _token != null;
  }

  static const REST_API_URL = 'http://localhost:3000';

  Future<void> logIn({String email, String password}) async {
    const url = REST_API_URL + '/login';
    final response = await http.post(url,
        body: json.encode({password: password, email: email}));
    final decodedResponse = json.decode(response.body);
    _token = decodedResponse.token;
    print(decodedResponse.message);
    notifyListeners();
  }

  Future<void> signUp({String email, String password}) async {
    const url = REST_API_URL + '/sign-up';
    final response = await http.post(url,
        body: json.encode({
          password: password,
          email: email,
        }));
        final decodedResponse = json.decode(response.body);
        print(decodedResponse.message);
  }
}
