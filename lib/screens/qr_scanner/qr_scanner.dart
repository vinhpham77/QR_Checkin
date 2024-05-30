import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_checkin/config/router.dart';
import 'package:qr_checkin/features/ticket/data/ticket_api_client.dart';
import 'package:qr_checkin/utils/qr_border_painter.dart';

import '../../config/http_client.dart';
import '../../features/event/bloc/event_bloc.dart';
import '../../features/qr_event.dart';
import '../../features/ticket/bloc/ticket_bloc.dart';
import '../../features/ticket/data/ticket_repository.dart';
import '../../features/ticket/data/ticket_type_api_client.dart';
import '../../features/ticket/data/ticket_type_repository.dart';
import '../../widgets/location_provider.dart';

class QRScannerScreen extends StatefulWidget with WidgetsBindingObserver {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late final theme = Theme.of(context);
  CameraController? frontCameraController;
  QrEvent? qrEvent;
  Uint8List? img;
  LatLng? currentLocation;
  late double screenWidth = MediaQuery.of(context).size.width;
  MobileScannerController cameraController = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    returnImage: true,
    facing: CameraFacing.back,
  );
  final ticketBloc = TicketBloc(
      ticketRepository: TicketRepository(TicketApiClient(dio)),
      ticketTypeRepository: TicketTypeRepository(TicketTypeApiClient(dio)));

  @override
  void initState() {
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
        body: BlocProvider<TicketBloc>(
          create: (context) => ticketBloc,
          child: BlocListener<EventBloc, EventState>(
            listener: (context, state) {
              if (state is EventRegistrationCheckSuccess) {
                if (qrEvent != null) {
                  if (qrEvent!.isTicketSeller) {
                    ticketBloc.add(TicketCheckIn(
                      code: qrEvent!.code,
                      eventId: qrEvent!.eventId,
                    ));
                  } else if (state.eventDto.regisRequired) {
                    if (state.eventDto.isRegistered) {
                      if (state.eventDto.captureRequired) {
                        context.push(RouteName.eventCapture, extra: {
                          'qrEvent': qrEvent,
                          'qrImage': img,
                        });
                      } else {}
                    } else {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bạn chưa đăng ký sự kiện này'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      Navigator.of(context).pop();
                    }
                  } else if (state.eventDto.captureRequired) {
                    context.push(RouteName.eventCapture, extra: {
                      'qrEvent': qrEvent,
                      'qrImage': img,
                    });
                  } else {
                    context.read<EventBloc>().add(EventCheck(
                        qrEvent: qrEvent!,
                        qrImg: img!,
                        isCaptureRequired: false,
                        portraitImage: null,
                        location: currentLocation!));
                  }
                }
              } else if (state is EventCheckSuccess) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.isCheckIn
                        ? 'Check in thành công'
                        : 'Check out thành công'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.of(context).pop();
              } else if (state is EventCheckFailure) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: BlocListener<TicketBloc, TicketState>(
              listener: (context, state) {
                if (state is TicketCheckInSuccess) {
                  router.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check in thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                  router.pop();
                } else if (state is TicketCheckInFailure) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  MobileScanner(
                    controller: cameraController,
                    onDetect: (capture) async {
                      final List<Barcode> barcodes = capture.barcodes;
                      img = capture.image;
                      for (final barcode in barcodes) {
                        if (img != null) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Mã QR'),
                              content: SizedBox(
                                width: 360,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.memory(img!),
                                    const SizedBox(height: 16),
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 8),
                                    const Text('Đang xử lý...')
                                  ],
                                ),
                              ),
                            ),
                          );

                          cameraController.stop();

                          if (barcode.rawValue != null && qrEvent == null) {
                            try {
                              qrEvent =
                                  QrEvent.fromQrCode(barcode.rawValue ?? '');
                              context.read<EventBloc>().add(
                                  EventRegistrationCheck(
                                      eventId: qrEvent!.eventId));
                            } catch (e) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Lỗi',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18)),
                                              const SizedBox(height: 16),
                                              const Text(
                                                  'Mã QR không hợp lệ',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              const SizedBox(height: 16),
                                              FilledButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    cameraController.start();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      const Text('Thử lại'))
                                            ],
                                          ),
                                        ),
                                      ));
                            }
                          }
                        }

                        break;
                      }
                    },
                  ),
                  Positioned(
                    top: 28,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
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
            ),
          ),
        ));
  }
}
