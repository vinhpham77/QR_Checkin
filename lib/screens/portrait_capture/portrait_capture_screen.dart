import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/config/router.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/features/qr_event.dart';

import '../../features/event/bloc/event_bloc.dart';
import '../../widgets/location_provider.dart';

class PortraitCaptureScreen extends StatefulWidget {
  final Uint8List qrImage;
  final QrEvent qrEvent;

  const PortraitCaptureScreen(
      {super.key, required this.qrImage, required this.qrEvent});

  @override
  State<PortraitCaptureScreen> createState() => _PortraitCaptureScreenState();
}

class _PortraitCaptureScreenState extends State<PortraitCaptureScreen> {
  late final theme = Theme.of(context);
  CameraController? cameraController;
  late List<CameraDescription> cameras;
  LatLng? currentLocation;

  @override
  void initState() {
    getCamera();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var newCurrentLocation = LocationProvider.of(context)?.currentLocation;
    currentLocation ??= newCurrentLocation;
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
        body: BlocListener<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventCheckSuccess) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.isCheckIn
                    ? 'Đã check-in thành công'
                    : 'Đã check-out thành công'),
                backgroundColor: AppColors.green,
              ));
              context.pushReplacement(RouteName.eventDetail,
                  extra: widget.qrEvent.eventId);
            } else if (state is EventCheckFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ));
              context.pop();
            }
          },
          child: BlocBuilder<EventBloc, EventState>(
              bloc: context.read<EventBloc>(),
              builder: (context, state) {
                if (state is EventCheckLoading) {
                  return Stack(
                    children: [
                      _buildBody(
                          cameraController: cameraController, widget: widget),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                }

                return _buildBody(
                    cameraController: cameraController, widget: widget);
              }),
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

  Widget _buildBody(
      {CameraController? cameraController,
      required PortraitCaptureScreen widget}) {
    return Column(
      children: [
        if (cameraController != null && cameraController.value.isInitialized)
          CameraPreview(cameraController)
        else
          const Expanded(child: Center(child: CircularProgressIndicator())),
        if (cameraController != null && cameraController.value.isInitialized)
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
                  final XFile file = await cameraController.takePicture();
                  var imageFile = File(file.path);
                  var image = imageFile.readAsBytesSync();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Chân dung'),
                      content: SizedBox(
                        width: 200,
                        child: Image.memory(image),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<EventBloc>().add(EventCheck(
                                qrEvent: widget.qrEvent,
                                qrImg: widget.qrImage,
                                isCaptureRequired: true,
                                portraitImage: imageFile,
                                location: currentLocation!));
                            Navigator.of(context).pop();
                            cameraController.stopImageStream();
                          },
                          child: const Text('Xác nhận'),
                        ),
                      ],
                    ),
                  );
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
    );
  }
}
