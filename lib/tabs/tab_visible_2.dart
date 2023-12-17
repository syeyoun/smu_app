import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';
import '../models/model_hash.dart';

// var r_qr = await hashProvider.getQRNumFromFirebase();

class MyWidget_1 extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

Duration logoutDuration = Duration(minutes: 10);

class _MyWidgetState extends State<MyWidget_1> {
  bool isClicked = false; // 초기 상태는 false
  //User? user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // 사용자 정보가 존재하지 않을 경우 null 반환
    return userSnapshot.exists
        ? userSnapshot.data() as Map<String, dynamic>
        : null;
  }

  Future<void> setLogoutDuration_login(Duration duration) async {
    logoutDuration = Duration(minutes: 10);
  }

  bool _isRemainingTimeValid(String? remainingTimeString) {
    if (remainingTimeString == null) return false;
    List<String> timeComponents = remainingTimeString.split(":");
    if (timeComponents.length != 2) return false;
    int hours = int.tryParse(timeComponents[0]) ?? -1;
    int minutes = int.tryParse(timeComponents[1]) ?? -1;
    return hours >= 0 && hours < 24 && minutes >= 0 && minutes < 60;
  }

  int _getRemainingMinutes(String? remainingTimeString) {
    if (!_isRemainingTimeValid(remainingTimeString)) return -1;
    List<String> timeComponents = remainingTimeString!.split(":");
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    return hours * 60 + minutes;
  }

  Future<Map<String, dynamic>?> _getUInfo(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // 사용자 정보가 존재하지 않을 경우 null 반환
    return userSnapshot.exists
        ? userSnapshot.data() as Map<String, dynamic>
        : null;
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    final itemProvider = Provider.of<ItemProvider>(context);
    final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context);
    final tabState = Provider.of<TabState>(context);
    final hashProvider = Provider.of<HashProvider>(context);
    hashProvider.getQRCodeDataFromSharedPreferences();
    var hash = hashProvider.hashValue;
    var r_qr = hashProvider.qrnum;
    String uid_attendance = auth.currentUser!.uid;
    //print(uid_attendance);
    Duration logoutDuration = Provider.of<LogoutTimerProvider>(context, listen: false).logoutDuration;

    return FutureBuilder(
        future: itemProvider.fetchItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Stack(
            children: [
              // 기타 위젯들...
              if (tabState.isClicked) ...[
                Positioned(
                  top: 200,
                  left: 100,
                  child:
                  Text("사용중", style:
                  TextStyle(fontSize: 20, color: Color((0xff0E207F))),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 100,
                  child:
                  Text(
                      '남은 시간: ${logoutTimerProvider.getRemainingTime()}', style:
                  TextStyle(fontSize: 20, color: Color(0xff0E207F))),
                ),
                Positioned(
                    bottom: 100,
                    left: 100,
                    child:
                    Container(
                        width: 200,
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0E207F),
                              shape: RoundedRectangleBorder(borderRadius:
                              BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: (logoutTimerProvider
                                .isCountdownStarted &&
                                logoutTimerProvider.getRemainingTime() !=
                                    null &&
                                _isRemainingTimeValid(
                                    logoutTimerProvider.getRemainingTime()) &&
                                _getRemainingMinutes(
                                    logoutTimerProvider.getRemainingTime()) <=
                                    5)
                                ? () {
                              setState(() {
                                logoutTimerProvider.addTime(
                                    Duration(seconds: 3));
                              });
                            } : null,
                            child:
                            Text('연장', style:
                            TextStyle(fontSize: 25, color:
                            Colors.white),
                            )
                        )
                    )
                ),
              ] else
                ...[
                  Positioned(
                      bottom: 100, left: 100, child:
                  Container(
                      width: (200), height: (60), child:
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor:
                      Color(0xff0E207F),
                        shape: RoundedRectangleBorder(borderRadius:
                        BorderRadius.circular(30.0),),),
                      onPressed: (tabState.isClicked)
                          ? null : () async {
                        if (hash == r_qr) {
                          final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context);
                          await setLogoutDuration_login(logoutDuration);
                          await itemProvider.incrementAllPrices();
                          await tabState.toggleClick();
                          Map<String, dynamic>? userInfo = await _getUInfo(uid_attendance);
                          await FirebaseFirestore.instance.collection(
                              'attendance').add({
                            'user_uid': uid_attendance,
                            'username': userInfo?['username'],
                            'studentid': userInfo?['studentID'],
                            'timestamp': FieldValue.serverTimestamp(),
                          });
                          await logoutTimerProvider.startLogoutCountdown();
                        }
                        else {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(content: Text('QR인식 후에 다시 시도해주세요.',
                                  style: TextStyle(fontSize: 20))),);
                        }
                      },
                      child:
                      Text('출석', style:
                      TextStyle(fontSize: 25, color:
                      Colors.white,),
                      )
                  )
                  )
                  ),
                ],
            ],
          );
        }
    );
  }
}