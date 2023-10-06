// models/model_time.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class LogoutTimerProvider with ChangeNotifier {
  Function()? onLogoutComplete;
  final FirebaseAuthProvider _authProvider;
  Timer? _timer;
  Duration _logoutDuration = Duration(seconds: 10);
  LogoutTimerProvider({FirebaseAuthProvider? authProvider})
      : _authProvider = authProvider ?? FirebaseAuthProvider();

  void startLogoutCountdown(){

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_logoutDuration == Duration(seconds:1)) {
        // Call the callback function when the timer completes
        timer.cancel();
        logoutUser();
        if (onLogoutComplete != null) {
          onLogoutComplete!();
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

    notifyListeners();
  }
  // Future<void> logoutUser(BuildContext context) async {
  //   final authClient = Provider.of<FirebaseAuthProvider>(context);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('isLogin', false);
  //   prefs.setString('email', '');
  //   prefs.setString('password', '');
  //   // user = null;
  //   await authClient.logout(); // FirebaseAuthProvider의 logout() 메서드 호출
  //
  //   notifyListeners();
  // }

  void cancelLogoutTimer() {
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

    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    cancelLogoutTimer(); // 프로바이더가 소멸될 때 타이머도 함께 취소
    super.dispose();
  }
}