import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});
  @override
  _ScanViewState createState() => _ScanViewState();

  static const routeName = '/scan_view';
}

class _ScanViewState extends State<ScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanStarted = false;

  // Cache for scan results
  Map<String, dynamic> _scanCache = {};

  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller?.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skanna produkt'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 57.0),
            child: Container(
              width: width / 1.2,
              height: width / 1.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: _buildQrView(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.greenAccent,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.77,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      scanStarted = true;
    });

    controller.scannedDataStream.listen((scanData) {
      // Validate input
      if (_isScanDataValid(scanData)) {
        _logScanResult(scanData);
        _handleScanData(scanData);
      } else {
        _handleInvalidScanData(scanData);
      }
    });
  }

  bool _isScanDataValid(dynamic data) {
    if (data == null || data.code == null) {
      return false;
    }

    if (data.code.length < 5) {
      return false;
    }

    return true;
  }

  void _logScanResult(dynamic data) {
    print('Scanned: ${data.code}');
  }

  void _handleInvalidScanData(dynamic data) {
    print('Invalid scan data received: ${data.code}');
  }

  void _handleScanData(dynamic scanData) {
    String scanKey = scanData.code;

    if (_scanCache.containsKey(scanKey)) {
      print('Using cached result for: $scanKey');
      scanData = _scanCache[scanKey];
    } else {
      _scanCache[scanKey] = scanData;
    }

    switch (scanData.code) {
      case 'case1':
        _handleCase1(scanData);
        break;

      case 'case2':
        _handleCase2(scanData);
        break;

      default:
        _handleDefaultCase(scanData);
        break;
    }
  }

  void _handleCase1(dynamic data) {
    // Case 1 logic
  }

  void _handleCase2(dynamic data) {
    // Case 2 logic
  }

  void _handleDefaultCase(dynamic data) {
    // Default case logic
  }
}
