import 'package:easyscan/src/scan/flashlight.dart';
import 'package:easyscan/src/scan/scanner_barcode_label.dart';
import 'package:easyscan/src/scan/scanner_error_widget.dart';
import 'package:easyscan/src/scan/switch_camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  static const routeName = '/scan';

  @override
  State<ScanView> createState() => _BarcodeScannerWithOverlayState();
}

class _BarcodeScannerWithOverlayState extends State<ScanView> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void initState() {
    super.initState();
    controller.start();
  }

  @override

  /// Builds the scan view UI, including a semi-transparent background with a cutout area for the scan window, and a border around the scan window.
  ///
  /// The `build` method is responsible for constructing the visual elements of the scan view. It creates a `Scaffold` with an `AppBar` and a `Stack` of widgets, including:
  /// - A `MobileScanner` widget that displays the camera feed and handles barcode scanning.
  /// - A `CustomPaint` widget that renders the scan window overlay using the `ScannerOverlay` custom painter.
  /// - Buttons for toggling the flashlight and switching the camera.
  ///
  /// The method uses the `scanWindow` variable to determine the size and position of the scan window, and the `controller` variable to interact with the `MobileScanner` widget.
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: MediaQuery.sizeOf(context).width * 0.75,
      height: MediaQuery.sizeOf(context).width * 0.75,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skanna produkt'),
      ),
      body: Stack(
        children: [
          Center(
            child: MobileScanner(
              fit: BoxFit.cover,
              controller: controller,
              scanWindow: scanWindow,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              overlayBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                  ),
                );
              },
            ),
          ),

          /// Renders a custom paint widget that displays a scanner overlay on the screen.
          ///
          /// The `ValueListenableBuilder` widget listens to the `controller` value and only renders the `CustomPaint` widget when the camera is initialized, running, and has no errors.
          ///
          /// The `CustomPaint` widget uses the `ScannerOverlay` custom painter to draw a semi-transparent background with a cutout area for the scan window, and a border around the scan window.
          ///
          /// The `scanWindow` property is used to determine the size and position of the scan window within the custom paint widget.
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized ||
                  !value.isRunning ||
                  value.error != null) {
                return const SizedBox();
              }

              return CustomPaint(
                painter: ScannerOverlay(scanWindow: scanWindow),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  SwitchCameraButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 18.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override

  /// Paints the scan view on the canvas, including a semi-transparent background with a cutout area for the scan window, and a border around the scan window.
  ///
  /// The `paint` method is responsible for rendering the visual elements of the scan view on the canvas. It creates a background path that covers the entire canvas, and then subtracts a cutout path that corresponds to the scan window. This creates a semi-transparent background with a clear area for the scan window. It then draws a border around the scan window using a green accent color.
  ///
  /// The method takes the following parameters:
  /// - `canvas`: The canvas on which to draw the scan view.
  /// - `size`: The size of the canvas.
  ///
  /// The method uses the `scanWindow` and `borderRadius` properties to determine the size and shape of the scan window and its border.
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
