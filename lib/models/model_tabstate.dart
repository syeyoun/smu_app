import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/tabs/tab_home.dart';
import 'package:test_1/tabs/tab_lock.dart';
import 'package:test_1/tabs/tab_profile.dart';
import 'package:test_1/tabs/tab_visible_1.dart';
import 'package:test_1/models/model_hash.dart';
import 'package:provider/provider.dart';

class TabState extends ChangeNotifier {
  int _currentTabIndex = 0;
  bool _isClicked = false;

  int get currentTabIndex => _currentTabIndex;
  bool get isClicked => _isClicked;

  void changeTab(int index) {
    _currentTabIndex = index;
    notifyListeners(); // 상태가 변경되었음을 알림
  }

  Future<void> toggleClick() async {
    _isClicked = !_isClicked;
    notifyListeners();
  }

  Future<void> resetClick() async {
    _isClicked = false;
    notifyListeners();
  }

  // void setOnLogoutComplete(Future<void> Function()? callback) {
  //   _onLogoutComplete = callback;
  //   notifyListeners();
  // }
}