import 'package:flutter/material.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_user_dto.dart';
import 'package:qr_checkin/utils/data_utils.dart';

import '../../config/theme.dart';
import '../../utils/image_utils.dart';

class TicketBuyerItem extends StatefulWidget {
  final TicketUserDto ticketBuyer;

  const TicketBuyerItem({super.key, required this.ticketBuyer});

  @override
  State<TicketBuyerItem> createState() => _TicketBuyerItemState();
}

class _TicketBuyerItemState extends State<TicketBuyerItem> {
  String get sex {
    if (widget.ticketBuyer.sex == null) {
      return 'Khác';
    } else if (widget.ticketBuyer.sex!) {
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
                    getImageUrl(widget.ticketBuyer.avatar),
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
                          widget.ticketBuyer.fullName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.ticketBuyer.fullName != null)
                          const SizedBox(width: 8),
                        Text(
                          '@${widget.ticketBuyer.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Email: ${widget.ticketBuyer.email}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Loại vé: ${widget.ticketBuyer.ticketType}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Thời gian mua: ${formatDateTime(widget.ticketBuyer.createdAt!)}',
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
