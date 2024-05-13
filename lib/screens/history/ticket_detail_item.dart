import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_detail_dto.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../config/router.dart';
import '../../config/theme.dart';
import '../../features/qr_event.dart';
import '../../utils/data_utils.dart';

class TicketDetailItem extends StatefulWidget {
  final TicketDetailDto ticketDetail;

  const TicketDetailItem({super.key, required this.ticketDetail});

  @override
  State<TicketDetailItem> createState() => _TicketDetailItemState();
}

class _TicketDetailItemState extends State<TicketDetailItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.black12,
      focusColor: Colors.black12,
      highlightColor: Colors.black12,
      onTap: () {
        context.push(RouteName.eventDetail, extra: widget.ticketDetail.eventId);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.ticketDetail.createdAt!.day.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Tháng ${widget.ticketDetail.createdAt!.month}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      widget.ticketDetail.createdAt!.year.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ticketDetail.eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Loại vé: ${widget.ticketDetail.ticketTypeName}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Giá: ${formatPrice(widget.ticketDetail.price)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      widget.ticketDetail.checkInAt == null ? 'Chưa sử dụng' : 'Check in lúc:${formatDateTime(widget.ticketDetail.checkInAt!)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Địa điểm: ${widget.ticketDetail.location}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              ],
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4),
                            const Text(
                              'Mã QR',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            QrImageView(
                                errorCorrectionLevel: QrErrorCorrectLevel.M,
                                size: 240,
                                version: 10,
                                data: QrEvent(
                                  isTicketSeller: true,
                                  eventId: widget.ticketDetail.eventId,
                                  isCheckin: true,
                                  code: widget.ticketDetail.qrCode,
                                ).toString()),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.qr_code),
            ),
          ],
        ),
      ),
    );
  }
}
