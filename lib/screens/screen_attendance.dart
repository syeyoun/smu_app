import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/tabs/tab_profile.dart';

class Attendance extends StatefulWidget {
  @override
  _AttendanceState createState() => _AttendanceState();
}

/*class _AttendanceState extends State<Attendance> {
  List<Map<String, dynamic>> attendanceData = [];

  Future<void> _fetchAttendanceData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore.collection('attendance').get();

      List<Map<String, dynamic>> data = [];

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        data.add(documentSnapshot.data() as Map<String, dynamic>);
        if ((documentSnapshot.data() as Map<String, dynamic>)!['timestamp'] != null) {
          Timestamp timestamp = (documentSnapshot.data() as Map<String, dynamic>)!['timestamp'];
          //Timestamp timestamp = (documentSnapshot.data() as Map<String, dynamic>)['timestamp'];
          DateTime dateTime = timestamp.toDate();
          // 필요한 정보를 Map에 추가
          Map<String, dynamic> entry = {
            'dateTime': dateTime,
            // 다른 필요한 정보들을 추가하시면 됩니다.
          };

          data.add(entry);
        }
      }
      print(data);
      setState(() {
        attendanceData = data;
      });
    } catch (e) {
      print('데이터 불러오기에 실패했습니다: $e');
    }
  }
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';}

  @override
  Widget build(BuildContext context) {
    _fetchAttendanceData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E207F),
        title: Text('전자 출입 명부'),
      ),
      body: attendanceData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: attendanceData.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> data = attendanceData[index];
//          String formattedDateTime = attendanceData[index]['date'];
  //        print(formattedDateTime);
          return ListTile(
            title: Text('학번: ${attendanceData[index]['studentid']}'),
            subtitle: Text('출입 시간: ${attendanceData[index]['dateTime']}'),
            // 다른 필요한 정보들을 추가하시면 됩니다.
          );
        },
      ),
    );
  }
}*/


class _AttendanceState extends State<Attendance>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('전자 출입 명부'),
          backgroundColor: Color(0xff0E207F),
        ),
        body:
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('attendance')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.hasData) {
              final attendanceData = snapshot.data?.docs;
              List<Widget> postWidgets = [];

              if (attendanceData != null && attendanceData.isNotEmpty) {
                for (var attendance in attendanceData) {
                  final attendanceData = attendance.data() as Map<String, dynamic>;
                  final studentId = attendance['studentid'];
                  final time = attendance['timestamp'] as Timestamp;
                  final formattedDate = '${time.toDate().year}-${_twoDigits(time.toDate().month)}-${_twoDigits(time.toDate().day)} ${_twoDigits(time.toDate().hour)}:${_twoDigits(time.toDate().minute)}';

                  postWidgets.add(
                    Card(
                      child: ListTile(
                        title: Text(studentId),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text('$formattedDate'), // 시간 표시
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  return ListView(
                    children: postWidgets,
                  );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ));
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }
}
/*class AttendanceList extends StatelessWidget {
  final List<Map<String, dynamic>> attendanceData;

  AttendanceList(this.attendanceData);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: attendanceData.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = attendanceData[index];
        return ListTile(
          title: Text('학번: ${data['studentId']}'),
          subtitle: Text('이름: ${data['name']}, 출입 시간: ${data['entryTime']}'),
        );
      },
    );
  }
}*/