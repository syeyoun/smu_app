// tabs/tab_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';
import 'package:test_1/screens/screen_qr_2.dart';
import 'package:test_1/models/model_permission.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_1/screens/screen_attendance.dart';

String cardVal = '';
User? user = FirebaseAuth.instance.currentUser;

class TabProfile extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("사용자 정보"),
              LoginOutButton(itemIndex: 3),
              // CardQr(),
              AttendanceButton(),
              CardQr(),
              TabCard(),
            ],
          ),
        )
    );
  }
}

class LoginOutButton extends StatelessWidget {
  final int itemIndex;
  LoginOutButton({required this.itemIndex});

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context);
    final tabState = Provider.of<TabState>(context);

    return TextButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (tabState.isClicked) {
            // await itemProvider.decrementAllPrices();
            await prefs.clear();
            tabState.resetClick();
            await logoutTimerProvider.logoutUser();
            // logoutAndRedirect();
            // await itemProvider.decrementAllPrices();
          }
          await prefs.clear();
          tabState.resetClick();
          await logoutTimerProvider.logoutUser_1();
          // logoutAndRedirect();
        },
        child: Text(
          '로그 아웃',
          style: TextStyle(
            color: Color(0xff0E207F),  // 텍스트 색상을 빨간색으로 설정
          ),
        ));
  }
}
class CardQr extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:(() {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('주의!'),
              content: Text('카드키 관리자 변경을 하시겠습니까?'),
              actions: [
                TextButton(
                  onPressed: () async{
                    Navigator.pop(context);
                    await Navigator.push(context ,MaterialPageRoute(builder:(context)=>ScannerScreen_2()));
                  },
                  child: const Text('YES'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('NO'),
                ),
              ],
            ));
      }),
        child: Text(
          '카드키 스캔',
          style: TextStyle(
            color: Color(0xff0E207F),  // 텍스트 색상을 빨간색으로 설정
          ),
        ));
  }
}

class TabCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return Builder(
      // builder: (BuildContext context) {
        return TextButton(
          onPressed: () async {
            try {
              User? user = FirebaseAuth.instance.currentUser;
              if(user != null) {
                DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                if(userDoc.exists) {
                  Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
                  if(userData != null && userData.containsKey('role')) {
                    if(userData['role'] == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdditionalScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('권한이 없습니다'))
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('권한이 없습니다'))
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('권한이 없습니다'))
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('권한이 없습니다'))
                );
              }
            } catch (e) {
              print('An error occurred: $e');
            }
          },
          child: Text(
            '관리자 탭',
            style: TextStyle(
              color: Color(0xff0E207F),  // 텍스트 색상을 빨간색으로 설정
            ),
          ),
        );
      // },
    // );
  }
}

class AttendanceButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return TextButton(

      onPressed: () {
        //_fetchAttendanceData(),
        Navigator.push(context ,MaterialPageRoute(builder:(context)=>Attendance()));},
      child: Text(
        '전자 출입 명부',
        style: TextStyle(
          color: Color(0xff0E207F),  // 텍스트 색상을 빨간색으로 설정
        ),
      ),);
    /*return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 버튼 클릭 시 출석 데이터 불러오기
            _fetchAttendanceData();
          },
          child: Text('출석 데이터 불러오기'),
        ),
      ),
    );*/
  }
}

class AdditionalScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
        '카드 정보 변경',
        style: TextStyle(
          color: Colors.white,  // 텍스트 색상을 빨간색으로 설정
        ),
      ),
        backgroundColor: Color(0xff0E207F),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: '카드키를 가지고있는사람은?'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('items1').doc('AN4TLA8ts0AGLAlivfoM').update({
                  'card': _controller.text,
                });
                _controller.clear();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xff0E207F),  // 버튼의 배경 색상을 설정
              ),
              child: Text(
                '저장',
                style: TextStyle(
                  color: Colors.white,  // 텍스트 색상을 빨간색으로 설정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}