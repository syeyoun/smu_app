import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:test_1/tabs/tab_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_item_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


//var hash = '';
class ScannerScreen_2 extends StatefulWidget {
  const ScannerScreen_2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState2();
//_ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState2 extends State<ScannerScreen_2> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');


  @override
  void initState() {
    super.initState();
    // Start scanning when the screen is loaded
    Provider.of<QRScannerProvider>(context, listen: false).startScanning();
  }
  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery
        .of(context)
        .size
        .width < 400 ||
        MediaQuery
            .of(context)
            .size
            .height < 400)
        ? 150.0
        : 300.0;
    return Scaffold(
      appBar: AppBar(
          title: Text('카드키 QR인식'),
          centerTitle: true,
          backgroundColor: Color(0xff0E207F)),
      body: Consumer<QRScannerProvider>(
        builder: (context, scannerProvider, _) {
          if (!scannerProvider.isScanning) {
            return Center(
              child: Text('인식 실패...다시 시도해주세요.'),
            );
          }
          return QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea,

            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          );
        },
      ),
    );
  }

  /*void updateCardWithUsername(){
    // users 컬렉션의 모든 문서를 가져옵니다.
    QuerySnapshot userSnapshot =  FirebaseFirestore.instance.collection('users').get() as QuerySnapshot<Object?>;
    // 모든 username 값을 리스트에 저장합니다.
    List<String> usernames = userSnapshot.docs.map((doc) => doc.get('username') as String).toList();
    // usernames 리스트의 첫 번째 값을 가져옵니다.
    String firstUsername = usernames[0];
    // items1 컬렉션의 특정 문서의 card 필드를 username의 값으로 업데이트합니다.
     FirebaseFirestore.instance.collection('items1').doc('AN4TLA8ts0AGLAlivfoM').update({
      'card': firstUsername,
    });
  }*/

  // Future<void> updateCardWithUsername() async {
  //   // users 컬렉션의 모든 문서를 가져옵니다.
  //   QuerySnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').get();
  //   // 모든 username 값을 리스트에 저장합니다.
  //   List<String> usernames = userSnapshot.docs.map((doc) => doc.get('username') as String).toList();
  //   // usernames 리스트의 첫 번째 값을 가져옵니다.
  //   String firstUsername = usernames[0];
  //   // items1 컬렉션의 특정 문서의 card 필드를 username의 값으로 업데이트합니다.
  //   await FirebaseFirestore.instance.collection('items1').doc('AN4TLA8ts0AGLAlivfoM').update({
  //     'card': firstUsername,
  //   });
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

  Future<void> _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    //builder: (BuildContext context) {
    controller.scannedDataStream.listen((Barcode scanData) async {
      print(scanData.code);

      if (scanData.code != null) {
        Provider.of<QRScannerProvider>(context, listen: false)
            .updateScannedData(scanData.code!);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('card_data', scanData.code!);

        cardVal = prefs.getString('card_data')!;
        // print(cardVal);

        if (cardVal == 'https://me-qr.com/EEtHTSEE') {
          updateCardWithUsername();
        }
        else {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('올바르지 않은 QR입니다. 다시 시도해 주세요.',
                  style: TextStyle(fontSize: 20))),);
        }
        this.controller?.dispose();
        //Navigator.of(context).pop();
        Navigator.pop(context);
      }
    });
    // };
  }

  void _onPermissionSet(
      BuildContext context, QRViewController ctrl, bool p) async {
    //권한 확인
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('카메라 사용 권한을 허용해주세요.')),
      );
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}