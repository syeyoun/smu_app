import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

class MyWidget_1 extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget_1> {
  bool isClicked = false; // 초기 상태는 false

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

  showNotification() async {
    var androidDetails = AndroidNotificationDetails(
      'a',
      'b',
      priority: Priority.high,
      importance: Importance.max,
      color: Color.fromARGB(255, 255, 0, 0),
    );

    // 알림 id, 제목, 내용 맘대로 채우기
    notifications.show(
        1,
        '제목1',
        '내용1',
        NotificationDetails(android: androidDetails)
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context);
    final tabState = Provider.of<TabState>(context);

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
                  Text("사용중!", style:
                  TextStyle(fontSize: 25, color: Color((0xff0E207F))),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 100,
                  child:
                  Text(
                      '남은 시간! ${logoutTimerProvider.getRemainingTime()}', style:
                  TextStyle(fontSize: 25, color: Color(0xff0E207F))),
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
                                logoutTimerProvider.getRemainingTime() != null &&
                                _isRemainingTimeValid(
                                    logoutTimerProvider.getRemainingTime()) &&
                                _getRemainingMinutes(
                                    logoutTimerProvider.getRemainingTime()) <= 5)
                                ? () {
                              setState(() {
                                logoutTimerProvider.addTime(
                                    Duration(seconds: 3));
                              });
                            } : null,
                            child:
                            Text('연장?', style:
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
                        await showNotification();
                        await itemProvider.incrementAllPrices();
                        await tabState.toggleClick();
                        logoutTimerProvider.onLogoutComplete = () async {
                          await itemProvider.decrementAllPrices();
                          logoutTimerProvider.logoutUser();
                          tabState.resetClick();
                          logoutAndRedirect();
                        };
                        // await showNotification();
                        await logoutTimerProvider.startLogoutCountdown();
                      },
                      child:
                      Text('출석?', style:
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