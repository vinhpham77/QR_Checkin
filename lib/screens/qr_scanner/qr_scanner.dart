import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_checkin/utils/qr_border_painter.dart';

class QRScannerScreen extends StatefulWidget with WidgetsBindingObserver {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late final theme = Theme.of(context);
  CameraController? frontCameraController;
  late double screenWidth = MediaQuery.of(context).size.width;
  MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    returnImage: true,
    facing: CameraFacing.back,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Quét mã'),
        actions: [
          IconButton(
            color: Colors.transparent,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 24.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            // fit: BoxFit.contain,
            controller: cameraController,
            onDetect: (capture) async {
              final List<Barcode> barcodes = capture.barcodes;
              final Uint8List? qrImage = capture.image;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
                if (qrImage != null) {
                  // Show the dialog with both images
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Column(
                        children: [
                          const Text('QR Image'),
                          Image.memory(qrImage),
                        ],
                      ),
                    ),
                  );
                }

                cameraController.stop();
                break;
              }
            },
          ),
          Positioned(
            top: 28,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Row(
                  children: [
                    Text(
                      'Đang quét mã...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 140,
              child: SizedBox(
                width: screenWidth * 0.65,
                height: screenWidth * 0.65,
                child: CustomPaint(
                  painter: QRBorderPainter(),
                ),
              )),
        ],
      ),
    );
  }

  Future<void> initCameraController() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    frontCameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    await frontCameraController?.initialize();
  }
}
