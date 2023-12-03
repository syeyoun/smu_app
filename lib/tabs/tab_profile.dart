// tabs/tab_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';
import 'package:test_1/screens/screen_qr_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_permission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

String cardVal = '';

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
              CardQr(),
              Expanded(child: TabCard()),
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
          if (tabState.isClicked) {
            await itemProvider.decrementAllPrices();
          }
          tabState.resetClick();
          logoutTimerProvider.logoutUser();
          logoutAndRedirect();
        },
        child: Text('로그 아웃?'));
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
                  onPressed: () {
                    Navigator.push(context ,MaterialPageRoute(builder:(context)=>ScannerScreen_2()));
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
      child: Text('카드키 관리자'),);
  }
}

class TabCard extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userPermissionProvider = Provider.of<UserPermissionProvider>(context);
    if (userPermissionProvider.hasAccessToTabCard) {
      return Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5, // 화면 너비의 80%
            height: MediaQuery.of(context).size.height * 0.5, // 화면 높이의 60%
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Flexible( // Flexible 위젯 추가
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
                      },
                      child: Text('데이터베이스에 저장'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text('이 페이지에 접근할 권한이 없습니다'),
        ),
      );
    }
  }
}