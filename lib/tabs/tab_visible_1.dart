// import 'dart:developer';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:test_1/models/model_item_provider.dart';
// import 'package:test_1/models/model_time.dart';
// import 'package:test_1/models/model_tabstate.dart';
//
//
// class MyWidget extends StatefulWidget {
//   @override
//   _MyWidgetState createState() => _MyWidgetState();
// }
//
// class _MyWidgetState extends State<MyWidget> {
//   bool isClicked = false; // 초기 상태는 false
//
//   bool _isRemainingTimeValid(String? remainingTimeString) {
//     if (remainingTimeString == null) return false;
//
//     List<String> timeComponents = remainingTimeString.split(":");
//
//     if (timeComponents.length != 2) return false;
//
//     int hours = int.tryParse(timeComponents[0]) ?? -1;
//     int minutes = int.tryParse(timeComponents[1]) ?? -1;
//
//     return hours >= 0 && hours < 24 && minutes >=0 && minutes <60;
//   }
//
//   int _getRemainingMinutes(String? remainingTimeString) {
//     if (!_isRemainingTimeValid(remainingTimeString)) return -1;
//
//     List<String> timeComponents = remainingTimeString!.split(":");
//     int hours = int.parse(timeComponents[0]);
//     int minutes = int.parse(timeComponents[1]);
//
//     return hours * 60 + minutes;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final itemProvider = Provider.of<ItemProvider>(context);
//     final logoutTimerProvider = Provider.of<LogoutTimerProvider>(context); // listen 속성을 제거하였습니다.
//     final tabState = Provider.of<TabState>(context);
//     return FutureBuilder(
//         future: itemProvider.fetchItems(),
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           return Stack(
//             children: [
//               InkWell(
//                 onTap: tabState.isClicked ? null : () async {
//                   tabState.toggleClick();
//               // InkWell(
//               //   onTap: isClicked ? null : () async {
//               //     setState(() {
//               //       isClicked = true;
//               //     });
//                   // 나머지 로직...
//                 },
//                 // return Stack()
//                 // child: Container(
//                 //   padding: EdgeInsets.all(10),
//                   child: Stack(
//                     children:[
//                       Positioned(
//                       top: 100, // replace with actual values
//                       left: 100, // replace with actual values
//                       child:
//                       Text('출석 체크 화면', style:
//                       TextStyle(fontSize:
//                       isClicked ?35 :35,color:
//                       Color((0xff0E207F))),
//                       )
//                       ),
//                       if (isClicked) ...[
//                       Positioned(
//                         top: 200, // replace with actual values
//                         left: 100, // replace with actual values
//                         child:
//                         Text("사용중!", style:
//                         TextStyle(fontSize:
//                         isClicked ?35 :35,color:
//                         Color((0xff0E207F))),
//                         )
//                         ),
//                         Positioned(
//                         top: 300, // replace with actual values
//                         left: 100, // replace with actual values
//                         child:
//                         Text('남은 시간! ${logoutTimerProvider.getRemainingTime()}',style:TextStyle(fontSize:35,color:Color(0xff0E207F)))
//                         ), // 로그아웃까지 남은 시간 표시
//                         Positioned(
//                             bottom: 100, // replace with actual values
//                             left: 100, // replace with actual values
//                             child:
//                             Container (
//                             width :(300),// desired width
//                             height :(90),// desired height
//                             child:
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Color(0xff0E207F),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(30.0),
//                                 ),
//                               ),
//                               onPressed: logoutTimerProvider.isCountdownStarted&& logoutTimerProvider.getRemainingTime() != null &&
//                                   _isRemainingTimeValid(logoutTimerProvider.getRemainingTime()) &&
//                                   _getRemainingMinutes(logoutTimerProvider.getRemainingTime()) <= 5
//                                   ? () {
//                                 setState(() {
//                                   logoutTimerProvider.addTime(Duration(seconds: 3));
//                                 });
//                               }
//                               : null,
//                           child:Text('연장?',style:
//                           TextStyle(fontSize:35,color:Colors.white),
//                           ),
//                         )
//                         )
//                         ),
//                       ] else ...[
//                         Positioned(
//                         bottom: 100, // replace with actual values
//                         left: 100, // replace with actual values
//                         child:
//                         Container (
//                         width :(300),// desired width
//                         height :(90),// desired height
//                         child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xff0E207F),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(30.0),
//                               ),
//                             ),
//                             // onPressed: () async {
//                             //   await itemProvider.incrementAllPrices();
//                             //   setState(() { isClicked = !isClicked; });
//                             //   logoutTimerProvider.onLogoutComplete = () async{
//                             //   logoutTimerProvider.logoutAndRedirect(context);
//                             //     // ScaffoldMessenger.of(context)
//                             //     //   ..hideCurrentSnackBar()
//                             //     //   ..showSnackBar(SnackBar(content: Text('logout!')));
//                             //     // Navigator.of(context).pushReplacementNamed('/login');
//                             //     await itemProvider.decrementAllPrices();
//                             //   };
//                             //   await logoutTimerProvider.startLogoutCountdown();
//                             // },
//                             onPressed: () async {
//                               await itemProvider.incrementAllPrices();
//                               tabState.toggleClick(); // isClicked 상태 토글
//                               logoutTimerProvider.onLogoutComplete = () async {
//                                 // logoutTimerProvider.logoutAndRedirect(context);
//                                 await itemProvider.decrementAllPrices();
//                               };
//                               await logoutTimerProvider.startLogoutCountdown();
//                             },
//                             child:Text('출석?',style:
//                             TextStyle(fontSize:35,color:Colors.white),
//                             )
//                         )
//                         )
//                         ),
//                       ],
//                     ],
//                   ),
//                 // ),
//               ),
//             ],
//           );
//         }
//     );
//   }
// }