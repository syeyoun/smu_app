import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/tabs/seat_n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int fieldACount = 0;
Future<int> countFieldAInChairCollection() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chair').get();
  int fieldACount = 0;
  for (DocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    data.forEach((key, value) {
      if (value is String && value == 'a') {
        fieldACount++;
      }
    });
  }
  print(fieldACount);
  return fieldACount;
}

class design {
  static InputDecoration dec(String b) {
    InputDecoration c = InputDecoration(
        contentPadding: EdgeInsets.all(8),
        hoverColor: Color(0xff0E207F),
        border: InputBorder.none,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(width: 0, style: BorderStyle.none)),
        fillColor: Color.fromRGBO(239, 239, 239, 1),
        filled: true,
        labelText: b,
        labelStyle: TextStyle(color: Color(0xff0E207F)));
    return c;
  }

  static BoxDecoration boxdec() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(48),
        topRight: Radius.circular(48),
        bottomLeft: Radius.circular(48),
        bottomRight: Radius.circular(48),
      ),
      boxShadow: [
        BoxShadow(
            color: Color(0xff0E207F),
            offset: Offset(0, 4),
            blurRadius: 4)
      ],
      color: Color(0xff0E207F),
    );
  }

  static TextStyle texst(double a, FontWeight b){
    return TextStyle(
      color: Color(0xff0E207F),
      fontFamily: 'Inter',
      fontSize: a,

      fontWeight: b,

    );
  }
}

class busbook extends StatefulWidget {
  int a = 0;
  // late String b;

  busbook(int c, {Key? key}) : super(key: key) {
    a = c;
    // b = d;
  }

  @override
  _busbookState createState() => _busbookState(a);
}

class _busbookState extends State<busbook> {
  int a = 0;
  // late String b;

  _busbookState(int c) {
    a = c;
    // b = d;
  }

Future<void> cancelAllReservations() async {
  String userID = FirebaseAuth.instance.currentUser!.uid;

  // chair 컬렉션에 접근합니다.
  CollectionReference chairs = FirebaseFirestore.instance.collection('chair');

  // 모든 chair 문서를 가져옵니다.
  QuerySnapshot querySnapshot = await chairs.get();

  // 각 chair 문서에 대해 수행합니다.
  for (var doc in querySnapshot.docs) {
    DocumentReference chair = FirebaseFirestore.instance.collection('chair').doc(doc.id);

    // chair 문서의 모든 필드를 가져옵니다.
    Map<String, dynamic>? fields = doc.data() as Map<String, dynamic>?;

    if (fields != null) {
      // 각 필드에 대해 수행합니다.
      for (var field in fields.entries) {
        // 필드 값이 사용자 ID와 일치하면 'a'로 변경합니다.
        if (field.value == userID) {
          chair.update({field.key: 'a'});
        }
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              // color: Color.fromRGBO(255, 205, 5, 1),
              child: Stack(
                children: [
                  Center(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('chair').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('데이터 로드 실패: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text("데이터 로딩 중...");
                        }

                        // 데이터 변화가 감지되면 UI를 업데이트
                        final docs = snapshot.data!.docs;
                        int fieldACount = docs.fold(0, (prev, doc) {
                          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                          int countA = data.values.where((v) => v == 'a').length;
                          return prev + countA;
                        });
                        int availableTime = fieldACount;

                        return Text(
                          '남은 예약 가능 시간: $availableTime시간',
                          style: TextStyle(fontSize: 20, color: Color(0xff0E207F)),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 5,
            ),
            Text(
              '예약할 테이블을 선택 해주세요',
              style: TextStyle(fontSize:(20),color:(Color((0xff0E207F))))
            ),
            Container(
              height: 7,
            ),
            (a == 1)
                ? Stack(
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(0, 0, 0, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Busseats2()
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: TextButton(
                    child: Text("예약 전체 취소",style: TextStyle(fontSize: 15, color: Color(0xff0E207F))),
                    onPressed: () async {
                      // cancelAllReservations();
                      // 예/아니오 선택을 위한 Alert Dialog를 보여줍니다.
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('예약 취소'),
                            content: Text('예약을 전부 취소하시겠습니까?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('예'),
                                onPressed: () {
                                  cancelAllReservations();
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('아니오'),
                                onPressed: () {
                                  // "예"를 선택했을 때의 동작을 작성하세요.
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )
                : Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.fromLTRB(0, 80, 0, 0),
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Busseats2()),
            Container(
              height: 70,
            )
          ],
        ),
      ),
    );
  }
}