import 'package:flutter/material.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_1/models/model_auth.dart';

class Busseats2 extends StatefulWidget {
  const Busseats2({Key? key}) : super(key: key);
  @override
  _Busseats2State createState() => _Busseats2State();
}

class _Busseats2State extends State<Busseats2> {
  List<List<int>> _chairStatus = List.generate(2, (i) => List<int>.filled(2, 0));

  Future<void> fetchChairStatuses() async {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 2; j++) {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('chair').doc('chair${i * 2 + j + 1}').get();
        var data = doc.data() as Map<String, dynamic>;
        _chairStatus[i][j] = data['status'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchChairStatuses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();  // 데이터 로딩 중일 때 보여줄 위젯
        }
        Size size = MediaQuery.of(context).size;
        return Container(
          child: Column(
            children: <Widget>[
              for (int i = 0; i < 2; i++)
                Container(
                  margin: EdgeInsets.only(top: i == 0 ? 50 : 0),
                  child: Row(
                    children: <Widget>[
                      for (int x = 0; x < 2; x++)
                        Expanded(
                          child: Container(
                            height: 60,
                            margin: EdgeInsets.all(5),
                            child: _chairStatus[i][x] == 1
                                ? availableChair(i, x)
                                : _chairStatus[i][x] == 3
                                ? reservedChair(i, x)
                                : Container(),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget availableChair(int a, int b){
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // 현재 로그인한 사용자의 UID를 가져옵니다.
    String uid_chair = auth.currentUser!.uid;
    return InkWell(
      onTap: (){
        if(_chairStatus[a][b]==1){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  title: Text('예약하기'),
                  content: Text('예약하시겠습니까?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('예'),
                      onPressed: () async {
                        _chairStatus[a][b]=3;
                        // Firebase의 해당 위치를 업데이트
                        String chairName = 'chair' + (a * 4 + b + 1).toString();
                        await FirebaseFirestore.instance.collection('chair').doc(chairName).update({'status': 3});
                        await FirebaseFirestore.instance.collection('chair').doc(chairName).update({'ID': uid_chair});
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('아니오'),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(3.0),
          border : Border.all(
            color: Color.fromRGBO(0, 0, 0, 1),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget reservedChair(int a, int b) {
    // Firebase에서 문서 조회
    String chairName = 'chair' + (a * 4 + b + 1).toString();
    var futureDoc = FirebaseFirestore.instance.collection('chair').doc(chairName).get();

    return FutureBuilder<DocumentSnapshot>(
      future: futureDoc, // 위에서 선언한 Future
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          // 문서의 ID 필드가 사용자의 UID와 일치하는지 확인
          if (data['ID'] == FirebaseAuth.instance.currentUser!.uid) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(3.0)
              ),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(15, 15, 15, 0.24),
                  borderRadius: BorderRadius.circular(3.0)
              ),
            );
          }
        }

        // 데이터를 아직 불러오지 못한 경우
        return CircularProgressIndicator();
      },
    );
  }
}