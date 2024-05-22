import 'dart:convert';
import 'dart:io';
import 'package:easyscan/src/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vibration/vibration.dart';

class ScanView extends StatefulWidget {
  final String accessToken;

  const ScanView({
    super.key,
    required this.accessToken,
  });
  @override
  State<ScanView> createState() => _ScanViewState();

  static const routeName = '/scan_view';
}

class _ScanViewState extends State<ScanView> {
  final formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanStarted = false;
  bool processingCode = false;
  String? scannedData;
  String? productName;
  String? productNumber;
  String? quantity;
  String? weight;
  final Map<String, dynamic> _scanCache = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _saveForm() {
    final newArticle = {
      'Description': productName,
      'ArticleNumber': productNumber,
      'Quantity': quantity,
      'Weight': weight,
    };
    Navigator.pop(context, newArticle);
  }

  Future fetchArticle(String barcodeNumber) async {
    String? accessToken = await authService.getStoredToken('accessToken');
    String? refreshToken = await authService.getStoredToken('refreshToken');

    if (accessToken == null || !(await authService.isAccessTokenValid())) {
      if (refreshToken != null) {
        accessToken = await authService.refreshAccessToken(refreshToken);
      } else {
        throw Exception('No valid tokens available');
      }
    }

    const String apiUrl = 'https://api.fortnox.se/3/articles';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> articles = data['Articles'];

        final article = articles.firstWhere(
          (article) => article['EAN'] == barcodeNumber,
          orElse: () => null,
        );

        if (article != null) {
          productName = article['Description'];
          productNumber = article['ArticleNumber'];
          quantity = 'quantity';
          weight = 'Weight';
          _saveForm();
        }
      } else {
        throw Exception('Failed to load article');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skanna produkt'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  Container(
                    width: width,
                    height: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: _buildQrView(context),
                  ),
                  Visibility(
                    visible: processingCode,
                    child: Stack(
                      children: <Widget>[
                        Opacity(
                          opacity: 0.7,
                          child: Container(
                            color: Colors.black,
                          ),
                        ),
                        const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40, left: 16, right: 16),
            child: Center(
              child: Text(
                scannedData ?? 'No display value.',
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
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
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      scanStarted = true;
    });

    controller.scannedDataStream.listen((scanData) {
      Vibration.hasVibrator().then((hasVibrator) {
        if (hasVibrator! && scanData.code!.isNotEmpty) {
          setState(() {
            processingCode = true;
          });
          Vibration.vibrate(duration: 500);
        }
      });
      if (_isScanDataValid(scanData)) {
        _logScanResult(scanData);
        _handleScanData(scanData);
        setState(() {
          processingCode = false;
          scanStarted = false;
          controller.stopCamera();
        });
      } else {
        _handleInvalidScanData(scanData);
        setState(() {
          processingCode = false;
          scanStarted = false;
        });
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
    setState(() {
      scannedData = scanData.code;
    });
  }

  void _handleInvalidScanData(dynamic scanData) {
    setState(() {
      processingCode = false;
      scannedData = scanData.code;
      controller?.resumeCamera();
    });
  }

  void _handleScanData(dynamic scanData) {
    String scanKey = scanData.code;

    if (_scanCache.containsKey(scanKey)) {
      if (kDebugMode) {
        print('Using cached result for: $scanKey');
      }
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

  void _handleCase1(dynamic scanData) {
    // Case 1 logic
  }

  void _handleCase2(dynamic scanData) {
    // Case 2 logic
  }

  void _handleDefaultCase(dynamic scanData) {
    fetchArticle(scanData.code.toString());
  }
}
