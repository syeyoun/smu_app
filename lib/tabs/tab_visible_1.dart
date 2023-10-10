import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool isClicked = false; // 초기 상태는 false

  bool _isRemainingTimeValid(String? remainingTimeString) {
    if (remainingTimeString == null) return false;

    List<String> timeComponents = remainingTimeString.split(":");

    if (timeComponents.length != 2) return false;

    int hours = int.tryParse(timeComponents[0]) ?? -1;
    int minutes = int.tryParse(timeComponents[1]) ?? -1;

    return hours >= 0 && hours < 24 && minutes >=0 && minutes <60;
  }

  int _getRemainingMinutes(String? remainingTimeString) {
    if (!_isRemainingTimeValid(remainingTimeString)) return -1;

    List<String> timeComponents = remainingTimeString!.split(":");
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);

    return hours * 60 + minutes;
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context); // listen 속성을 제거하였습니다.

    return FutureBuilder(
        future: itemProvider.fetchItems(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          return Column(
            children: [
              InkWell(
                onTap: isClicked ? null : () async {
                  setState(() {
                    isClicked = true;
                  });
                  // 나머지 로직...
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('Price', style:
                      TextStyle(fontSize:
                      isClicked ?16 :20,color:
                      Colors.red),
                      ),
                      if (isClicked) ...[
                        Text("사용중!", style:
                        TextStyle(fontSize:
                        isClicked ?16 :20,color:
                        Colors.red),
                        ),
                        Text('Remaining Time:${logoutTimerProvider.getRemainingTime()}'), // 로그아웃까지 남은 시간 표시
                        ElevatedButton(
                          onPressed: logoutTimerProvider.isCountdownStarted&& logoutTimerProvider.getRemainingTime() != null &&
                              _isRemainingTimeValid(logoutTimerProvider.getRemainingTime()) &&
                              _getRemainingMinutes(logoutTimerProvider.getRemainingTime()) <= 5
                              ? () {
                            setState(() {
                              logoutTimerProvider.addTime(Duration(seconds: 3));
                            });
                          }
                              : null,
                          child: Text('연장'),
                        ),
                      ] else ...[
                        ElevatedButton(
                            onPressed: () async {

                              setState(() { isClicked = !isClicked; });
                              logoutTimerProvider.onLogoutComplete = () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(SnackBar(content: Text('logout!')));
                                Navigator.of(context).pushReplacementNamed('/login');
                              };
                              logoutTimerProvider.startLogoutCountdown();
                            },
                            child: Text('출석?')
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}