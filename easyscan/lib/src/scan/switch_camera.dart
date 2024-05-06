import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override

  /// Builds a button that allows the user to switch between the front and back cameras of the device.
  ///
  /// The button is only visible if there are at least two available cameras on the device.
  /// When the button is pressed, it calls [MobileScannerController.switchCamera] to switch the active camera.
  ///
  /// The button displays an icon representing the current camera direction (front or back).
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(Icons.camera_front);
          case CameraFacing.back:
            icon = const Icon(Icons.camera_rear);
        }

        return IconButton(
          iconSize: 32.0,
          icon: icon,
          onPressed: () async {
            await controller.switchCamera();
          },
        );
      },
    );
  }
}
