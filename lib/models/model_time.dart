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
import 'package:test_1/main.dart';
import 'package:test_1/models/model_tabstate.dart';

class LogoutTimerProvider with ChangeNotifier,WidgetsBindingObserver {
  bool hasLogoutCompleted = false;
  Duration logoutDuration = Duration(seconds: 20);
  late CollectionReference itemsReference;
  List<Item> items = [];

  final FirebaseAuthProvider _authProvider;
  final TabState _tabState;
  final ItemProvider itemProvider;
  Function()? onLogoutComplete;

  Timer? _timer;
  LogoutTimerProvider({FirebaseAuthProvider? authProvider, ItemProvider? itemProv, TabState? tabState})
      : _authProvider = authProvider ?? FirebaseAuthProvider(),
        itemProvider = itemProv ?? ItemProvider(),
        _tabState = tabState ?? TabState() {
    WidgetsBinding.instance.addObserver(this);
  }

  // Future<void> setLogoutDuration (Duration duration) async {
  //   logoutDuration = Duration(seconds: 20);
  // }

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
        if (logoutDuration > diff) {
          logoutDuration -= diff;
          // logoutAndRedirect_1();
          await startLogoutCountdown();
        } else {
          logoutDuration = Duration(seconds: 0);
          // logoutAndRedirect();
          // logoutUser(); // 카운트다운이 끝났을 때 로그아웃 처리
        }
        await prefs.remove('backgroundTime');
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

  Future<void> startLogoutCountdown() async {
    cancelLogoutTimer();
    if(_isCountdownStarted) {
      return;
    }
    _isCountdownStarted = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (logoutDuration <= Duration(seconds:0)) {
        // logoutAndRedirect_1();
        _isCountdownStarted = false;

        await logoutUser(); // 카운트다운이 끝났을 때 로그아웃 처리
        // cancelLogoutTimer();
        // _isCountdownStarted = false;
        // logoutDuration = Duration(seconds: 20);
        // print(_logoutDuration);
        // if (onLogoutComplete != null) {
        //   onLogoutComplete!();
        // }
        // if (_logoutDuration == Duration(seconds:0))
        // logoutUser(); // 카운트다운이 끝났을 때 로그아웃 처리
      } else {
        logoutDuration = logoutDuration - Duration(seconds: 1); // 카운트다운 시간 감소
        notifyListeners();
      }
    });
  }

  Future<void> logoutUser() async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('items1')
        .doc('AN4TLA8ts0AGLAlivfoM');

    // 문서를 가져와 'price' 필드의 값 확인
    DocumentSnapshot docSnap = await docRef.get();
    if (docSnap.exists) {
      Map<String, dynamic>? data = docSnap.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('price') && data['price'] > 0) {
        // 'price' 필드의 값이 0 초과일 때만 감소
        await docRef.update({
          'price': FieldValue.increment(-1)
        });
      }
    }
    logoutDuration = Duration(seconds: 20);
    await cancelLogoutTimer();
    await _tabState.resetClick();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await logoutAndRedirect_1();
    // await _tabState.resetClick();
    // await _authProvider.logout(); // FirebaseAuthProvider의 logout() 메서드 호출
    // await cancelLogoutTimer();
    // logoutDuration = Duration(seconds: 20);
    // notifyListeners();
  }

  Future<void> logoutUser_1() async {
    await cancelLogoutTimer();
    await _tabState.resetClick();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await logoutAndRedirect_1();
    // await _tabState.resetClick();
    // await _authProvider.logout(); // FirebaseAuthProvider의 logout() 메서드 호출
    // await cancelLogoutTimer();
    logoutDuration = Duration(seconds: 20);
    // notifyListeners();
  }

  Future<void> cancelLogoutTimer() async {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _isCountdownStarted = false;
  }

  String getRemainingTime() {
    if (_timer == null || !_timer!.isActive) return '00:00';
    final now = DateTime.now();
    final logoutTime = now.add(logoutDuration);
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
    logoutDuration += additionalTime;
    notifyListeners();
  }

  Future<void> logoutAndRedirect_1() async {
    // navigatorKey.currentContext 가 null 인 경우 처리
    // if (navigatorKey.currentContext == null) {
    //   print('Navigator key is not currently associated with any widget.');
    //   return;
    // }
    // ScaffoldMessenger.of(navigatorKey.currentContext!)
    //   ..hideCurrentSnackBar()
    //   ..showSnackBar(SnackBar(content: Text('logout!')));

    // GlobalKey를 사용하여 Navigator 상태에 접근
    navigatorKey.currentState!.pushReplacementNamed('/login');
  }


}