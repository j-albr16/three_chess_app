import 'package:flutter/foundation.dart';

class ScrollProvider extends ChangeNotifier{

  bool _isLockedHorizontal = false;
  bool _isMakeAMoveLock = false;

  set isMakeAMoveLock(bool newLock){
    _isMakeAMoveLock = newLock;
    notifyListeners();
  }
  get isMakeAMoveLock{
    return _isMakeAMoveLock;
  }

  set isLockedHorizontal(bool newLock){
    _isLockedHorizontal = newLock;
    notifyListeners();
  }
  get isLockedHorizontal{
    return _isLockedHorizontal;
  }
}