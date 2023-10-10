import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:test_1/models/model_qrcode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  QRViewController? _controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void initState() {
    super.initState();
    // Start scanning when the screen is loaded
    Provider.of<QRScannerProvider>(context, listen: false).startScanning();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  late BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Consumer<QRScannerProvider>(
        builder: (context, scannerProvider, _) {
          if (!scannerProvider.isScanning) {
            return Center(
              child: Text('Scanning is not enabled.'),
            );
          }
          return QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          );
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((Barcode scanData) async { // Added async keyword here.
      // Handle the scanned QR code data here
      print(scanData.code);

      if (scanData.code != null) {
        Provider.of<QRScannerProvider>(_context, listen: false).updateScannedData(scanData.code!);

        // Save the scanned data to local storage.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('scanned_data', scanData.code!);

        // Stop scanning after a successful scan and turn off the camera.
        _controller?.dispose();

        // Navigate back to the home screen.
        Navigator.pop(context);
      }
    });
  }
}