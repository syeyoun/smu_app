// models/model_time.dart
// import 'dart:js';
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
import 'package:flutter/material.dart';
import 'package:test_1/models/model_tabstate.dart';

class LogoutTimerProvider with ChangeNotifier {
  bool hasLogoutCompleted = false;
  Duration _logoutDuration = Duration(seconds: 10);
  late CollectionReference itemsReference;
  List<Item> items = [];

  final ItemProvider itemProvider;
  Function()? onLogoutComplete;

  final FirebaseAuthProvider _authProvider;

  Timer? _timer;
  // Duration _logoutDuration = Duration(seconds: 10);
  LogoutTimerProvider({FirebaseAuthProvider? authProvider, ItemProvider? itemProv})
      : _authProvider = authProvider ?? FirebaseAuthProvider(),
        itemProvider = itemProv ?? ItemProvider();

  bool _isCountdownStarted = false; // 추가된 상태

  bool get isCountdownStarted => _isCountdownStarted;

  Future<void> fetchItems() async {
    items = await itemsReference.get().then((QuerySnapshot results) {
      return results.docs.map((DocumentSnapshot document) {
        return Item.fromSnapshot(document);
      }).toList();
    });
    notifyListeners();
  }

  Future<void> startLogoutCountdown() async{
    // Duration _logoutDuration = Duration(seconds: 10);
    _isCountdownStarted = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if (_logoutDuration == Duration(seconds:0)) {
        // Call the callback function when the timer completes
        // logoutUser();
        // itemProvider.decrementAllPrices();
        // logoutAndRedirect();
        if (onLogoutComplete != null) {
         // logoutUser();
         //  hasLogoutCompleted = true;
          onLogoutComplete!();
          // logoutUser();

          // notifyListeners();
        }
        // notifyListeners();
      } else {
        _logoutDuration = _logoutDuration - Duration(seconds: 1);
        notifyListeners(); // UI 갱신을 위해 호출
      }
    });
  }

  // Future<void> logoutAndRedirect() async {
  //   ScaffoldMessenger.of(navigatorKey.currentContext)
  //     ..hideCurrentSnackBar()
  //     ..showSnackBar(SnackBar(content: Text('logout!')));
  //
  //   // GlobalKey를 사용하여 Navigator 상태에 접근
  //   navigatorKey.currentState.pushReplacementNamed('/login');
  // }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('email', '');
    prefs.setString('password', '');
    // await itemProvider.decrementAllPrices();
    await _authProvider.logout(); // FirebaseAuthProvider의 logout() 메서드 호출
    await cancelLogoutTimer();
    _logoutDuration = Duration(seconds: 10);
    notifyListeners();
  }

  Future<void> cancelLogoutTimer() async {
    _timer?.cancel();
    _timer = null;
  }

  String getRemainingTime() {
    if (_timer == null || !_timer!.isActive) return '00:00';
    // Duration _logoutDuration = Duration(seconds: 10);
    final now = DateTime.now();
    final logoutTime = now.add(_logoutDuration);
    final remainingDuration = logoutTime.difference(now);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(remainingDuration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(remainingDuration.inSeconds.remainder(60));
    notifyListeners();
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    cancelLogoutTimer(); // 프로바이더가 소멸될 때 타이머도 함께 취소
    super.dispose();
  }
  int changestring(string){
    int intTime;
    intTime=int.parse(string);
    return intTime;
  }
  void addTime(Duration additionalTime) {
    _logoutDuration += additionalTime;
    notifyListeners();
  }


}