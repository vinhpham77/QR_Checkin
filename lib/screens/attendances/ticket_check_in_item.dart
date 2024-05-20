import 'package:flutter/material.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_user_dto.dart';
import 'package:qr_checkin/utils/data_utils.dart';

import '../../config/theme.dart';
import '../../utils/image_utils.dart';

class TicketCheckInItem extends StatefulWidget {
  final TicketUserDto ticketCheckIns;

  const TicketCheckInItem({super.key, required this.ticketCheckIns});

  @override
  State<TicketCheckInItem> createState() => _TicketCheckInItemState();
}

class _TicketCheckInItemState extends State<TicketCheckInItem> {
  String get sex {
    if (widget.ticketCheckIns.sex == null) {
      return 'Khác';
    } else if (widget.ticketCheckIns.sex!) {
      return 'Nam';
    } else {
      return 'Nữ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.black12,
      focusColor: Colors.black12,
      highlightColor: Colors.black12,
      onTap: () {},
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
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  height: 76,
                  width: 76,
                  child: Image.network(
                    getImageUrl(widget.ticketCheckIns.avatar),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.ticketCheckIns.fullName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.ticketCheckIns.fullName != null)
                          const SizedBox(width: 8),
                        Text(
                          '@${widget.ticketCheckIns.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Email: ${widget.ticketCheckIns.email}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Loại vé: ${widget.ticketCheckIns.ticketType}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Thời gian mua: ${formatDateTime(widget.ticketCheckIns.createdAt!)}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Check in: ${formatDateTime(widget.ticketCheckIns.checkInAt!)}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
