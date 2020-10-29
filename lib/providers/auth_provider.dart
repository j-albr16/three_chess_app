import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/http_exception.dart';

class AuthProvider with ChangeNotifier {
  String _token;
  String _userId;

  bool get isAuth {
    return _token != null;
  }

  static const REST_API_URL = 'http://localhost:3000';

  Future<void> logIn({String email, String password}) async {
    try {
      const url = REST_API_URL + '/login';
      final body = json.encode({
        'password': password,
        'email': email,
      });
      print(body);
      final response = await http
          .post(url, body: body, headers: {'Content-Type': 'application/json'});
      final decodedResponse = json.decode(response.body);
      print(decodedResponse);
      if (!decodedResponse['valid']) {
        print(decodedResponse);
        throw (decodedResponse['message']);
      }
      _token = decodedResponse['token'];
      _userId = decodedResponse['userId'];
      // final prefs = await SharedPreferences.getInstance();
      // final userData = json.encode({
      //   'token': _token,
      //   'userId':_userId,
      // });
      // prefs.setString('userData', userData);
      // print('Saved User Data in Shared Preferences');
    } catch (error) {
      throw error.toString();
    } finally {
      notifyListeners();
      print(_token);
      print(_userId);
    }
  }

  Future<void> signUp({String email, String password, String userName}) async {
    const url = REST_API_URL + '/sign-up';
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
      final decodedResponse = json.decode(response.body);
      print(decodedResponse['message']);
    } catch (error) {
      // final newError = HttpExeption(error);
      print(error);
      // print(newError);
      return null;
      // throw (newError);
    }
  }

  // Future<void> tryautoLogIn() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   if(!prefs.containsKey('userData')){
  //     return false;
  //   }
  //   final userData = prefs.get('userData') as Map<String, dynamic>;
  //   _token = userData['token'];
  //   _userId = userData['userId'];
  //   print('Shared Prefs: Auto Login happened');
  //   notifyListeners();
  // }

  Future<void> logOut() async{
    try{
      _token = null;
      _userId = null;
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.clear();
    }catch(error){
      throw error.toString();
    }finally{
      notifyListeners();
    }
  }
}
