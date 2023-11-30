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
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LogoutTimerProvider with ChangeNotifier,WidgetsBindingObserver {
  bool hasLogoutCompleted = false;
  Duration _logoutDuration = Duration(seconds: 100);
  late CollectionReference itemsReference;
  List<Item> items = [];

  final ItemProvider itemProvider;
  Function()? onLogoutComplete;

  final FirebaseAuthProvider _authProvider;

  Timer? _timer;
  LogoutTimerProvider({FirebaseAuthProvider? authProvider, ItemProvider? itemProv})
      : _authProvider = authProvider ?? FirebaseAuthProvider(),
        itemProvider = itemProv ?? ItemProvider(){
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 갔을 때 현재 시간을 저장
      await prefs.setInt('backgroundTime', DateTime.now().millisecondsSinceEpoch);
    } else if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드로 돌아왔을 때 저장된 시간을 불러와 현재 시간과 비교
      int? backgroundTime = prefs.getInt('backgroundTime');
      if (backgroundTime != null) {
        Duration diff = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(backgroundTime));
        // diff를 사용하여 남은 시간을 계산
        if (_logoutDuration > diff) {
          _logoutDuration -= diff;
        } else {
          _logoutDuration = Duration(seconds: 0);
        }
        notifyListeners();
      }
    }
  }

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
    _isCountdownStarted = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {

      if (_logoutDuration == Duration(seconds:0)) {
        if (onLogoutComplete != null) {
          onLogoutComplete!();
          // notifyListeners();
        }
        // notifyListeners();
      } else {
        _logoutDuration = _logoutDuration - Duration(seconds: 1);
        notifyListeners(); // UI 갱신을 위해 호출
      }
    });
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', false);
    prefs.setString('email', '');
    prefs.setString('password', '');
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
    WidgetsBinding.instance.removeObserver(this);
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