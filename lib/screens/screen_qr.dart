//수정본
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:test_1/models/model_hash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/model_item_provider.dart';

//var hash = '';
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
//_ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
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
          title: Text('QR 출석하기'),
          centerTitle: true,
          backgroundColor: Color(0xff0E207F)),
      body: Consumer<QRScannerProvider>(
        builder: (context, scannerProvider, _) {
          if (!scannerProvider.isScanning) {
            return Center(
              child: Text('출석 실패...다시 시도해주세요.'),
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

  Future<void> _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) async {
      print(scanData.code);
      if (scanData.code != null) {
        Provider.of<QRScannerProvider>(context, listen: false)
            .updateScannedData(scanData.code!);
        //isQr = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('scanned_data', scanData.code!);//여기서 Scandata.codde는 널값 아니라 함
        print(prefs.getString('scanned_data'));
        this.controller?.dispose();
        Navigator.pop(context);
      }
    });
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