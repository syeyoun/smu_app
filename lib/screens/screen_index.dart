//screens/screen_index.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/tabs/tab_card.dart';
import 'package:test_1/tabs/tab_home.dart';
import 'package:test_1/tabs/tab_profile.dart';
import 'package:test_1/tabs/tab_visible_1.dart';
import 'package:test_1/models/model_hash.dart';
import 'package:provider/provider.dart';
import 'package:test_1/tabs/tab_visible_2.dart';
import 'package:test_1/models/model_permission.dart';
import 'package:test_1/tabs/selection.dart';
import 'package:test_1/tabs/tab_board.dart';

class IndexScreen extends StatefulWidget {

  @override
  _IndexScreenState createState() {
    return _IndexScreenState();
  }
}

class _IndexScreenState extends State<IndexScreen> {

  int _currentIndex = 0;

  final List<Widget> tabs = [
    TabHome(),
    // TabLock(),
    // TabVisible(),
    MyWidget_1(),
    TabProfile(),
    TabCard(),
    busbook(1),
    TabLock(),
    // TabProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    var hashProvider = Provider.of<HashProvider>(context);
    return Scaffold(
        appBar: AppBar(
            title: Text("SMU"),
            centerTitle: true,
            backgroundColor: Color(0xff0E207F)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 44,
        selectedItemColor: Color(0xff0E207F),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 10&& hashProvider.hashValue == ''){
            showDialog(
              context:  context,
              builder: (ctx)=>AlertDialog(
                title : Text('QR로 인증해주세요!',style: TextStyle(
                  color: Color(0xff0E207F), // 원하는 색상으로 변경
                ),),
                  actions: <Widget>[
                    TextButton(
                    child: Text('OK',style: TextStyle(
                      color: Color(0xff0E207F), // 원하는 색상으로 변경
                    ),),
                    onPressed:(){
                      Navigator.of(context).pop();
                      setState(() {
                        _currentIndex = 0; // Set index to the first tab.
                      });
                    },
                  ),
                ],
              )
            );
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          // BottomNavigationBarItem(icon: Icon(Icons.lock_open), label: 'Lock'),//search
          BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'visible'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
          BottomNavigationBarItem(icon: Icon(Icons.lock_open), label: 'Lock'),//search
          BottomNavigationBarItem(icon: Icon(Icons.chair_alt), label: 'selection'),//search
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'board'),//search
        ],
      ),
      body: tabs[_currentIndex]
    );
  }
}
