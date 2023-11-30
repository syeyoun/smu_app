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

// class TabCard extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userPermissionProvider = Provider.of<UserPermissionProvider>(context);
//
//     if (userPermissionProvider.email == 's@gmail.com') {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('TabCard'),
//         ),
//         body: Center(
//           child: Text('카드를 가지고 있는 사람은 임세윤입니다'),
//         ),
//       );
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('접근 제한'),
//         ),
//         body: Center(
//           child: Text('이 페이지에 접근할 권한이 없습니다'),
//         ),
//       );
//     }
//   }
// }

Future<void> updateCardWithUsername() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 현재 로그인한 사용자의 UID를 가져옵니다.
  String uid = auth.currentUser!.uid;

  // 'users' 컬렉션에서 해당 UID를 가진 문서를 가져옵니다.
  DocumentSnapshot userSnapshot = await firestore.collection('users').doc(uid).get();

  if(userSnapshot.exists) {
    // 가져온 문서에서 'username' 필드의 값을 가져옵니다.
    String username = userSnapshot.get('username') as String;

    // 'items1' 컬렉션의 특정 문서의 'card' 필드를 'username'의 값으로 업데이트합니다.
    await firestore.collection('items1').doc('AN4TLA8ts0AGLAlivfoM').update({
      'card': username,
    });
  } else {
    print("해당 UID를 가진 사용자를 찾을 수 없습니다.");
  }
}

class TabCard extends StatelessWidget {
  // 텍스트필드의 컨트롤러를 생성합니다. 이를 통해 텍스트필드의 값을 가져올 수 있습니다.
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userPermissionProvider = Provider.of<UserPermissionProvider>(context);

    if (userPermissionProvider.hasAccessToTabCard) {
      return Scaffold(
        appBar: AppBar(
          title: Text('TabCard'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(hintText: '카드키를 가지고있는사람은?'),
              ),
              ElevatedButton(
                onPressed: updateCardWithUsername,
                child: Text('업데이트'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // 버튼을 누르면 텍스트필드의 값을 Firestore의 특정 문서에 업데이트합니다.
                  await FirebaseFirestore.instance.collection('items1').doc('AN4TLA8ts0AGLAlivfoM').update({
                    'card': _controller.text,
                    // 'timestamp': DateTime.now(),
                  });
                  _controller.clear(); // 텍스트필드를 비웁니다.
                },
                child: Text('데이터베이스에 저장'),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('접근 제한'),
        ),
        body: Center(
          child: Text('이 페이지에 접근할 권한이 없습니다'),
        ),
      );
    }
  }
}

