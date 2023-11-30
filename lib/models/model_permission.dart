import 'model_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_1/models/model_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:test_1/models/model_auth.dart';

import 'package:flutter/foundation.dart';

class UserPermissionProvider with ChangeNotifier {
  String _email = '';
  bool _hasAccessToTabCard = false;

  String get email => _email;
  set email(String email) {
    _email = email;
    updateAccess(); // 별도의 메소드를 호출
    notifyListeners();
  }

  Future<void> updateAccess() async { // 비동기 메소드로 선언
    await grantAccessToTabCard(); // await 키워드를 사용하여 완료를 기다림
  }

  bool get hasAccessToTabCard => _hasAccessToTabCard;
  set hasAccessToTabCard(bool value) {
    _hasAccessToTabCard = value;
    notifyListeners();
  }
  // String _email = '';
  // bool _hasAccessToTabCard = false;
  //
  // String get email => _email;
  // set email(String email) {
  //   _email = email;
  //   grantAccessToTabCard(); // 이메일이 설정된 후에 grantAccessToTabCard 메소드를 호출
  //   notifyListeners();
  // }
  //
  // bool get hasAccessToTabCard => _hasAccessToTabCard;
  // set hasAccessToTabCard(bool value) {
  //   _hasAccessToTabCard = value;
  //   notifyListeners();
  // }
  //
  Future<void> grantAccessToTabCard() async {
    if (_email == 's@gmail.com' || _email == 'lime2@gmail.com') {
      _hasAccessToTabCard = true;
    }
    notifyListeners();
  }
}
