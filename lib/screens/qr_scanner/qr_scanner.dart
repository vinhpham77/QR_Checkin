import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_checkin/features/ticket/data/ticket_api_client.dart';
import 'package:qr_checkin/utils/qr_border_painter.dart';

import '../../config/http_client.dart';
import '../../features/event/bloc/event_bloc.dart';
import '../../features/qr_event.dart';
import '../../features/ticket/bloc/ticket_bloc.dart';
import '../../features/ticket/data/ticket_repository.dart';
import '../../features/ticket/data/ticket_type_api_client.dart';
import '../../features/ticket/data/ticket_type_repository.dart';

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
              if (state is EventFetchOneSuccess) {
                if (qrEvent != null) {
                  if (qrEvent!.isTicketSeller) {
                    ticketBloc.add(TicketCheckIn(
                      code: qrEvent!.code,
                      eventId: qrEvent!.eventId,
                    ));
                  } else if (qrEvent!.isCheckin) {

                  }
                }
              }
            },
            child: BlocListener<TicketBloc, TicketState>(
              listener: (context, state) {
                if (state is TicketCheckInSuccess) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check in thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state is TicketCheckInFailure) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
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
                              content: Column(
                                children: [
                                  Image.memory(img!),
                                  const SizedBox(height: 8),
                                  const CircularProgressIndicator(),
                                  const Text('Đang xử lý...')
                                ],
                              ),
                            ),
                          );
                          if (barcode.rawValue != null) {
                            try {
                              qrEvent =
                                  QrEvent.fromQrCode(barcode.rawValue ?? '');
                              context
                                  .read<EventBloc>()
                                  .add(EventFetchOne(id: qrEvent!.eventId));
                            } catch (e) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Mã QR không hợp lệ'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } else {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mã QR không hợp lệ'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }

                        cameraController.stop();
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
