import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});
  @override
  State<ScanView> createState() => _ScanViewState();

  static const routeName = '/scan_view';
}

class _ScanViewState extends State<ScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanStarted = false;

  // Cache for scan results
  final Map<String, dynamic> _scanCache = {};

  /// Resumes the camera when the widget is initialized.
  ///
  /// This method is called when the widget is first created. It resumes the camera
  /// that was previously paused, allowing the QR code scanner to start capturing
  /// images again.
  @override
  void initState() {
    super.initState();
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    /// Pauses the camera and disposes of the QRViewController.
    /// This is called when the widget is being disposed of.
    controller?.pauseCamera();
    controller?.dispose();
    super.dispose();
  }

  @override

  /// Pauses the camera when the widget is reassembled.
  ///
  /// This method is called when the widget is reassembled, such as when the
  /// widget's state changes or the widget is moved in the widget tree. It
  /// checks if the [controller] is not null, and if so, pauses the camera.
  /// This ensures that the camera is not running when the widget is not
  /// visible, which can help conserve device resources.
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

  /// Builds a QR code scanner view with a customized overlay.
  /// The [QRView] widget is used to create the QR code scanner view. The overlay is
  /// customized using the [QrScannerOverlayShape] widget, which sets the border
  /// color, radius, length, width, and the cutout size.
  ///
  /// The [_buildQrView] method is responsible for creating the QR code scanner
  /// view and its overlay.
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

    /// The code snippet `controller.scannedDataStream.listen((scanData) { ... });` sets up a listener
    /// on the `scannedDataStream` stream provided by the `QRViewController` instance. This listener
    /// listens for incoming scan data from the QR code scanner.
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

  bool _isScanDataValid(dynamic scanData) {
    if (scanData == null || scanData.code == null) {
      return false;
    }

    if (scanData.code.length < 5) {
      return false;
    }

    return true;
  }

  void _logScanResult(dynamic scanData) {
    print('Scanned: ${scanData.code}');
  }

  void _handleInvalidScanData(dynamic scanData) {
    print('Invalid scan data received: ${scanData.code}');
  }

  /// Handles the processing of scan data received from a scanning operation.
  ///
  /// This method first checks if the scan data has already been cached. If so, it uses the cached result.
  /// Otherwise, it stores the scan data in the cache for future use.
  ///
  /// The method then processes the scan data based on the value of the `code` property. If the code matches
  /// 'case1', it calls the `_handleCase1` method. If the code matches 'case2', it calls the `_handleCase2`
  /// method. For any other code, it calls the `_handleDefaultCase` method.
  ///
  /// The `scanData` parameter is of type `dynamic`, which means it can be any type of data. The specific
  /// structure and properties of the `scanData` object are not documented here, as they are likely
  /// implementation details of the scanning functionality.
  void _handleScanData(dynamic scanData) {
    String scanKey = scanData.code;

    if (_scanCache.containsKey(scanKey)) {
      print('Using cached result for: $scanKey');
      scanData = _scanCache[scanKey];
    } else {
      _scanCache[scanKey] = scanData; //[Key, Value]
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

  void _handleCase1(dynamic scanData) {
    // Case 1 logic
  }

  void _handleCase2(dynamic scanData) {
    // Case 2 logic
  }

  void _handleDefaultCase(dynamic scanData) {
    // Default case logic
  }
}
