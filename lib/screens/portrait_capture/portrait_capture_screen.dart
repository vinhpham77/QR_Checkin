import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/features/qr_event.dart';

class PortraitCaptureScreen extends StatefulWidget {
  final Uint8List? qrImage;
  final QrEvent? qrEvent;

  const PortraitCaptureScreen(
      {super.key, required this.qrImage, required this.qrEvent});

  @override
  State<PortraitCaptureScreen> createState() => _PortraitCaptureScreenState();
}

class _PortraitCaptureScreenState extends State<PortraitCaptureScreen> {
  late final theme = Theme.of(context);
  CameraController? cameraController;
  late List<CameraDescription> cameras;

  @override
  void initState() {
    getCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Chụp chân dung'),
          actions: [
            IconButton(
              color: Colors.transparent,
              icon: Icon(
                cameraController != null &&
                        cameraController?.value.flashMode == FlashMode.torch
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: cameraController != null &&
                        cameraController?.value.flashMode == FlashMode.torch
                    ? Colors.yellow
                    : Colors.grey,
              ),
              iconSize: 24.0,
              onPressed: toggleFlashlight,
            ),
            IconButton(
              color: Colors.transparent,
              icon: const Icon(Icons.switch_camera, color: Colors.grey),
              iconSize: 24.0,
              onPressed: () {
                setState(() {
                  cameraController?.description.lensDirection ==
                          CameraLensDirection.back
                      ? cameraController = CameraController(
                          cameras.firstWhere((camera) =>
                              camera.lensDirection ==
                              CameraLensDirection.front),
                          ResolutionPreset.veryHigh,
                          enableAudio: false,
                        )
                      : cameraController = CameraController(
                          cameras.firstWhere((camera) =>
                              camera.lensDirection == CameraLensDirection.back),
                          ResolutionPreset.veryHigh,
                          enableAudio: false,
                        );
                  cameraController?.initialize().then((_) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {});
                  }).catchError((Object e) {
                    if (e is CameraException) {
                      switch (e.code) {
                        case 'CameraAccessDenied':
                          // Handle access errors here.
                          break;
                        default:
                          // Handle other errors here.
                          break;
                      }
                    }
                  });
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // WAIT 1S BEFORE SHOWING CAMERA PREVIEW
            if (cameraController != null &&
                cameraController!.value.isInitialized)
              CameraPreview(cameraController!)
            else
              const Expanded(child: Center(child: CircularProgressIndicator())),
            if (cameraController != null &&
                cameraController!.value.isInitialized)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: IconButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      iconColor: MaterialStateProperty.all(AppColors.red),
                    ),
                    onPressed: () async {
                      final XFile? file = await cameraController?.takePicture();
                      if (file != null) {
                        Uint8List? image = await file.readAsBytes();
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Chân dung'),
                            content: SizedBox(
                              width: 200,
                              child: Image.memory(image),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AppColors.pink, width: 1),
                        ),
                        child: const Icon(Icons.camera_alt, size: 36)),
                  ),
                ),
              ),
          ],
        ));
  }

  Future<void> toggleFlashlight() async {
    if (cameraController != null &&
        cameraController!.value.isInitialized &&
        cameraController!.value.description.lensDirection ==
            CameraLensDirection.back) {
      if (cameraController?.value.flashMode == FlashMode.off) {
        await cameraController?.setFlashMode(FlashMode.torch);
      } else {
        await cameraController?.setFlashMode(FlashMode.off);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Không thể bật đèn flash ở camera trước'),
      ));
    }
  }

  Future<void> getCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.veryHigh,
      enableAudio: false,
    )..initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      });
  }
}
