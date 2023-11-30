// models/model_time.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_auth.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class HashProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String _hashValue = '';

  late final SharedPreferences prefs;
  String? get hashValue => _hashValue;

  Future<String?> getQRCodeDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hashValue = prefs.getString('scanned_data') ?? "";
    print(hashValue);
    return _hashValue;
  }

  var qrnum;

  Future<void> getQRNumFromFirebase() async {
    // 파이어베이스에서 문서 가져오기
    DocumentSnapshot docSnapshot = await firestore.collection('qrcodes').doc('5ia2MDxgNDL4hwGvg8Y3').get();

    // 문서의 데이터에서 qrnum 필드 가져오기
    var data = docSnapshot.data() as Map<String, dynamic>; // 캐스팅 추가
    qrnum = data['code'];

    // qrnum을 출력하거나 다른 작업 수행
    print(qrnum);
  }
}