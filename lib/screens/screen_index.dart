//screens/screen_index.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/tabs/tab_home.dart';
import 'package:test_1/tabs/tab_visible.dart';
import 'package:test_1/tabs/tab_lock.dart';
import 'package:test_1/tabs/tab_profile.dart';


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
    TabLock(),
    TabVisible(),
    TabProfile(),
    // TabProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 44,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontSize: 12),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.lock_open), label: 'Lock'),//search
          BottomNavigationBarItem(icon: Icon(Icons.visibility), label: 'visible'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ),
      body: tabs[_currentIndex]
    );
  }
}