import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helpers/http_exception.dart';
import '../data/server.dart';
import '../helpers/webstorage.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;

  bool get isAuth {
    return _token != null;
  }

  get token {
    return _token;
  }

  get userId {
    return _userId;
  }

  static const REST_API_URL = SERVER_ADRESS;

  Future<void> logIn({String email, String password}) async {
    try {
      const url = SERVER_ADRESS + '/login';
      final body = json.encode({
        'password': password,
        'email': email,
      });
      print(body);
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      print(decodedResponse);
      if (!decodedResponse['valid']) {
        print(decodedResponse);
        throw (decodedResponse['message']);
      }
      _token = decodedResponse['token'];
      _userId = decodedResponse['userId'];
      if (kIsWeb) {
        WebStorage.instance.token = _token;
        WebStorage.instance.userId = _userId;
      } else {
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token': _token,
          'userId': _userId,
        });
        prefs.setString('userData', userData);
        print('Saved User Data in Shared Preferences');
      }
    } catch (error) {
      throw error.toString();
    } finally {
      notifyListeners();
      print(_token);
      print(_userId);
    }
  }

  Future<void> signUp({String email, String password, String userName}) async {
    const url = SERVER_ADRESS + '/sign-up';
    print(password);
    print(email);
    print(userName);
    final body = json.encode({
      'password': password,
      'email': email,
      'userName': userName,
    });
    print(body);
    try {
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});
      final decodedResponse =
          json.decode(response.body) as Map<String, dynamic>;
      print(decodedResponse['message']);
    } catch (error) {
      // final newError = HttpExeption(error);
      print(error);
      // print(newError);
      return null;
      // throw (newError);
    }
  }

  Future<void> tryautoLogIn() async {
    String token;
    String uId;
    if (kIsWeb) {
      token = WebStorage.instance.token;
      uId = WebStorage.instance.userId;
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      final userData = prefs.get('userData') as Map<String, dynamic>;
      token = userData['token'];
      uId = userData['userId'];
      print('Shared Prefs: Auto Login happened');
    }
    final String url = SERVER_ADRESS + '/auto-login/$_userId/$token';
    final response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);
    if (data['isLoggedIn']) {
      _userId = uId;
      _token = token;
      notifyListeners();
    } else {
      print('Auto Login was not Sucessfull');
    }
  }

  Future<void> logOut() async {
    try {
      _token = null;
      _userId = null;
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();
    } catch (error) {
      throw error.toString();
    } finally {
      notifyListeners();
    }
  }
}
