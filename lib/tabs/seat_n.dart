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

class AdditionalScreen extends StatelessWidget {
  final String chairNumber;
  AdditionalScreen({required this.chairNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('예약 가능한 좌석'),
      ),
      body: buildTimeSlots(),
    );
  }

  Widget buildTimeSlots() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: List.generate(8, (index) {
          int time = 13 + index;
          return TimeSlot(time: '$time시', chairNumber: chairNumber);
        }),
      ),
    );
  }
}

class TimeSlot extends StatefulWidget {
  final String time;
  final String chairNumber;
  TimeSlot({required this.time, required this.chairNumber});

  @override
  _TimeSlotState createState() => _TimeSlotState(chairNumber);
}

class _TimeSlotState extends State<TimeSlot> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String bookedUserId = 'a';
  String chairNumber; // 추가된 인스턴스 변수
  _TimeSlotState(this.chairNumber);
  @override
  Widget build(BuildContext context) {
    String uid_chair = auth.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection('chair').doc(chairNumber).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          bookedUserId = data[widget.time];
          Color color;

          if (bookedUserId == 'a') {
            color = Colors.grey; // 예약 가능한 상태
          } else if (bookedUserId == uid_chair) {
            color = Colors.yellow; // 현재 사용자가 예약한 상태
          } else {
            color = Colors.red; // 다른 사용자가 예약한 상태
          }

          return InkWell(
            onTap: () {
              // 다른 사용자가 예약한 시간을 선택한 경우
              if (bookedUserId != 'a' && bookedUserId != uid_chair) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('예약이 되어있어요!')),
                );
              }
              else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // 현재 사용자가 예약한 시간을 선택한 경우
                    if (bookedUserId == uid_chair) {
                      return AlertDialog(
                        title: Text('예약 취소하기'),
                        content: Text('${widget.time}의 예약을 취소하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('예'),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('chair')
                                  .doc(chairNumber)
                                  .update({
                                widget.time: 'a' // 예약 상태를 'a'로 변경
                              });
                              Navigator.of(context).pop();
                              setState(() { // UI를 새로 고침
                                bookedUserId = 'a';
                              });
                            },
                          ),
                          TextButton(
                            child: Text('아니오'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                    // 예약 가능한 시간을 선택한 경우
                    else {
                      return AlertDialog(
                        title: Text('예약하기'),
                        content: Text('${widget.time}에 예약하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('예'),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('chair')
                                  .doc(chairNumber)
                                  .update({
                                widget.time: uid_chair
                              });
                              Navigator.of(context).pop();
                              setState(() { // UI를 새로 고침
                                bookedUserId = uid_chair;
                              });
                            },
                          ),
                          TextButton(
                            child: Text('아니오'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }
                  },
                );
               }
              },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(widget.time),
            ),
          );
        }

        return Text("Loading");
      },
    );
  }
}

class _Busseats2State extends State<Busseats2> {
  List<List<int>> _chairStatus = List.generate(2, (i) => List<int>.filled(2, 0));

  @override
  Widget build(BuildContext context) {
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
                        child: _chairStatus[i][x] == 0
                            ? reservecheck(i, x)
                            : Container(),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget reservecheck(int i, int x) {
    String chairNumber = 'chair' + (i * 10 + x + 1).toString();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Container(
                width: 200,
                height: 300, // 원하는 높이로 조정 가능
                child: AdditionalScreen(chairNumber: chairNumber),
              ),
            );
          },
        );
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
        // 기존의 Container 내용...
      ),
    );
  }
}