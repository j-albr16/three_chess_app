import 'package:flutter/foundation.dart';

class ScrollProvider extends ChangeNotifier{

  bool _isLocked = false;

  set isLocked(bool newLock){
    _isLocked = newLock;
    notifyListeners();
  }
  get isLocked{
    return _isLocked;
  }
}