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
        title: Text('예약 가능 시간'),
        backgroundColor: Color(0xff0E207F),
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
            color = Color(0xff0E207F); // 현재 사용자가 예약한 상태
          } else {
            color = Colors.red; // 다른 사용자가 예약한 상태
          }
          int reservationCount;

          Future<int> getUserReservationCount(String uid_chair) async {
            // Firestore에서 chair 컬렉션 전체를 가져옵니다.
            QuerySnapshot chairSnapshot = await FirebaseFirestore.instance.collection('chair').get();

            // userID의 예약이 몇 개인지 세어봅니다.
            int reservationCount = 0;
            chairSnapshot.docs.forEach((doc) {
              Map<String, dynamic> chairData = doc.data() as Map<String, dynamic>;
              chairData.values.forEach((value) {
                if (value == uid_chair) {
                  reservationCount++;
                }
              });
            });

            return reservationCount;
          }
          // int reservationCount;

          return InkWell(
            onTap: () async{
              int reservationCount =0;
              getUserReservationCount(uid_chair);
              // 다른 사용자가 예약한 시간을 선택한 경우
              if (bookedUserId != 'a' && bookedUserId != uid_chair) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('예약이 되어있어요!')),
                );
              }
              // else if (bookedUserId == 'a') {
              //   if (reservationCount >= 3) {
              //     // userID의 예약이 3개 이상이면 SnackBar를 띄웁니다.
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('3시간 이상 예약 불가능해요!')),
              //     );
              //   }
              // }
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
                    else {
                      int _selectedHour = 1;  // 기본값을 1시간으로 설정합니다.
                      // void _updateSelectedHour(int? newValue) {
                      //   setState(() {
                      //     _selectedHour = newValue!;
                      //   });
                      // }
                      Future<void> _updateReservation() async {
                        List<Future> updates = [];
                        for (int i = 0; i < _selectedHour; i++) {
                          // widget.time에서 시간 부분만 추출하고, i를 더해 새로운 시간을 계산합니다.
                          String newTime = (int.parse(widget.time.split('시')[0]) + i).toString() + '시';
                          updates.add(
                              FirebaseFirestore.instance
                                  .collection('chair')
                                  .doc(chairNumber)
                                  .update({
                                newTime: uid_chair  // 예약 시간을 업데이트합니다.
                              })
                          );
                        }
                        await Future.wait(updates);
                      }
                      return StatefulBuilder(
                          builder: (context, setState) {
                            int _selectedHour = 1;  // 선택된 시간 값을 저장하는 변수입니다.
                            void _updateSelectedHour(int? newValue) {
                              setState(() {
                                _selectedHour = newValue!;  // 선택된 시간 값을 업데이트합니다.
                              });
                            }
                            // Future<int> _selectedHourFuture = Future.value(1);
                            return AlertDialog(
                              title: Text('예약하기'),
                              content: StatefulBuilder(
                                builder: (context, setState) {
                                  int _selectedHour = 1;

                                  void _updateSelectedHour(int? newValue) {
                                    setState(() {
                                      _selectedHour = newValue!;
                                    });
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('${widget.time}부터 몇시간 예약하시나요?'),
                                      DropdownButton<int>(
                                        value: _selectedHour,
                                        items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text('$value 시간'),
                                          );
                                        }).toList(),
                                        onChanged: _updateSelectedHour,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          }
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
          for (int i = 0; i < 1; i++)
            Container(
              margin: EdgeInsets.only(top: i == 0 ? 50 : 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          margin: EdgeInsets.all(5),
                          child: _chairStatus[i][0] == 0
                              ? reservecheck(i, 0)
                              : Container(),
                        ),
                        Text(
                          "예약 테이블1",  // 원하는 텍스트로 변경하세요.
                          style: TextStyle(
                            color: Colors.white,  // 원하는 텍스트 색깔로 변경하세요.
                            fontSize: 12,  // 원하는 텍스트 크기로 변경하세요.
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text(
                        "자유석",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          height: 60,
                          margin: EdgeInsets.all(5),
                          child: _chairStatus[i][1] == 0
                              ? reservecheck(i, 1)
                              : Container(),
                        ),
                        Text(
                          "예약 테이블2",  // 원하는 텍스트로 변경하세요.
                          style: TextStyle(
                            color: Colors.white,  // 원하는 텍스트 색깔로 변경하세요.
                            fontSize: 12,  // 원하는 텍스트 크기로 변경하세요.
                          ),
                        ),
                      ],
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
              color: Color(0xff0E207F),
              borderRadius: BorderRadius.circular(3.0),
              border : Border.all(
                color: Color(0xff0E207F),
                width: 1,
              ),
            ),
        // 기존의 Container 내용...
      ),
    );
  }
}