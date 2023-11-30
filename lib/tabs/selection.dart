import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_1/tabs/seat1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class design {
  static InputDecoration dec(String b) {
    InputDecoration c = InputDecoration(
        contentPadding: EdgeInsets.all(8),
        hoverColor: Colors.black12,
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
        labelStyle: TextStyle(color: Colors.black));
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
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 4),
            blurRadius: 4)
      ],
      color: Color.fromRGBO(255, 205, 5, 1),
    );
  }

  static TextStyle texst(double a, FontWeight b){
    return TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              color: Color.fromRGBO(255, 205, 5, 1),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('좌석',
                            style: design.texst(24, FontWeight.w700)),
                        Container(
                          height: 20,
                        ),
                        Text('? 자리 남아있어요',
                            style: design.texst((18), FontWeight.w400))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 7,
            ),
            Text('Choose seats',
                style: design.texst(18, FontWeight.w700)),
            Container(
              height: 7,
            ),
            (a == 1)
                ? Container(
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
                child: Busseats2())
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