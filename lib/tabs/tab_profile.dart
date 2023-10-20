// tabs/tab_profile.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';

class TabProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("사용자 정보"),
          LoginOutButton(itemIndex: 3),
        ],
      ),
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
          //decrease
          await itemProvider.decrementAllPrices();
          tabState.resetClick();
          logoutTimerProvider.logoutUser();
          logoutAndRedirect();
          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(SnackBar(content: Text('logout!')));
          // Navigator.of(context).pushReplacementNamed('/login');
        },
        child: Text('로그 아웃?'));
  }
}