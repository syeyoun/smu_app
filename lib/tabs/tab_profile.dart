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


String cardVal = '';
/*class TabProfile extends StatefulWidget {

  @override
  _TabProfile createState() {
    return _TabProfile();
  }
}*/
//class _TabProfile extends State<TabProfile> {
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
              CardQr()
            ],
          ),
        )
    );
  }
/*Future<String?> QRCheck() async{
    final prefs = await SharedPreferences.getInstance();
    //cardVal = prefs.getString('card_data')!;
    print(cardVal);
    if(cardVal == 'https://me-qr.com/EEtHTSEE'){
      // users 컬렉션의 모든 문서를 가져옵니다.
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();
      // 모든 username 값을 리스트에 저장합니다.
      List<String> usernames = userSnapshot.docs.map((doc) => doc.get('username') as String).toList();
      // usernames 리스트의 첫 번째 값을 가져옵니다.
      String firstUsername = usernames[0];
      // items1 컬렉션의 특정 문서의 card 필드를 username의 값으로 업데이트합니다.
      await FirebaseFirestore.instance.collection('items1').doc('AN4TLA8ts0AGLAlivfoM').update({
        'card': firstUsername,
      });
    }

    else if(cardVal != 'https://me-qr.com/EEtHTSEE' || cardVal == ''){
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('올바르지 않은 QR입니다. 다시 시도해 주세요.',style: TextStyle(fontSize: 20)),
          ),
        );}
  }*/
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
          // await itemProvider.decrementAllPrices();
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
              // content: Text('Of course not!'),
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