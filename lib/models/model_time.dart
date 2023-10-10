// models/model_time.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_1/models/model_auth.dart';
import 'dart:async';

class LogoutTimerProvider with ChangeNotifier {
  Function()? onLogoutComplete;
  final FirebaseAuthProvider _authProvider;
  Timer? _timer;
  Duration _logoutDuration = Duration(seconds: 10);
  LogoutTimerProvider({FirebaseAuthProvider? authProvider})
      : _authProvider = authProvider ?? FirebaseAuthProvider();

  bool _isCountdownStarted = false; // 추가된 상태

  bool get isCountdownStarted => _isCountdownStarted;

  // final _remainingTimeController = StreamController<String>();
  // Stream<String> get remainingTimeStream => _remainingTimeController.stream;

  void startLogoutCountdown(){
    _isCountdownStarted = true;
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
    // notifyListeners();
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