import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/features/registration/dtos/registration_detail_dto.dart';
import 'package:qr_checkin/utils/data_utils.dart';

import '../../config/router.dart';
import '../../config/theme.dart';

class RegistrationItem extends StatefulWidget {
  final RegistrationDetailDto registrationDetail;

  const RegistrationItem({super.key, required this.registrationDetail});

  @override
  State<RegistrationItem> createState() => _RegistrationItemState();
}

class _RegistrationItemState extends State<RegistrationItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.black12,
      focusColor: Colors.black12,
      highlightColor: Colors.black12,
      onTap: () {
        context.push(RouteName.eventDetail,
            extra: widget.registrationDetail.eventId);
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
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.registrationDetail.createdAt!.day.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tháng ${widget.registrationDetail.createdAt!.month}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.registrationDetail.createdAt!.year.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.registrationDetail.eventName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Xét duyệt: ${widget.registrationDetail.acceptedAt != null ? 'Đã duyệt' : 'Chưa duyệt'}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Check in: ${widget.registrationDetail.checkInAt != null ? formatDateTime(widget.registrationDetail.checkInAt!) : 'Chưa'}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  if (widget.registrationDetail.checkOutRequired)
                    Text(
                      'Check out: ${widget.registrationDetail.checkOutAt != null ? formatDateTime(widget.registrationDetail.checkOutAt!) : 'Chưa'}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  Text(
                    'Địa điểm: ${widget.registrationDetail.eventLocation}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
