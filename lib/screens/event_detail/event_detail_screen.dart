import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_checkin/features/ticket/data/ticket_api_client.dart';
import '../../config/http_client.dart';
import '../../config/router.dart';
import '../../config/theme.dart';
import '../../config/user_info.dart';
import '../../features/event/bloc/event_bloc.dart';
import '../../features/event/dtos/event_dto.dart';
import '../../features/qr_event.dart';
import '../../features/ticket/bloc/ticket_bloc.dart';
import '../../features/ticket/data/ticket_repository.dart';
import '../../features/ticket/data/ticket_type_api_client.dart';
import '../../features/ticket/data/ticket_type_repository.dart';
import '../../features/ticket/dtos/ticket_type_dto.dart';
import '../../utils/data_utils.dart';
import '../../widgets/single_child_scroll_view_with_column.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late GoogleMapController mapController;
  EventDto event = EventDto.empty();
  final ticketBloc = TicketBloc(TicketRepository(TicketApiClient(dio)), TicketTypeRepository(TicketTypeApiClient(dio)));
  List<TicketTypeDto> ticketTypes = [];

  @override
  void initState() {
    super.initState();
    context.read<EventBloc>().add(EventFetchOne(id: widget.eventId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TicketBloc>(
      create: (context) => ticketBloc..add(TicketEventInitial()),
      child: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventFetchOneFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          } else if (state is EventFetchOneSuccess) {
            if (state.event.isTicketSeller) {
              ticketBloc.add(TicketTypeFetch(widget.eventId));
            }
          } else if (state is EventRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công'),
                backgroundColor: AppColors.green,
              ),
            );
          } else if (state is EventRegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red,
              ),
            );
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            if (state is EventFetchOneSuccess) {
              event = state.event;
            } else if (state is EventFetchOneFailure) {
              return Center(child: Text(state.message));
            }

            return _buildEventDetail(event: event);
          },
        ),
      ),
    );
  }

  Widget _buildEventDetail({required EventDto event}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sự kiện'),
        actions: [
          if (UserInfo.username == event.createdBy)
            PopupMenuButton<String>(
              onSelected: (String value) {
                switch (value) {
                  case 'edit':
                    router.push(RouteName.eventUpdate, extra: event.id);
                    break;
                  case 'report':
                    // context.go(Routes.eventReport(eventId: event.id));
                    break;
                  case 'qr':
                    showQrCodeDialog();
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Chỉnh sửa'),
                ),
                const PopupMenuItem<String>(
                  value: 'report',
                  child: Text('Báo cáo'),
                ),
                const PopupMenuItem<String>(
                  value: 'qr',
                  child: Text('Xem mã QR'),
                ),
              ],
            ),
        ],
      ),
      bottomNavigationBar: event.isTicketSeller ? null : Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: AppColors.black,
          child: _buildBottomWidget(event: event)),
      body: SingleChildScrollViewWithColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 220,
              width: double.infinity,
              child: Image.network(
                event.backgroundUrl ?? '',
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.indigo.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeLast(event.startAt, event.endAt),
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.indigo.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        event.location,
                        style: const TextStyle(
                          fontSize: 17,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGray.withOpacity(0.4),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(bottom: 4, left: 8),
                        child: Text('Giới thiệu',
                            style: themeData.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ))),
                    const Divider(
                      color: AppColors.lightGray,
                      height: 0.5,
                      thickness: 0.5,
                      indent: 8,
                      endIndent: 8,
                    ),
                    html.Html(
                      data: event.description,
                      shrinkWrap: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (event.isTicketSeller && event.endAt.isAfter(DateTime.now()))
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lightGray.withOpacity(0.4),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 4, left: 8),
                          child: Text('Các loại vé',
                              style: themeData.textTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ))),
                      const Divider(
                        color: AppColors.lightGray,
                        height: 0.5,
                        thickness: 0.5,
                        indent: 8,
                        endIndent: 8,
                      ),
                      BlocListener<TicketBloc, TicketState>(
                        bloc: ticketBloc,
                        listener: (context, state) {
                          if (state is TicketPurchaseSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mua vé thành công'),
                                backgroundColor: AppColors.green,
                              ),
                            );
                          } else if (state is TicketPurchaseFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.red,
                              ),
                            );
                          }
                        },
                        child: BlocBuilder<TicketBloc, TicketState>(
                          builder: (context, state) {
                            if (state is TicketTypeFetchSuccess) {
                              ticketTypes = state.ticketTypes;
                            } else if (state is TicketTypeFetchFailure) {
                              return Center(
                                child: Text(state.message),
                              );
                            }

                            return Column(
                              children: ticketTypes
                                  .map(
                                    (ticketType) => ListTile(
                                  title: Text(ticketType.name),
                                  subtitle: Text(
                                    formatPrice(ticketType.price!),
                                    style: const TextStyle(
                                      color: AppColors.black,
                                    ),
                                  ),
                                  trailing: ElevatedButton(

                                    onPressed: ticketType.quantity! <= 0 ? null : () {
                                      ticketBloc.add(TicketPurchase(ticketTypeId: ticketType.id));
                                    },
                                    child: Text(ticketType.quantity! > 0 ? 'Mua vé' : 'Hết vé'),
                                  ),
                                ),
                              )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (event.isTicketSeller && event.endAt.isAfter(DateTime.now()))
              const SizedBox(
                height: 8,
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGray.withOpacity(0.4),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Wrap(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 4, left: 8),
                    child: Text(
                      'Vị trí sự kiện',
                      style: themeData.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.lightGray,
                    height: 1,
                    thickness: 0.5,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                      child: GoogleMap(
                        gestureRecognizers: <Factory<
                            OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        buildingsEnabled: true,
                        zoomControlsEnabled: false,
                        rotateGesturesEnabled: true,
                        compassEnabled: true,
                        tiltGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                        onTap: (LatLng latLng) {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: latLng,
                                zoom: 15,
                              ),
                            ),
                          );
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(event.latitude, event.longitude),
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId('event_location'),
                            position: LatLng(event.latitude, event.longitude),
                            infoWindow: InfoWindow(
                              title: event.name,
                              snippet: event.location,
                            ),
                          ),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGray.withOpacity(0.4),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 4, left: 8),
                    child: Text(
                      'Ban tổ chức',
                      style: themeData.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const Divider(
                    color: AppColors.lightGray,
                    height: 1,
                    thickness: 0.5,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '@${event.createdBy}',
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      event.createdBy,
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomWidget({required EventDto event}) {
    if (event.startAt.isAfter(DateTime.now())) {
      if (UserInfo.username != event.createdBy) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              event.slots == null
                  ? 'Sự kiện không giới hạn số lượng'
                  : 'Sự kiện chỉ còn ${event.slots} chỗ trống',
              style: const TextStyle(color: AppColors.white),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                ),
                onPressed: () {
                  context.read<EventBloc>().add(EventRegister(eventId: event.id));
                },
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(color: AppColors.white),
                )),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Xem danh sách đăng ký tham dự',
              style: TextStyle(color: AppColors.white),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                ),
                onPressed: () {
                  // context.read<EventBloc>().add(EventCancel(id: event.id));
                },
                child: const Text(
                  'Xem',
                  style: TextStyle(color: AppColors.white),
                )),
          ],
        );
      }
    } else {
      return Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: const Text('Sự kiện đã kết thúc!',
            style: TextStyle(color: AppColors.white)),
      );
    }
  }

  // show qr code dialog
  void showQrCodeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Mã QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mỗi mã QR được tạo ra sẽ chỉ tồn tại và hợp lệ trong vòng 30 giây'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // button create qr
                  ElevatedButton(
                    onPressed: () {
                      var now = DateTime.now();

                      if (now.isBefore(event.startAt)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sự kiện chưa bắt đầu'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      } else if (now.isAfter(event.endAt)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sự kiện đã kết thúc'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      } else {
                        Navigator.of(context).pop();
                      }
                      // context.read<EventBloc>().add(EventCreateQrCode(eventId: event.id));
                    },
                    child: const Text('Mã check in'),
                  ),
                  if (event.checkoutQrCode != null)
                  ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: const Text('Mã check out'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  // show qr code pattern dialog
  void showQrCodePatternDialog({bool isCheckIn = true}) {
    var qrEvent = QrEvent(
      isTicketSeller: event.isTicketSeller,
      eventId: event.id,
      isCheckin: isCheckIn,
      code: '',
    );

    var timer = Timer(const Duration(seconds: 30), () => {
        context.read<EventBloc>().add(EventCreateQrCode(eventId: event.id, isCheckIn: isCheckIn))
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCheckIn ? 'Mã check in' : 'Mã check out'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // button create qr
                  ElevatedButton(
                    onPressed: () {
                      var now = DateTime.now();

                      if (now.isBefore(event.startAt)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sự kiện chưa bắt đầu'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      } else if (now.isAfter(event.endAt)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sự kiện đã kết thúc'),
                            backgroundColor: AppColors.red,
                          ),
                        );
                        return;
                      } else {
                        Navigator.of(context).pop();
                      }
                      // context.read<EventBloc>().add(EventCreateQrCode(eventId: event.id));
                    },
                    child: const Text('Mã check in'),
                  ),
                  if (event.checkoutQrCode != null)
                  ElevatedButton(
                    onPressed: () {
                      //
                    },
                    child: const Text('Mã check out'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

}