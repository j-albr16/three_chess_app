import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier{

  User _user;

  User get user {
    return _user;
  }

  void update({user}){
    _user = user;
  }
    
} 